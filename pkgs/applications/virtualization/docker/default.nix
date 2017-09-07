{ stdenv, lib, fetchFromGitHub, makeWrapper, removeReferencesTo, pkgconfig
, go-md2man, go, containerd, runc, docker-proxy, tini, libtool
, sqlite, iproute, bridge-utils, devicemapper, systemd
, btrfs-progs, iptables, e2fsprogs, xz, utillinux, xfsprogs
, procps, libseccomp
}:

with lib;

rec {
  dockerGen = {
      version, rev, sha256
      , runcRev, runcSha256
      , containerdRev, containerdSha256
      , tiniRev, tiniSha256
  } : stdenv.mkDerivation rec {
    inherit version rev;

    name = "docker-${version}";

    src = fetchFromGitHub {
      owner = "docker";
      repo = "docker-ce";
      rev = "v${version}";
      sha256 = sha256;
    };

    docker-runc = runc.overrideAttrs (oldAttrs: rec {
      name = "docker-runc";
      src = fetchFromGitHub {
        owner = "docker";
        repo = "runc";
        rev = runcRev;
        sha256 = runcSha256;
      };
      # docker/runc already include these patches / are not applicable
      patches = [];
    });
    docker-containerd = containerd.overrideAttrs (oldAttrs: rec {
      name = "docker-containerd";
      src = fetchFromGitHub {
        owner = "docker";
        repo = "containerd";
        rev = containerdRev;
        sha256 = containerdSha256;
      };
    });
    docker-tini = tini.overrideAttrs  (oldAttrs: rec {
      name = "docker-init";
      src = fetchFromGitHub {
        owner = "krallin";
        repo = "tini";
        rev = tiniRev;
        sha256 = tiniSha256;
      };

      # Do not remove static from make files as we want a static binary
      patchPhase = ''
      '';

      NIX_CFLAGS_COMPILE = [
        "-DMINIMAL=ON"
      ];
    });

    # Optimizations break compilation of libseccomp c bindings
    hardeningDisable = [ "fortify" ];

    buildInputs = [
      makeWrapper removeReferencesTo pkgconfig go-md2man go
      sqlite devicemapper btrfs-progs systemd libtool libseccomp
    ];

    dontStrip = true;

    DOCKER_BUILDTAGS = []
      ++ optional (systemd != null) [ "journald" ]
      ++ optional (btrfs-progs == null) "exclude_graphdriver_btrfs"
      ++ optional (devicemapper == null) "exclude_graphdriver_devicemapper"
      ++ optional (libseccomp != null) "seccomp";

    buildPhase = ''
      # build engine
      cd ./components/engine
      export AUTO_GOPATH=1
      export DOCKER_GITCOMMIT="${rev}"
      ./hack/make.sh dynbinary
      cd -

      # build cli
      cd ./components/cli
      # Mimic AUTO_GOPATH
      mkdir -p .gopath/src/github.com/docker/
      ln -sf $PWD .gopath/src/github.com/docker/cli
      export GOPATH="$PWD/.gopath:$GOPATH"
      export GITCOMMIT="${rev}"
      export VERSION="${version}"
      source ./scripts/build/.variables
      export CGO_ENABLED=1
      go build -tags pkcs11 --ldflags "$LDFLAGS" github.com/docker/cli/cmd/docker
      cd -
    '';

    # systemd 230 no longer has libsystemd-journal as a separate entity from libsystemd
    patchPhase = ''
      patchShebangs .
      substituteInPlace ./components/engine/hack/make.sh                   --replace libsystemd-journal libsystemd
      substituteInPlace ./components/engine/daemon/logger/journald/read.go --replace libsystemd-journal libsystemd
      substituteInPlace ./components/cli/scripts/build/.variables --replace "set -eu" ""
     '';

    outputs = ["out" "man"];

    extraPath = makeBinPath [ iproute iptables e2fsprogs xz xfsprogs procps utillinux ];

    installPhase = ''
      install -Dm755 ./components/cli/docker $out/libexec/docker/docker
      install -Dm755 ./components/engine/bundles/${version}/dynbinary-daemon/dockerd-${version} $out/libexec/docker/dockerd
      makeWrapper $out/libexec/docker/docker $out/bin/docker \
        --prefix PATH : "$out/libexec/docker:$extraPath"
      makeWrapper $out/libexec/docker/dockerd $out/bin/dockerd \
        --prefix PATH : "$out/libexec/docker:$extraPath"

      # docker uses containerd now
      ln -s ${docker-containerd}/bin/containerd $out/libexec/docker/docker-containerd
      ln -s ${docker-containerd}/bin/containerd-shim $out/libexec/docker/docker-containerd-shim
      ln -s ${docker-runc}/bin/runc $out/libexec/docker/docker-runc
      ln -s ${docker-proxy}/bin/docker-proxy $out/libexec/docker/docker-proxy
      ln -s ${docker-tini}/bin/tini-static $out/libexec/docker/docker-init

      # systemd
      install -Dm644 ./components/engine/contrib/init/systemd/docker.service $out/etc/systemd/system/docker.service

      # completion (cli)
      install -Dm644 ./components/cli/contrib/completion/bash/docker $out/share/bash-completion/completions/docker
      install -Dm644 ./components/cli/contrib/completion/fish/docker.fish $out/share/fish/vendor_completions.d/docker.fish
      install -Dm644 ./components/cli/contrib/completion/zsh/_docker $out/share/zsh/site-functions/_docker

      # Include contributed man pages (cli)
      # Generate man pages from cobra commands
      echo "Generate man pages from cobra"
      cd ./components/cli
      mkdir -p ./man/man1
      go build -o ./gen-manpages github.com/docker/cli/man
      ./gen-manpages --root . --target ./man/man1

      # Generate legacy pages from markdown
      echo "Generate legacy manpages"
      ./man/md2man-all.sh -q

      manRoot="$man/share/man"
      mkdir -p "$manRoot"
      for manDir in ./man/man?; do
        manBase="$(basename "$manDir")" # "man1"
        for manFile in "$manDir"/*; do
          manName="$(basename "$manFile")" # "docker-build.1"
          mkdir -p "$manRoot/$manBase"
          gzip -c "$manFile" > "$manRoot/$manBase/$manName.gz"
        done
      done
    '';

    preFixup = ''
      find $out -type f -exec remove-references-to -t ${go} -t ${stdenv.cc.cc} -t ${stdenv.glibc.dev} '{}' +
    '';

    meta = {
      homepage = https://www.docker.com/;
      description = "An open source project to pack, ship and run any application as a lightweight container";
      license = licenses.asl20;
      maintainers = with maintainers; [ offline tailhook vdemeester ];
      platforms = platforms.linux;
    };
  };

  # Get revisions from
  # https://github.com/docker/docker-ce/blob/v${version}/components/engine/hack/dockerfile/binaries-commits

  docker_17_06 = dockerGen rec {
    version = "17.06.2-ce";
    rev = "cec0b72a9940e047e945a09e1febd781e88366d6"; # git commit
    sha256 = "1scqx28vzh72ziq00lbx92vsb896mj974j8f0zg11y6qc5n5jx3l";
    runcRev = "810190ceaa507aa2727d7ae6f4790c76ec150bd2";
    runcSha256 = "0f1x1z262qg579qb1w21axj3mibq4fbff3gamliw49sdqqnb7vk3";
    containerdRev = "6e23458c129b551d5c9871e5174f6b1b7f6d1170";
    containerdSha256 = "12kzc5z1nhxdbizzr494ywilbs6rdv39v5ql7lmfzwh350gwlg93";
    tiniRev = "949e6facb77383876aeff8a6944dde66b3089574";
    tiniSha256 = "0zj4kdis1vvc6dwn4gplqna0bs7v6d1y2zc8v80s3zi018inhznw";
  };

  docker_17_07 = dockerGen rec {
    version = "17.07.0-ce";
    rev = "87847530f7176a48348d196f7c23bbd058052af1"; # git commit
    sha256 = "0zw9zlzbd7il33ch17ypwpa73gsb930sf2njnphg7ylvnqp8qzsp";
    runcRev = "2d41c047c83e09a6d61d464906feb2a2f3c52aa4";
    runcSha256 = "0v5iv29ck6lkxvxh7a56gfrlgfs0bjvjhrq3p6qqv9qjzv825byq";
    containerdRev = "3addd840653146c90a254301d6c3a663c7fd6429";
    containerdSha256 = "0as4s5wd57pdh1cyavkccpgs46kvlhr41v07qrv0phzffdhq3d5j";
    tiniRev = "949e6facb77383876aeff8a6944dde66b3089574";
    tiniSha256 = "0zj4kdis1vvc6dwn4gplqna0bs7v6d1y2zc8v80s3zi018inhznw";
  };
}

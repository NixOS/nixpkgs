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
    } :
  let
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

      hardeningDisable = [ "fortify" ];

      buildInputs = [ removeReferencesTo go btrfs-progs ];
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
  in
    stdenv.mkDerivation ((optionalAttrs (stdenv.isLinux) rec {

    inherit docker-runc docker-containerd docker-proxy docker-tini;

    DOCKER_BUILDTAGS = []
      ++ optional (systemd != null) [ "journald" ]
      ++ optional (btrfs-progs == null) "exclude_graphdriver_btrfs"
      ++ optional (devicemapper == null) "exclude_graphdriver_devicemapper"
      ++ optional (libseccomp != null) "seccomp";

   }) // rec {
    inherit version rev;

    name = "docker-${version}";

    src = fetchFromGitHub {
      owner = "docker";
      repo = "docker-ce";
      rev = "v${version}";
      sha256 = sha256;
    };

    # Optimizations break compilation of libseccomp c bindings
    hardeningDisable = [ "fortify" ];

    nativeBuildInputs = [ pkgconfig ];
    buildInputs = [
      makeWrapper removeReferencesTo go-md2man go libtool
    ] ++ optionals (stdenv.isLinux) [
      sqlite devicemapper btrfs-progs systemd libseccomp
    ];

    dontStrip = true;

    buildPhase = (optionalString (stdenv.isLinux) ''
      # build engine
      cd ./components/engine
      export AUTO_GOPATH=1
      export DOCKER_GITCOMMIT="${rev}"
      export VERSION="${version}"
      ./hack/make.sh dynbinary
      cd -
    '') + ''
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
      substituteInPlace ./components/cli/scripts/build/.variables --replace "set -eu" ""
    '' + optionalString (stdenv.isLinux) ''
      patchShebangs .
      substituteInPlace ./components/engine/hack/make.sh                   --replace libsystemd-journal libsystemd
      substituteInPlace ./components/engine/daemon/logger/journald/read.go --replace libsystemd-journal libsystemd
    '';

    outputs = ["out" "man"];

    extraPath = optionals (stdenv.isLinux) (makeBinPath [ iproute iptables e2fsprogs xz xfsprogs procps utillinux ]);

    installPhase = optionalString (stdenv.isLinux) ''
      install -Dm755 ./components/engine/bundles/dynbinary-daemon/dockerd $out/libexec/docker/dockerd

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
    '' + ''
      install -Dm755 ./components/cli/docker $out/libexec/docker/docker

      makeWrapper $out/libexec/docker/docker $out/bin/docker \
        --prefix PATH : "$out/libexec/docker:$extraPath"

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
      find $out -type f -exec remove-references-to -t ${go} -t ${stdenv.cc.cc} '{}' +
    '' + optionalString (stdenv.isLinux) ''
      find $out -type f -exec remove-references-to -t ${stdenv.glibc.dev} '{}' +
    '';

    meta = {
      homepage = https://www.docker.com/;
      description = "An open source project to pack, ship and run any application as a lightweight container";
      license = licenses.asl20;
      maintainers = with maintainers; [ nequissimus offline tailhook vdemeester periklis ];
      platforms = with platforms; linux ++ darwin;
    };
  });

  # Get revisions from
  # https://github.com/docker/docker-ce/tree/v${version}/components/engine/hack/dockerfile/install/*

  docker_18_03 = dockerGen rec {
    version = "18.03.1-ce";
    rev = "9ee9f402cd1eba817c5591a64f1d770c87c421a4"; # git commit
    sha256 = "1jm3jmcbkvvy3s8pi3xcpir6mwxjfbad46lbif4bnpjfd2r5irrx";
    runcRev = "4fc53a81fb7c994640722ac585fa9ca548971871";
    runcSha256 = "1ikqw39jn8dzb4snc4pcg3z85jb67ivskdhx028k17ss29bf4062";
    containerdRev = "773c489c9c1b21a6d78b5c538cd395416ec50f88";
    containerdSha256 = "0k1zjn0mpd7q3p5srxld2fr4k6ijzbk0r34r6w69sh0d0rd2fvbs";
    tiniRev = "949e6facb77383876aeff8a6944dde66b3089574";
    tiniSha256 = "0zj4kdis1vvc6dwn4gplqna0bs7v6d1y2zc8v80s3zi018inhznw";
  };

  docker_18_04 = dockerGen rec {
    version = "18.04.0-ce";
    rev = "3d479c0af67cb9ea43a9cfc1bf2ef097e06a3470"; # git commit
    sha256 = "1askbk8b92cdv7vlm688g2f1v2xjhmx77578318x76dydfql3jfl";
    runcRev = "4fc53a81fb7c994640722ac585fa9ca548971871";
    runcSha256 = "1ikqw39jn8dzb4snc4pcg3z85jb67ivskdhx028k17ss29bf4062";
    containerdRev = "773c489c9c1b21a6d78b5c538cd395416ec50f88";
    containerdSha256 = "0k1zjn0mpd7q3p5srxld2fr4k6ijzbk0r34r6w69sh0d0rd2fvbs";
    tiniRev = "949e6facb77383876aeff8a6944dde66b3089574";
    tiniSha256 = "0zj4kdis1vvc6dwn4gplqna0bs7v6d1y2zc8v80s3zi018inhznw";
  };
}

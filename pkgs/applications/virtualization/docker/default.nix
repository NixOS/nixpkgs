{ stdenv, lib, fetchFromGitHub, fetchpatch, buildGoPackage
, makeWrapper, removeReferencesTo, installShellFiles, pkgconfig
, go-md2man, go, containerd, runc, docker-proxy, tini, libtool
, sqlite, iproute, lvm2, systemd
, btrfs-progs, iptables, e2fsprogs, xz, utillinux, xfsprogs, git
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
    docker-runc = runc.overrideAttrs (oldAttrs: {
      name = "docker-runc-${version}";
      inherit version;
      src = fetchFromGitHub {
        owner = "opencontainers";
        repo = "runc";
        rev = runcRev;
        sha256 = runcSha256;
      };
      # docker/runc already include these patches / are not applicable
      patches = [];
    });

    docker-containerd = containerd.overrideAttrs (oldAttrs: {
      name = "docker-containerd-${version}";
      inherit version;
      src = fetchFromGitHub {
        owner = "docker";
        repo = "containerd";
        rev = containerdRev;
        sha256 = containerdSha256;
      };
    });

    docker-tini = tini.overrideAttrs  (oldAttrs: {
      name = "docker-init-${version}";
      inherit version;
      src = fetchFromGitHub {
        owner = "krallin";
        repo = "tini";
        rev = tiniRev;
        sha256 = tiniSha256;
      };

      # Do not remove static from make files as we want a static binary
      patchPhase = ''
      '';

      NIX_CFLAGS_COMPILE = "-DMINIMAL=ON";
    });
  in
    buildGoPackage ((optionalAttrs (stdenv.isLinux) {

    inherit docker-runc docker-containerd docker-proxy docker-tini;

    DOCKER_BUILDTAGS = []
      ++ optional (systemd != null) [ "journald" ]
      ++ optional (btrfs-progs == null) "exclude_graphdriver_btrfs"
      ++ optional (lvm2 == null) "exclude_graphdriver_devicemapper"
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

    patches = lib.optional (versionAtLeast version "19.03") [
      # Replace hard-coded cross-compiler with $CC
      (fetchpatch {
        url = https://github.com/docker/docker-ce/commit/2fdfb4404ab811cb00227a3de111437b829e55cf.patch;
        sha256 = "1af20bzakhpfhaixc29qnl9iml9255xdinxdnaqp4an0n1xa686a";
      })
    ];

    goPackagePath = "github.com/docker/docker-ce";

    nativeBuildInputs = [ pkgconfig go-md2man go libtool removeReferencesTo installShellFiles ];
    buildInputs = [
      makeWrapper
    ] ++ optionals (stdenv.isLinux) [
      sqlite lvm2 btrfs-progs systemd libseccomp
    ];

    dontStrip = true;

    buildPhase = ''
      export GOCACHE="$TMPDIR/go-cache"
    '' + (optionalString (stdenv.isLinux) ''
      # build engine
      cd ./go/src/${goPackagePath}/components/engine
      export AUTO_GOPATH=1
      export DOCKER_GITCOMMIT="${rev}"
      export VERSION="${version}"
      ./hack/make.sh dynbinary
      cd -
    '') + ''
      # build cli
      cd ./go/src/${goPackagePath}/components/cli
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
    postPatch = ''
      substituteInPlace ./components/cli/scripts/build/.variables --replace "set -eu" ""
    '' + optionalString (stdenv.isLinux) ''
      patchShebangs .
      substituteInPlace ./components/engine/hack/make.sh                   --replace libsystemd-journal libsystemd
      substituteInPlace ./components/engine/daemon/logger/journald/read.go --replace libsystemd-journal libsystemd
    '';

    outputs = ["out" "man"];

    extraPath = optionals (stdenv.isLinux) (makeBinPath [ iproute iptables e2fsprogs xz xfsprogs procps utillinux git ]);

    installPhase = ''
      cd ./go/src/${goPackagePath}
      install -Dm755 ./components/cli/docker $out/libexec/docker/docker

      makeWrapper $out/libexec/docker/docker $out/bin/docker \
        --prefix PATH : "$out/libexec/docker:$extraPath"
    '' + optionalString (stdenv.isLinux) ''
      install -Dm755 ./components/engine/bundles/dynbinary-daemon/dockerd $out/libexec/docker/dockerd

      makeWrapper $out/libexec/docker/dockerd $out/bin/dockerd \
        --prefix PATH : "$out/libexec/docker:$extraPath"

      # docker uses containerd now
      ln -s ${docker-containerd}/bin/containerd $out/libexec/docker/containerd
      ln -s ${docker-containerd}/bin/containerd-shim $out/libexec/docker/containerd-shim
      ln -s ${docker-runc}/bin/runc $out/libexec/docker/runc
      ln -s ${docker-proxy}/bin/docker-proxy $out/libexec/docker/docker-proxy
      ln -s ${docker-tini}/bin/tini-static $out/libexec/docker/docker-init

      # systemd
      install -Dm644 ./components/engine/contrib/init/systemd/docker.service $out/etc/systemd/system/docker.service
    '' + ''
      # completion (cli)
      installShellCompletion --bash ./components/cli/contrib/completion/bash/docker
      installShellCompletion --fish ./components/cli/contrib/completion/fish/docker.fish
      installShellCompletion --zsh ./components/cli/contrib/completion/zsh/_docker

      # Include contributed man pages (cli)
      cd ./components/cli
    '' + lib.optionalString (stdenv.hostPlatform == stdenv.buildPlatform) ''
      # Generate man pages from cobra commands
      echo "Generate man pages from cobra"
      mkdir -p ./man/man1
      go build -o ./gen-manpages github.com/docker/cli/man
      ./gen-manpages --root . --target ./man/man1
    '' + ''
      # Generate legacy pages from markdown
      echo "Generate legacy manpages"
      ./man/md2man-all.sh -q

      installManPage man/*/*.[1-9]
    '';

    preFixup = ''
      find $out -type f -exec remove-references-to -t ${stdenv.cc.cc} '{}' +
    '' + optionalString (stdenv.isLinux) ''
      find $out -type f -exec remove-references-to -t ${stdenv.glibc.dev} '{}' +
    '';

    meta = {
      homepage = "https://www.docker.com/";
      description = "An open source project to pack, ship and run any application as a lightweight container";
      license = licenses.asl20;
      maintainers = with maintainers; [ nequissimus offline tailhook vdemeester periklis ];
      platforms = with platforms; linux ++ darwin;
    };
  });

  # Get revisions from
  # https://github.com/docker/docker-ce/tree/${version}/components/engine/hack/dockerfile/install/*

  docker_18_09 = makeOverridable dockerGen rec {
    version = "18.09.9";
    rev = "v${version}";
    sha256 = "0wqhjx9qs96q2jd091wffn3cyv2aslqn2cvpdpgljk8yr9s0yg7h";
    runcRev = "3e425f80a8c931f88e6d94a8c831b9d5aa481657";
    runcSha256 = "18psc830b2rkwml1x6vxngam5b5wi3pj14mw817rshpzy87prspj";
    containerdRev = "894b81a4b802e4eb2a91d1ce216b8817763c29fb";
    containerdSha256 = "0sp5mn5wd3xma4svm6hf67hyhiixzkzz6ijhyjkwdrc4alk81357";
    tiniRev = "fec3683b971d9c3ef73f284f176672c44b448662";
    tiniSha256 = "1h20i3wwlbd8x4jr2gz68hgklh0lb0jj7y5xk1wvr8y58fip1rdn";
  };

  docker_19_03 = makeOverridable dockerGen rec {
    version = "19.03.12";
    rev = "v${version}";
    sha256 = "0i5xr8q3yjrz5zsjcq63v4g1mzqpingjr1hbf9amk14484i2wkw7";
    runcRev = "dc9208a3303feef5b3839f4323d9beb36df0a9dd"; # v1.0.0-rc10
    runcSha256 = "0pi3rvj585997m4z9ljkxz2z9yxf9p2jr0pmqbqrc7bc95f5hagk";
    containerdRev = "7ad184331fa3e55e52b890ea95e65ba581ae3429"; # v1.2.13
    containerdSha256 = "1rac3iak3jpz57yarxc72bxgxvravwrl0j6s6w2nxrmh2m3kxqzn";
    tiniRev = "fec3683b971d9c3ef73f284f176672c44b448662"; # v0.18.0
    tiniSha256 = "1h20i3wwlbd8x4jr2gz68hgklh0lb0jj7y5xk1wvr8y58fip1rdn";
  };
}

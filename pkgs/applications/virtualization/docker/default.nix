{ lib, callPackage, fetchFromGitHub }:

rec {
  dockerGen = {
      version
      , cliRev, cliHash
      , mobyRev, mobyHash
      , runcRev, runcHash
      , containerdRev, containerdHash
      , tiniRev, tiniHash
      , buildxSupport ? true, composeSupport ? true, sbomSupport ? false
      # package dependencies
      , stdenv, fetchFromGitHub, fetchpatch, buildGoPackage
      , makeWrapper, installShellFiles, pkg-config, glibc
      , go-md2man, go, containerd, runc, docker-proxy, tini, libtool
      , sqlite, iproute2, docker-buildx, docker-compose, docker-sbom
      , iptables, e2fsprogs, xz, util-linux, xfsprogs, git
      , procps, rootlesskit, slirp4netns, fuse-overlayfs, nixosTests
      , clientOnly ? !stdenv.isLinux, symlinkJoin
      , withSystemd ? lib.meta.availableOn stdenv.hostPlatform systemd, systemd
      , withBtrfs ? stdenv.isLinux, btrfs-progs
      , withLvm ? stdenv.isLinux, lvm2
      , withSeccomp ? stdenv.isLinux, libseccomp
    }:
  let
    docker-runc = runc.overrideAttrs (oldAttrs: {
      pname = "docker-runc";
      inherit version;

      src = fetchFromGitHub {
        owner = "opencontainers";
        repo = "runc";
        rev = runcRev;
        hash = runcHash;
      };

      # docker/runc already include these patches / are not applicable
      patches = [];
    });

    docker-containerd = containerd.overrideAttrs (oldAttrs: {
      pname = "docker-containerd";
      inherit version;

      src = fetchFromGitHub {
        owner = "containerd";
        repo = "containerd";
        rev = containerdRev;
        hash = containerdHash;
      };

      buildInputs = oldAttrs.buildInputs
        ++ lib.optionals withSeccomp [ libseccomp ];
    });

    docker-tini = tini.overrideAttrs (oldAttrs: {
      pname = "docker-init";
      inherit version;

      src = fetchFromGitHub {
        owner = "krallin";
        repo = "tini";
        rev = tiniRev;
        hash = tiniHash;
      };

      # Do not remove static from make files as we want a static binary
      postPatch = "";

      buildInputs = [ glibc glibc.static ];

      env.NIX_CFLAGS_COMPILE = "-DMINIMAL=ON";
    });

    moby-src = fetchFromGitHub {
      owner = "moby";
      repo = "moby";
      rev = mobyRev;
      hash = mobyHash;
    };

    moby = buildGoPackage (lib.optionalAttrs stdenv.isLinux rec {
      pname = "moby";
      inherit version;

      src = moby-src;

      goPackagePath = "github.com/docker/docker";

      nativeBuildInputs = [ makeWrapper pkg-config go-md2man go libtool installShellFiles ];
      buildInputs = [ sqlite ]
        ++ lib.optional withLvm lvm2
        ++ lib.optional withBtrfs btrfs-progs
        ++ lib.optional withSystemd systemd
        ++ lib.optional withSeccomp libseccomp;

      extraPath = lib.optionals stdenv.isLinux (lib.makeBinPath [ iproute2 iptables e2fsprogs xz xfsprogs procps util-linux git ]);

      extraUserPath = lib.optionals (stdenv.isLinux && !clientOnly) (lib.makeBinPath [ rootlesskit slirp4netns fuse-overlayfs ]);

      patches = lib.optionals (lib.versionOlder version "23") [
        # This patch incorporates code from a PR fixing using buildkit with the ZFS graph driver.
        # It could be removed when a version incorporating this patch is released.
        (fetchpatch {
          name = "buildkit-zfs.patch";
          url = "https://github.com/moby/moby/pull/43136.patch";
          hash = "sha256-1WZfpVnnqFwLMYqaHLploOodls0gHF8OCp7MrM26iX8=";
        })
      ] ++ lib.optionals (lib.versionOlder version "23.0.5") [
        (fetchpatch {
          name = "fix-issue-with-go-1.20.6.patch";
          url = "https://github.com/moby/moby/pull/45972.patch";
          hash = "sha256-zxFh/bI6+INOYSg6QFs0S9rdl9Z21KUIZFmzpNVjpSA=";
        })
      ];

      postPatch = ''
        patchShebangs hack/make.sh hack/make/
      '';

      buildPhase = ''
        export GOCACHE="$TMPDIR/go-cache"
        # build engine
        cd ./go/src/${goPackagePath}
        export AUTO_GOPATH=1
        export DOCKER_GITCOMMIT="${cliRev}"
        export VERSION="${version}"
        ./hack/make.sh dynbinary
        cd -
      '';

      installPhase = ''
        cd ./go/src/${goPackagePath}
        install -Dm755 ./bundles/dynbinary-daemon/dockerd $out/libexec/docker/dockerd

        makeWrapper $out/libexec/docker/dockerd $out/bin/dockerd \
          --prefix PATH : "$out/libexec/docker:$extraPath"

        ln -s ${docker-containerd}/bin/containerd $out/libexec/docker/containerd
        ln -s ${docker-containerd}/bin/containerd-shim $out/libexec/docker/containerd-shim
        ln -s ${docker-runc}/bin/runc $out/libexec/docker/runc
        ln -s ${docker-proxy}/bin/docker-proxy $out/libexec/docker/docker-proxy
        ln -s ${docker-tini}/bin/tini-static $out/libexec/docker/docker-init

        # systemd
        install -Dm644 ./contrib/init/systemd/docker.service $out/etc/systemd/system/docker.service
        substituteInPlace $out/etc/systemd/system/docker.service --replace /usr/bin/dockerd $out/bin/dockerd
        install -Dm644 ./contrib/init/systemd/docker.socket $out/etc/systemd/system/docker.socket

        # rootless Docker
        install -Dm755 ./contrib/dockerd-rootless.sh $out/libexec/docker/dockerd-rootless.sh
        makeWrapper $out/libexec/docker/dockerd-rootless.sh $out/bin/dockerd-rootless \
          --prefix PATH : "$out/libexec/docker:$extraPath:$extraUserPath"
      '';

      DOCKER_BUILDTAGS = lib.optional withSystemd "journald"
        ++ lib.optional (!withBtrfs) "exclude_graphdriver_btrfs"
        ++ lib.optional (!withLvm) "exclude_graphdriver_devicemapper"
        ++ lib.optional withSeccomp "seccomp";
    });

    plugins = lib.optional buildxSupport docker-buildx
      ++ lib.optional composeSupport docker-compose
      ++ lib.optional sbomSupport docker-sbom;
    pluginsRef = symlinkJoin { name = "docker-plugins"; paths = plugins; };
  in
  buildGoPackage (lib.optionalAttrs (!clientOnly) {
    # allow overrides of docker components
    # TODO: move packages out of the let...in into top-level to allow proper overrides
    inherit docker-runc docker-containerd docker-proxy docker-tini moby;
  } // rec {
    pname = "docker";
    inherit version;

    src = fetchFromGitHub {
      owner = "docker";
      repo = "cli";
      rev = cliRev;
      hash = cliHash;
    };

    goPackagePath = "github.com/docker/cli";

    nativeBuildInputs = [
      makeWrapper pkg-config go-md2man go libtool installShellFiles
    ];

    buildInputs = plugins ++ lib.optionals (lib.versionAtLeast version "23") [
      glibc
      glibc.static
    ];

    patches = lib.optionals (lib.versionOlder version "23.0.5") [
      (fetchpatch {
        name = "fix-issue-with-go-1.20.6.patch";
        url = "https://github.com/docker/cli/pull/4441.patch";
        hash = "sha256-F4ueSbdBk1w8OqC4Dgh8+4Ql4zTjehaM368ET7k6Yx8=";
      })
    ];

    postPatch = ''
      patchShebangs man scripts/build/
      substituteInPlace ./scripts/build/.variables --replace "set -eu" ""
    '' + lib.optionalString (plugins != []) ''
      substituteInPlace ./cli-plugins/manager/manager_unix.go --replace /usr/libexec/docker/cli-plugins \
          "${pluginsRef}/libexec/docker/cli-plugins"
    '';

    # Keep eyes on BUILDTIME format - https://github.com/docker/cli/blob/${version}/scripts/build/.variables
    buildPhase = ''
      export GOCACHE="$TMPDIR/go-cache"

      cd ./go/src/${goPackagePath}
      # Mimic AUTO_GOPATH
      mkdir -p .gopath/src/github.com/docker/
      ln -sf $PWD .gopath/src/github.com/docker/cli
      export GOPATH="$PWD/.gopath:$GOPATH"
      export GITCOMMIT="${cliRev}"
      export VERSION="${version}"
      export BUILDTIME="1970-01-01T00:00:00Z"
      source ./scripts/build/.variables
      export CGO_ENABLED=1
      go build -tags pkcs11 --ldflags "$GO_LDFLAGS" github.com/docker/cli/cmd/docker
      cd -
    '';

    outputs = ["out"] ++ lib.optional (lib.versionOlder version "23") "man";

    installPhase = ''
      cd ./go/src/${goPackagePath}
      install -Dm755 ./docker $out/libexec/docker/docker

      makeWrapper $out/libexec/docker/docker $out/bin/docker \
        --prefix PATH : "$out/libexec/docker:$extraPath"
    '' + lib.optionalString (!clientOnly) ''
      # symlink docker daemon to docker cli derivation
      ln -s ${moby}/bin/dockerd $out/bin/dockerd
      ln -s ${moby}/bin/dockerd-rootless $out/bin/dockerd-rootless

      # systemd
      mkdir -p $out/etc/systemd/system
      ln -s ${moby}/etc/systemd/system/docker.service $out/etc/systemd/system/docker.service
      ln -s ${moby}/etc/systemd/system/docker.socket $out/etc/systemd/system/docker.socket
    '' + ''
      # completion (cli)
      installShellCompletion --bash ./contrib/completion/bash/docker
      installShellCompletion --fish ./contrib/completion/fish/docker.fish
      installShellCompletion --zsh  ./contrib/completion/zsh/_docker
    '' + lib.optionalString (stdenv.hostPlatform == stdenv.buildPlatform && lib.versionOlder version "23") ''
      # Generate man pages from cobra commands
      echo "Generate man pages from cobra"
      mkdir -p ./man/man1
      go build -o ./gen-manpages github.com/docker/cli/man
      ./gen-manpages --root . --target ./man/man1
    '' + lib.optionalString (lib.versionOlder version "23") ''
      # Generate legacy pages from markdown
      echo "Generate legacy manpages"
      ./man/md2man-all.sh -q

      installManPage man/*/*.[1-9]
    '';

    passthru = {
      # Exposed for tarsum build on non-linux systems (build-support/docker/default.nix)
      inherit moby-src;
      tests = lib.optionals (!clientOnly) { inherit (nixosTests) docker; };
    };

    meta = with lib; {
      homepage = "https://www.docker.com/";
      description = "An open source project to pack, ship and run any application as a lightweight container";
      longDescription = ''
        Docker is a platform designed to help developers build, share, and run modern applications.

        To enable the docker daemon on NixOS, set the `virtualisation.docker.enable` option to `true`.
      '';
      license = licenses.asl20;
      maintainers = with maintainers; [ offline vdemeester periklis amaxine ];
      mainProgram = "docker";
    };
  });

  # Get revisions from
  # https://github.com/moby/moby/tree/${version}/hack/dockerfile/install/*
  docker_20_10 = callPackage dockerGen rec {
    version = "20.10.25";
    cliRev = "v${version}";
    cliHash = "sha256-Wi/NHn8erqvKEVEJqkc99cO/sfPHptwMT44Savcuw2M=";
    mobyRev = "v${version}";
    mobyHash = "sha256-trJjQMYF/Uog7nvUlELyUYbsTPGz8Rn21v1/V5xhu+A=";
    runcRev = "v1.1.5";
    runcHash = "sha256-r5as3hb0zt+XPfxAPeH+YIc/n6IRlscPOZMGfhVE5C4=";
    containerdRev = "v1.6.20";
    containerdHash = "sha256-Nd3S6hmvA8LBFUN4XaQJMApbmwGIp6GTnFQimnYagZg=";
    tiniRev = "v0.19.0";
    tiniHash = "sha256-ZDKu/8yE5G0RYFJdhgmCdN3obJNyRWv6K/Gd17zc1sI=";
  };

  docker_24 = callPackage dockerGen rec {
    version = "24.0.5";
    cliRev = "v${version}";
    cliHash = "sha256-u1quVGTx/p8BDyRn33vYyyuE5BOhWMnGQ5uVX0PZ5mg=";
    mobyRev = "v${version}";
    mobyHash = "sha256-JQjRz1fHZlQRkNw/R8WWLV8caN3/U3mrKKQXbZt2crU=";
    runcRev = "v1.1.8";
    runcHash = "sha256-rDJYEc64KW4Qa3Eg2oUjJqIKrg6THb5hxQFFbvb9Zp4=";
    containerdRev = "v1.7.1";
    containerdHash = "sha256-WwedtcsrDQwMQcKFO5nnPiHyGJpl5hXZlmpbBe1/ftY=";
    tiniRev = "v0.19.0";
    tiniHash = "sha256-ZDKu/8yE5G0RYFJdhgmCdN3obJNyRWv6K/Gd17zc1sI=";
  };
}

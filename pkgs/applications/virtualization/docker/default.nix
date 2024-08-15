{ lib, callPackage }:

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
      , stdenv, fetchFromGitHub, fetchpatch, buildGoModule
      , makeWrapper, installShellFiles, pkg-config, glibc
      , go-md2man, go, containerd, runc, tini, libtool
      , sqlite, iproute2, docker-buildx, docker-compose, docker-sbom
      , iptables, e2fsprogs, xz, util-linux, xfsprogs, git
      , procps, rootlesskit, slirp4netns, fuse-overlayfs, nixosTests
      , clientOnly ? !stdenv.isLinux, symlinkJoin
      , withSystemd ? lib.meta.availableOn stdenv.hostPlatform systemd, systemd
      , withBtrfs ? stdenv.isLinux, btrfs-progs
      , withLvm ? stdenv.isLinux, lvm2
      , withSeccomp ? stdenv.isLinux, libseccomp
      , knownVulnerabilities ? []
    }:
  let
    docker-runc = runc.overrideAttrs {
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
    };

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

    docker-tini = tini.overrideAttrs {
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
    };

    moby-src = fetchFromGitHub {
      owner = "moby";
      repo = "moby";
      rev = mobyRev;
      hash = mobyHash;
    };

    moby = buildGoModule (lib.optionalAttrs stdenv.isLinux rec {
      pname = "moby";
      inherit version;

      src = moby-src;

      vendorHash = null;

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
      ] ++ lib.optionals (lib.versions.major version == "24") [
        # docker_24 has LimitNOFILE set to "infinity", which causes a wide variety of issues in containers.
        # Issues range from higher-than-usual ressource usage, to containers not starting at all.
        # This patch (part of the release candidates for docker_25) simply removes this unit option
        # making systemd use its default "1024:524288", which is sane. See commit message and/or the PR for
        # more details: https://github.com/moby/moby/pull/45534
        (fetchpatch {
          name = "LimitNOFILE-systemd-default.patch";
          url = "https://github.com/moby/moby/pull/45534/commits/c8930105bc9fc3c1a8a90886c23535cc6c41e130.patch";
          hash = "sha256-nyGLxFrJaD0TrDqsAwOD6Iph0aHcFH9sABj1Fy74sec=";
        })
      ];

      postPatch = ''
        patchShebangs hack/make.sh hack/make/ hack/with-go-mod.sh
      '';

      buildPhase = ''
        export GOCACHE="$TMPDIR/go-cache"
        # build engine
        export AUTO_GOPATH=1
        export DOCKER_GITCOMMIT="${cliRev}"
        export VERSION="${version}"
        ./hack/make.sh dynbinary
      '';

      installPhase = ''
        install -Dm755 ./bundles/dynbinary-daemon/dockerd $out/libexec/docker/dockerd
        install -Dm755 ./bundles/dynbinary-daemon/docker-proxy $out/libexec/docker/docker-proxy

        makeWrapper $out/libexec/docker/dockerd $out/bin/dockerd \
          --prefix PATH : "$out/libexec/docker:$extraPath"

        ln -s ${docker-containerd}/bin/containerd $out/libexec/docker/containerd
        ln -s ${docker-containerd}/bin/containerd-shim $out/libexec/docker/containerd-shim
        ln -s ${docker-runc}/bin/runc $out/libexec/docker/runc
        ln -s ${docker-tini}/bin/tini-static $out/libexec/docker/docker-init

        # systemd
        install -Dm644 ./contrib/init/systemd/docker.service $out/etc/systemd/system/docker.service
        substituteInPlace $out/etc/systemd/system/docker.service --replace-fail /usr/bin/dockerd $out/bin/dockerd
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
  buildGoModule (lib.optionalAttrs (!clientOnly) {
    # allow overrides of docker components
    # TODO: move packages out of the let...in into top-level to allow proper overrides
    inherit docker-runc docker-containerd docker-tini moby;
  } // rec {
    pname = "docker";
    inherit version;

    src = fetchFromGitHub {
      owner = "docker";
      repo = "cli";
      rev = cliRev;
      hash = cliHash;
    };

    vendorHash = null;

    nativeBuildInputs = [
      makeWrapper pkg-config go-md2man go libtool installShellFiles
    ];

    buildInputs = plugins ++ lib.optionals (lib.versionAtLeast version "23" && stdenv.isLinux) [
      glibc
      glibc.static
    ];

    postPatch = ''
      patchShebangs man scripts/build/
      substituteInPlace ./scripts/build/.variables --replace-fail "set -eu" ""
    '' + lib.optionalString (plugins != []) ''
      substituteInPlace ./cli-plugins/manager/manager_unix.go --replace-fail /usr/libexec/docker/cli-plugins \
          "${pluginsRef}/libexec/docker/cli-plugins"
    '';

    # Keep eyes on BUILDTIME format - https://github.com/docker/cli/blob/${version}/scripts/build/.variables
    buildPhase = ''
      export GOCACHE="$TMPDIR/go-cache"

      # Mimic AUTO_GOPATH
      mkdir -p .gopath/src/github.com/docker/
      ln -sf $PWD .gopath/src/github.com/docker/cli
      export GOPATH="$PWD/.gopath:$GOPATH"
      export GITCOMMIT="${cliRev}"
      export VERSION="${version}"
      export BUILDTIME="1970-01-01T00:00:00Z"
      make dynbinary

    '';

    outputs = ["out"] ++ lib.optional (lib.versionOlder version "23") "man";

    installPhase = ''
      install -Dm755 ./build/docker $out/libexec/docker/docker

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
      description = "Open source project to pack, ship and run any application as a lightweight container";
      longDescription = ''
        Docker is a platform designed to help developers build, share, and run modern applications.

        To enable the docker daemon on NixOS, set the `virtualisation.docker.enable` option to `true`.
      '';
      license = licenses.asl20;
      maintainers = with maintainers; [ offline vdemeester periklis teutat3s ];
      mainProgram = "docker";
      inherit knownVulnerabilities;
    };
  });

  # Get revisions from
  # https://github.com/moby/moby/tree/${version}/hack/dockerfile/install/*
  docker_24 = callPackage dockerGen rec {
    version = "24.0.9";
    cliRev = "v${version}";
    cliHash = "sha256-nXIZtE0X1OoQT908IGuRhVHb0tiLbqQLP0Md3YWt0/Q=";
    mobyRev = "v${version}";
    mobyHash = "sha256-KRS99heyMAPBnjjr7If8TOlJf6v6866S7J3YGkOhFiA=";
    runcRev = "v1.1.12";
    runcHash = "sha256-N77CU5XiGYIdwQNPFyluXjseTeaYuNJ//OsEUS0g/v0=";
    containerdRev = "v1.7.13";
    containerdHash = "sha256-y3CYDZbA2QjIn1vyq/p1F1pAVxQHi/0a6hGWZCRWzyk=";
    tiniRev = "v0.19.0";
    tiniHash = "sha256-ZDKu/8yE5G0RYFJdhgmCdN3obJNyRWv6K/Gd17zc1sI=";
    knownVulnerabilities = [
      "CVE-2024-23651"
      "CVE-2024-23652"
      "CVE-2024-23653"
      "CVE-2024-41110"
    ];
  };

  docker_25 = callPackage dockerGen rec {
    version = "25.0.6";
    cliRev = "v${version}";
    cliHash = "sha256-7ZKjlONL5RXEJZrvssrL1PQMNANP0qTw4myGKdtd19U=";
    mobyRev = "v${version}";
    mobyHash = "sha256-+zkhUMeVD3HNq8WrWQmLskq+HykvD5kzSACmf67YbJE=";
    runcRev = "v1.1.12";
    runcHash = "sha256-N77CU5XiGYIdwQNPFyluXjseTeaYuNJ//OsEUS0g/v0=";
    containerdRev = "v1.7.20";
    containerdHash = "sha256-Q9lTzz+G5PSoChy8MZtbOpO81AyNWXC+CgGkdOg14uY=";
    tiniRev = "v0.19.0";
    tiniHash = "sha256-ZDKu/8yE5G0RYFJdhgmCdN3obJNyRWv6K/Gd17zc1sI=";
  };

  docker_26 = callPackage dockerGen rec {
    version = "26.1.5";
    cliRev = "v${version}";
    cliHash = "sha256-UlN+Uc0YHhLyu14h5oDBXP4K9y2tYKPOIPTGZCe4PVY=";
    mobyRev = "v${version}";
    mobyHash = "sha256-6Hx7GnA7P6HqDlnGoc+HpPHSl69XezwAEGbvWYUVQlE=";
    runcRev = "v1.1.12";
    runcHash = "sha256-N77CU5XiGYIdwQNPFyluXjseTeaYuNJ//OsEUS0g/v0=";
    containerdRev = "v1.7.18";
    containerdHash = "sha256-IlK5IwniaBhqMgxQzV8btQcbdJkNEQeUMoh6aOsBOHQ=";
    tiniRev = "v0.19.0";
    tiniHash = "sha256-ZDKu/8yE5G0RYFJdhgmCdN3obJNyRWv6K/Gd17zc1sI=";
  };

  docker_27 = callPackage dockerGen rec {
    version = "27.1.1";
    cliRev = "v${version}";
    cliHash = "sha256-r9figEMYHHSbMYVFiw7GUMzjZBhlF+jyZqKixyCpoQ0=";
    mobyRev = "v${version}";
    mobyHash = "sha256-LuCEdQQ3eWt8VyzmWkQTxlxTok9h/UlACTVls5LcI7g=";
    runcRev = "v1.1.13";
    runcHash = "sha256-RQsM8Q7HogDVGbNpen3wxXNGR9lfqmNhkXTRoC+LBk8=";
    containerdRev = "v1.7.20";
    containerdHash = "sha256-Q9lTzz+G5PSoChy8MZtbOpO81AyNWXC+CgGkdOg14uY=";
    tiniRev = "v0.19.0";
    tiniHash = "sha256-ZDKu/8yE5G0RYFJdhgmCdN3obJNyRWv6K/Gd17zc1sI=";
  };

}

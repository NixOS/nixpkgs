{ lib, callPackage }:

let
  dockerGen =
    {
      version,
      cliRev,
      cliHash,
      mobyRev,
      mobyHash,
      runcRev,
      runcHash,
      containerdRev,
      containerdHash,
      tiniRev,
      tiniHash,
      buildxSupport ? true,
      composeSupport ? true,
      sbomSupport ? false,
      initSupport ? false,
      extraPlugins ? [ ],
      # package dependencies
      stdenv,
      fetchFromGitHub,
      buildGoModule,
      makeBinaryWrapper,
      installShellFiles,
      pkg-config,
      glibc,
      go-md2man,
      go,
      containerd,
      runc,
      tini,
      libtool,
      sqlite,
      iproute2,
      docker-buildx,
      docker-compose,
      docker-sbom,
      docker-init,
      iptables,
      e2fsprogs,
      xz,
      util-linuxMinimal,
      xfsprogs,
      gitMinimal,
      procps,
      rootlesskit,
      slirp4netns,
      fuse-overlayfs,
      nixosTests,
      clientOnly ? !stdenv.hostPlatform.isLinux,
      symlinkJoin,
      withSystemd ? lib.meta.availableOn stdenv.hostPlatform systemd,
      systemd,
      withBtrfs ? stdenv.hostPlatform.isLinux,
      btrfs-progs,
      withLvm ? stdenv.hostPlatform.isLinux,
      lvm2,
      withSeccomp ? stdenv.hostPlatform.isLinux,
      libseccomp,
      knownVulnerabilities ? [ ],
      versionCheckHook,
    }:
    let
      docker-meta = {
        license = lib.licenses.asl20;
        maintainers = with lib.maintainers; [
          offline
          vdemeester
          periklis
          teutat3s
        ];
      };

      docker-runc = runc.overrideAttrs {
        pname = "docker-runc";
        inherit version;

        src = fetchFromGitHub {
          owner = "opencontainers";
          repo = "runc";
          tag = runcRev;
          hash = runcHash;
        };

        preBuild = ''
          substituteInPlace Makefile --replace-warn "/bin/bash" "${stdenv.shell}"
        '';

        # docker/runc already include these patches / are not applicable
        patches = [ ];
      };

      docker-containerd = containerd.overrideAttrs (oldAttrs: {
        pname = "docker-containerd";
        inherit version;

        # We only need binaries
        outputs = [ "out" ];

        src = fetchFromGitHub {
          owner = "containerd";
          repo = "containerd";
          tag = containerdRev;
          hash = containerdHash;
        };

        buildInputs = oldAttrs.buildInputs ++ lib.optionals withSeccomp [ libseccomp ];

        # See above
        installTargets = "install";
      });

      docker-tini = tini.overrideAttrs {
        pname = "docker-tini";
        inherit version;

        src = fetchFromGitHub {
          owner = "krallin";
          repo = "tini";
          rev = tiniRev;
          hash = tiniHash;
        };

        # Do not remove static from make files as we want a static binary
        postPatch = "";

        buildInputs = [
          glibc
          glibc.static
        ];

        env.NIX_CFLAGS_COMPILE = "-DMINIMAL=ON";
      };

      moby-src = fetchFromGitHub {
        owner = "moby";
        repo = "moby";
        tag = mobyRev;
        hash = mobyHash;
      };

      moby = buildGoModule (
        lib.optionalAttrs stdenv.hostPlatform.isLinux {
          pname = "moby";
          inherit version;

          src = moby-src;

          vendorHash = null;

          nativeBuildInputs = [
            makeBinaryWrapper
            pkg-config
            go-md2man
            go
            libtool
            installShellFiles
          ];

          buildInputs = [
            sqlite
          ]
          ++ lib.optionals withLvm [ lvm2 ]
          ++ lib.optionals withBtrfs [ btrfs-progs ]
          ++ lib.optionals withSystemd [ systemd ]
          ++ lib.optionals withSeccomp [ libseccomp ];

          extraPath = lib.optionals stdenv.hostPlatform.isLinux (
            lib.makeBinPath [
              iproute2
              iptables
              e2fsprogs
              xz
              xfsprogs
              procps
              util-linuxMinimal
              gitMinimal
            ]
          );

          extraUserPath = lib.optionals (stdenv.hostPlatform.isLinux && !clientOnly) (
            lib.makeBinPath [
              rootlesskit
              slirp4netns
              fuse-overlayfs
            ]
          );

          postPatch = ''
            patchShebangs hack/make.sh hack/make/ hack/with-go-mod.sh
          '';

          buildPhase = ''
            runHook preBuild

            export GOCACHE="$TMPDIR/go-cache"
            # build engine
            export AUTO_GOPATH=1
            export DOCKER_GITCOMMIT="${cliRev}"
            export VERSION="${version}"
            ./hack/make.sh dynbinary

            runHook postBuild
          '';

          installPhase = ''
            runHook preInstall

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

            runHook postInstall
          '';

          env.DOCKER_BUILDTAGS = toString (
            lib.optionals withSystemd [ "journald" ]
            ++ lib.optionals (!withBtrfs) [ "exclude_graphdriver_btrfs" ]
            ++ lib.optionals (!withLvm) [ "exclude_graphdriver_devicemapper" ]
            ++ lib.optionals withSeccomp [ "seccomp" ]
          );

          meta = docker-meta // {
            homepage = "https://mobyproject.org/";
            description = "Collaborative project for the container ecosystem to assemble container-based systems";
          };
        }
      );

      # compose is added later to avoid infinite recursion, since this list is
      # also passed to compose derivation
      pluginsWithoutCompose =
        lib.optionals buildxSupport [ docker-buildx ]
        ++ lib.optionals sbomSupport [ docker-sbom ]
        ++ lib.optionals initSupport [ docker-init ]
        ++ extraPlugins;

      plugins =
        pluginsWithoutCompose
        ++ lib.optionals composeSupport [
          (docker-compose.override { extraPlugins = pluginsWithoutCompose; })
        ];

      pluginsRef = symlinkJoin {
        name = "docker-plugins";
        paths = plugins;
      };
    in
    buildGoModule (
      {
        pname = "docker";
        inherit version;

        src = fetchFromGitHub {
          owner = "docker";
          repo = "cli";
          # Cannot use `tag` since upstream forgot to tag release, see
          # https://github.com/docker/cli/issues/5789
          rev = cliRev;
          hash = cliHash;
        };

        vendorHash = null;

        nativeBuildInputs = [
          makeBinaryWrapper
          pkg-config
          go-md2man
          go
          libtool
          installShellFiles
        ];

        buildInputs =
          plugins
          ++ lib.optionals (stdenv.hostPlatform.isLinux) [
            glibc
            glibc.static
          ];

        postPatch = ''
          patchShebangs man scripts/build/
          substituteInPlace ./scripts/build/.variables --replace-fail "set -eu" ""
        ''
        + lib.optionalString (plugins != [ ]) ''
          substituteInPlace ./cli-plugins/manager/manager_unix.go --replace-fail /usr/libexec/docker/cli-plugins \
              "${pluginsRef}/libexec/docker/cli-plugins"
        '';

        # Keep eyes on BUILDTIME format - https://github.com/docker/cli/blob/${version}/scripts/build/.variables
        buildPhase = ''
          runHook preBuild

          export GOCACHE="$TMPDIR/go-cache"

          # Mimic AUTO_GOPATH
          mkdir -p .gopath/src/github.com/docker/
          ln -sf $PWD .gopath/src/github.com/docker/cli
          export GOPATH="$PWD/.gopath:$GOPATH"
          export GITCOMMIT="${cliRev}"
          export VERSION="${version}"
          export BUILDTIME="1970-01-01T00:00:00Z"
          make dynbinary

          runHook postBuild
        '';

        outputs = [ "out" ];

        installPhase = ''
          runHook preInstall

          install -Dm755 ./build/docker $out/libexec/docker/docker

          makeWrapper $out/libexec/docker/docker $out/bin/docker \
            --prefix PATH : "$out/libexec/docker:$extraPath"
        ''
        + lib.optionalString (!clientOnly) ''
          # symlink docker daemon to docker cli derivation
          ln -s ${moby}/bin/dockerd $out/bin/dockerd
          ln -s ${moby}/bin/dockerd-rootless $out/bin/dockerd-rootless

          # systemd
          mkdir -p $out/etc/systemd/system
          ln -s ${moby}/etc/systemd/system/docker.service $out/etc/systemd/system/docker.service
          ln -s ${moby}/etc/systemd/system/docker.socket $out/etc/systemd/system/docker.socket
        ''
        # Required to avoid breaking cross builds
        + lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
          # completion (cli)
          installShellCompletion --cmd docker \
            --bash <($out/bin/docker completion bash) \
            --fish <($out/bin/docker completion fish) \
            --zsh <($out/bin/docker completion zsh)
        ''
        + ''
          runHook postInstall
        '';

        doInstallCheck = true;
        nativeInstallCheckInputs = [ versionCheckHook ];
        versionCheckProgramArg = "--version";

        passthru = {
          # Exposed for tarsum build on non-linux systems (build-support/docker/default.nix)
          inherit moby-src;
          tests = lib.optionalAttrs (!clientOnly) { inherit (nixosTests) docker; };
        };

        meta = docker-meta // {
          homepage = "https://www.docker.com/";
          description = "Open source project to pack, ship and run any application as a lightweight container";
          longDescription = ''
            Docker is a platform designed to help developers build, share, and run modern applications.

            To enable the docker daemon on NixOS, set the `virtualisation.docker.enable` option to `true`.
          '';
          mainProgram = "docker";
          inherit knownVulnerabilities;
        };
      }
      // lib.optionalAttrs (!clientOnly) {
        # allow overrides of docker components
        # TODO: move packages out of the let...in into top-level to allow proper overrides
        inherit
          docker-runc
          docker-containerd
          docker-tini
          moby
          ;
      }
    );
in
{
  # Get revisions from
  # https://github.com/moby/moby/tree/${version}/hack/dockerfile/install/*
  docker_25 =
    let
      version = "25.0.13";
    in
    callPackage dockerGen {
      inherit version;
      # Upstream forgot to tag release
      # https://github.com/docker/cli/issues/5789
      cliRev = "43987fca488a535d810c429f75743d8c7b63bf4f";
      cliHash = "sha256-OwufdfuUPbPtgqfPeiKrQVkOOacU2g4ommHb770gV40=";
      mobyRev = "v${version}";
      mobyHash = "sha256-X+1QG/toJt+VNLktR5vun8sG3PRoTVBAcekFXxocJdU=";
      runcRev = "v1.2.5";
      runcHash = "sha256-J/QmOZxYnMPpzm87HhPTkYdt+fN+yeSUu2sv6aUeTY4=";
      containerdRev = "v1.7.27";
      containerdHash = "sha256-H94EHnfW2Z59KcHcbfJn+BipyZiNUvHe50G5EXbrIps=";
      tiniRev = "369448a167e8b3da4ca5bca0b3307500c3371828";
      tiniHash = "sha256-jCBNfoJAjmcTJBx08kHs+FmbaU82CbQcf0IVjd56Nuw=";
    };

  docker_28 =
    let
      version = "28.4.0";
    in
    callPackage dockerGen {
      inherit version;
      cliRev = "v${version}";
      cliHash = "sha256-SgePAc+GvjZgymu7VA2whwIFEYAfMVUz9G0ppxeOi7M=";
      mobyRev = "v${version}";
      mobyHash = "sha256-hiuwdemnjhi/622xGcevG4rTC7C+DyUijE585a9APSM=";
      runcRev = "v1.3.0";
      runcHash = "sha256-oXoDio3l23Z6UyAhb9oDMo1O4TLBbFyLh9sRWXnfLVY=";
      containerdRev = "v1.7.28";
      containerdHash = "sha256-vz7RFJkFkMk2gp7bIMx1kbkDFUMS9s0iH0VoyD9A21s=";
      tiniRev = "369448a167e8b3da4ca5bca0b3307500c3371828";
      tiniHash = "sha256-jCBNfoJAjmcTJBx08kHs+FmbaU82CbQcf0IVjd56Nuw=";
    };

}

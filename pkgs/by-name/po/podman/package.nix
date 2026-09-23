{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  installShellFiles,
  buildGoModule,
  buildPackages,
  gpgme,
  btrfs-progs,
  libapparmor,
  libseccomp,
  libselinux,
  # TODO: investigate why changing from `systemd` to `systemdMinimal` breaks `podman logs`
  systemd,
  nixosTests,
  python3,
  makeBinaryWrapper,
  symlinkJoin,
  replaceVars,
  extraPackages ? [ ],
  crun,
  runc,
  krunkit,
  conmon,
  extraRuntimes ? lib.optionals stdenv.hostPlatform.isLinux [ runc ], # e.g.: runc, gvisor, youki
  fuse-overlayfs,
  util-linuxMinimal,
  nftables,
  iproute2,
  catatonit,
  gvproxy,
  aardvark-dns,
  netavark,
  passt,
  vfkit,
  versionCheckHook,
  writableTmpDirAsHomeHook,
  coreutils,
  runtimeShell,
  fetchpatch,
}:
buildGoModule (finalAttrs: {
  pname = "podman";
  version = "6.1.2";

  src = fetchFromGitHub {
    owner = "podman-container-tools";
    repo = "podman";
    tag = "v${finalAttrs.version}";
    hash = "sha256-qqqQTDn4wZkjdjFaXiG3yOc4R2z9HGUp829A2c/1g6k=";
  };

  patches = [
    (replaceVars ./hardcode-paths.patch {
      bin_path = finalAttrs.passthru.helpersBin;
    })

    # we intentionally don't build and install the helper so we shouldn't display messages to users about it
    ./rm-podman-mac-helper-msg.patch
    # Fix `podman completion` in the build sandbox
    # https://github.com/podman-container-tools/podman/pull/29832
    (fetchpatch {
      name = "fix-podman-completion.patch";
      url = "https://github.com/podman-container-tools/podman/commit/7cef788844bdaae01ca672a55698d40428644eb4.patch";
      hash = "sha256-CAECXYRFyOF4aIc9qIZQceiz5vE/gFGyitjPI48IhYU=";
    })
  ];

  vendorHash = null;

  doCheck = false;

  outputs = [
    "out"
    "man"
  ];

  nativeBuildInputs = [
    pkg-config
    installShellFiles
    makeBinaryWrapper
    python3
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    btrfs-progs
    gpgme
    libapparmor
    libseccomp
    libselinux
    systemd
  ];

  env = {
    HELPER_BINARIES_DIR = "${placeholder "out"}/libexec/podman"; # used in buildPhase & installPhase
    PREFIX = "${placeholder "out"}";
    GOMD2MAN = "${buildPackages.go-md2man}/bin/go-md2man";
  };

  buildPhase = ''
    runHook preBuild

    patchShebangs .
    ${
      if stdenv.hostPlatform.isDarwin then
        ''
          make podman-remote # podman-mac-helper uses FHS paths
        ''
      else
        ''
          make bin/podman bin/rootlessport bin/quadlet
        ''
    }
    make docs

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    ${
      if stdenv.hostPlatform.isDarwin then
        ''
          install bin/darwin/podman -Dt $out/bin
        ''
      else
        ''
          make install.bin install.systemd
        ''
    }
    make install.completions install.man
    mkdir -p ${finalAttrs.env.HELPER_BINARIES_DIR}
    ln -s ${finalAttrs.passthru.helpersBin}/bin/* ${finalAttrs.env.HELPER_BINARIES_DIR}
    wrapProgram $out/bin/podman \
      --prefix PATH : ${lib.escapeShellArg finalAttrs.passthru.binPath}

    runHook postInstall
  '';

  postFixup = lib.optionalString stdenv.hostPlatform.isLinux ''
    RPATH=$(patchelf --print-rpath $out/bin/.podman-wrapped)
    patchelf --set-rpath "${lib.makeLibraryPath [ systemd ]}":$RPATH $out/bin/.podman-wrapped
    substituteInPlace "$out/share/systemd/user/podman-user-wait-network-online.service" \
      --replace-fail sleep '${coreutils}/bin/sleep' \
      --replace-fail /bin/sh '${runtimeShell}'
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [
    versionCheckHook
    writableTmpDirAsHomeHook
  ];
  versionCheckKeepEnvironment = [ "HOME" ];

  passthru = {
    tests = lib.optionalAttrs stdenv.hostPlatform.isLinux {
      inherit (nixosTests) podman;
      # related modules
      inherit (nixosTests)
        podman-tls-ghostunnel
        ;
      oci-containers-podman = nixosTests.oci-containers.podman;
      oci-containers-podman-rootless-conmon = nixosTests.oci-containers.podman-rootless-conmon;
      oci-containers-podman-rootless-healthy = nixosTests.oci-containers.podman-rootless-healthy;
    };
    # do not add qemu to this wrapper, store paths get written to the podman vm config and break when GCed
    binPath = lib.makeBinPath (
      lib.optionals stdenv.hostPlatform.isLinux [
        fuse-overlayfs
        util-linuxMinimal
        iproute2
        nftables
      ]
      ++ lib.optional (lib.meta.availableOn stdenv.hostPlatform vfkit) vfkit
      ++ lib.optional (lib.meta.availableOn stdenv.hostPlatform krunkit) krunkit
      ++ extraPackages
    );

    helpersBin = symlinkJoin {
      name = "podman-helper-binary-wrapper";

      # this only works for some binaries, others may need to be added to `binPath` or in the modules
      paths =
        lib.optionals stdenv.hostPlatform.isDarwin [
          gvproxy
        ]
        ++ lib.optionals stdenv.hostPlatform.isLinux [
          aardvark-dns # dns
          catatonit # added here for the pause image
          netavark # networking
          passt # rootless networking
          conmon # runtime monitor
          crun # runtime
        ]
        ++ extraRuntimes;
    };
  };

  meta = {
    homepage = "https://podman.io/";
    description = "Program for managing pods, containers and container images";
    longDescription = ''
      Podman (the POD MANager) is a tool for managing containers and images, volumes mounted into those containers, and pods made from groups of containers. Podman runs containers on Linux, but can also be used on Mac and Windows systems using a Podman-managed virtual machine. Podman is based on libpod, a library for container lifecycle management that is also contained in this repository. The libpod library provides APIs for managing containers, pods, container images, and volumes.

      To install on NixOS, please use the option `virtualisation.podman.enable = true`.
    '';
    changelog = "https://github.com/podman-container-tools/podman/blob/v${finalAttrs.version}/RELEASE_NOTES.md";
    license = lib.licenses.asl20;
    teams = [ lib.teams.podman ];
    mainProgram = "podman";
    platforms = lib.platforms.unix;
  };
})

{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  installShellFiles,
  buildGoModule,
  gpgme,
  lvm2,
  btrfs-progs,
  libapparmor,
  libseccomp,
  libselinux,
  systemdMinimal,
  go-md2man,
  nixosTests,
  python3,
  makeBinaryWrapper,
  symlinkJoin,
  replaceVars,
  extraPackages ? [ ],
  crun,
  runc,
  conmon,
  extraRuntimes ? lib.optionals stdenv.hostPlatform.isLinux [ runc ], # e.g.: runc, gvisor, youki
  fuse-overlayfs,
  util-linuxMinimal,
  nftables,
  iptables,
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
}:
buildGoModule (finalAttrs: {
  pname = "podman";
  version = "5.7.0";

  src = fetchFromGitHub {
    owner = "containers";
    repo = "podman";
    tag = "v${finalAttrs.version}";
    hash = "sha256-SHIWfY8eKdimwpLfB1NtpF1DBh6qaR5KCDTU4vWAMFw=";
  };

  patches = [
    (replaceVars ./hardcode-paths.patch {
      bin_path = finalAttrs.passthru.helpersBin;
    })

    # we intentionally don't build and install the helper so we shouldn't display messages to users about it
    ./rm-podman-mac-helper-msg.patch
  ];

  vendorHash = null;

  doCheck = false;

  outputs = [
    "out"
    "man"
  ];

  nativeBuildInputs = [
    pkg-config
    go-md2man
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
    lvm2
    systemdMinimal
  ];

  env = {
    HELPER_BINARIES_DIR = "${placeholder "out"}/libexec/podman"; # used in buildPhase & installPhase
    PREFIX = "${placeholder "out"}";
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
    patchelf --set-rpath "${lib.makeLibraryPath [ systemdMinimal ]}":$RPATH $out/bin/.podman-wrapped
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
  versionCheckProgramArg = "--version";

  passthru = {
    tests = lib.optionalAttrs stdenv.hostPlatform.isLinux {
      inherit (nixosTests) podman;
      # related modules
      inherit (nixosTests)
        podman-tls-ghostunnel
        ;
      oci-containers-podman = nixosTests.oci-containers.podman;
    };
    # do not add qemu to this wrapper, store paths get written to the podman vm config and break when GCed
    binPath = lib.makeBinPath (
      lib.optionals stdenv.hostPlatform.isLinux [
        fuse-overlayfs
        util-linuxMinimal
        iptables
        iproute2
        nftables
      ]
      ++ lib.optionals stdenv.hostPlatform.isDarwin [
        vfkit
      ]
      ++ extraPackages
    );

    helpersBin = symlinkJoin {
      name = "podman-helper-binary-wrapper";

      # this only works for some binaries, others may need to be added to `binPath` or in the modules
      paths = [
        gvproxy
      ]
      ++ lib.optionals stdenv.hostPlatform.isLinux [
        aardvark-dns
        catatonit # added here for the pause image and also set in `containersConf` for `init_path`
        netavark
        passt
        conmon
        crun
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
    changelog = "https://github.com/containers/podman/blob/v${finalAttrs.version}/RELEASE_NOTES.md";
    license = lib.licenses.asl20;
    teams = [ lib.teams.podman ];
    mainProgram = "podman";
  };
})

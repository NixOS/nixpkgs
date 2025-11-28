{
  lib,
  rustPlatform,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  wrapGAppsHook4,
  bashNonInteractive,
  gdk-pixbuf,
  gtk4,
  libdrm,
  ocl-icd,
  vulkan-loader,
  vulkan-tools,
  coreutils,
  systemdMinimal,
  nix-update-script,
  nixosTests,
  hwdata,
  fuse3,
  autoAddDriverRunpath,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "lact";
  version = "0.8.3";

  src = fetchFromGitHub {
    owner = "ilya-zlobintsev";
    repo = "LACT";
    tag = "v${finalAttrs.version}";
    hash = "sha256-CbpUg+PB4Kx8AJavXY1GorNb3KfyKl8ovY2y2658UXI=";
  };

  cargoHash = "sha256-+3r3FXol7FzgpaasNT3uVT+PhfoRrRNS4z1iYPiwHRM=";

  nativeBuildInputs = [
    pkg-config
    wrapGAppsHook4
    rustPlatform.bindgenHook
    autoAddDriverRunpath
  ];

  buildInputs = [
    gdk-pixbuf
    gtk4
    libdrm
    ocl-icd
    vulkan-loader
    vulkan-tools
    hwdata
    fuse3
  ];

  # we do this here so that the binary is usable during integration tests
  RUSTFLAGS = lib.optionalString stdenv.targetPlatform.isElf (
    lib.concatStringsSep " " [
      "-C link-arg=-Wl,-rpath,${
        lib.makeLibraryPath [
          vulkan-loader
          libdrm
          ocl-icd
        ]
      }"
      "-C link-arg=-Wl,--add-needed,${vulkan-loader}/lib/libvulkan.so"
      "-C link-arg=-Wl,--add-needed,${libdrm}/lib/libdrm.so"
      "-C link-arg=-Wl,--add-needed,${ocl-icd}/lib/libOpenCL.so"
    ]
  );

  postPatch = ''
    substituteInPlace lact-daemon/src/system.rs \
      --replace-fail 'Command::new("uname")' 'Command::new("${coreutils}/bin/uname")'

    substituteInPlace lact-daemon/src/server/handler.rs \
      --replace-fail 'run_command("journalctl",'  'run_command("${systemdMinimal}/bin/journalctl",'

    substituteInPlace lact-daemon/src/server/handler.rs \
      --replace-fail 'Command::new("sh")' 'Command::new("${bashNonInteractive}/bin/bash")'

    substituteInPlace lact-daemon/src/server/vulkan.rs \
      --replace-fail 'Command::new("vulkaninfo")' 'Command::new("${vulkan-tools}/bin/vulkaninfo")'

    substituteInPlace lact-daemon/src/socket.rs \
      --replace-fail 'run_command("chown"' 'run_command("${coreutils}/bin/chown"'

    substituteInPlace res/lactd.service \
      --replace-fail ExecStart={lact,$out/bin/lact}

    # read() looks for the database in /usr/share so we use read_from_file() instead
    substituteInPlace lact-daemon/src/server/handler.rs \
      --replace-fail 'Database::read()' 'Database::read_from_file("${hwdata}/share/hwdata/pci.ids")'
  '';

  postInstall = ''
    install -Dm444 res/lactd.service -t $out/lib/systemd/system
    install -Dm444 res/io.github.ilya_zlobintsev.LACT.desktop -t $out/share/applications
    install -Dm444 res/io.github.ilya_zlobintsev.LACT.svg -t $out/share/pixmaps
  '';

  preFixup = ''
    gappsWrapperArgs+=(
      --prefix PATH : "${lib.makeBinPath [ vulkan-tools ]}"
    )
  '';

  postFixup = lib.optionalString stdenv.targetPlatform.isElf ''
    patchelf $out/bin/.lact-wrapped \
    --add-needed libvulkan.so \
    --add-needed libdrm.so \
    --add-needed libOpenCL.so \
    --add-rpath ${
      lib.makeLibraryPath [
        vulkan-loader
        libdrm
        ocl-icd
      ]
    }
  '';

  passthru.updateScript = nix-update-script { };
  passthru.tests = {
    inherit (nixosTests) lact;
  };

  meta = {
    description = "Linux GPU Configuration Tool for AMD and NVIDIA";
    homepage = "https://github.com/ilya-zlobintsev/LACT";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      atemu
      cything
      johnrtitor
    ];
    platforms = lib.platforms.linux;
    mainProgram = "lact";
  };
})

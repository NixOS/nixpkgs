{
  lib,
  rustPlatform,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  wrapGAppsHook4,
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
  version = "0.7.4";

  src = fetchFromGitHub {
    owner = "ilya-zlobintsev";
    repo = "LACT";
    tag = "v${finalAttrs.version}";
    hash = "sha256-zOvFWl78INlpCcEHiB3qZdxPNHXfUeKxfHyrO+wVNN0=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-10FdXUpLL+8xN818toShccgB5NfpzrOLfEeDAX5oMFw=";

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
    substituteInPlace lact-daemon/src/server/system.rs \
      --replace-fail 'Command::new("uname")' 'Command::new("${coreutils}/bin/uname")'
    substituteInPlace lact-daemon/src/server/profiles.rs \
      --replace-fail 'Command::new("uname")' 'Command::new("${coreutils}/bin/uname")'

    substituteInPlace lact-daemon/src/server/handler.rs \
      --replace-fail 'Command::new("journalctl")' 'Command::new("${systemdMinimal}/bin/journalctl")'

    substituteInPlace lact-daemon/src/server/vulkan.rs \
      --replace-fail 'Command::new("vulkaninfo")' 'Command::new("${vulkan-tools}/bin/vulkaninfo")'

    substituteInPlace res/lactd.service \
      --replace-fail ExecStart={lact,$out/bin/lact}

    substituteInPlace res/io.github.ilya_zlobintsev.LACT.desktop \
      --replace-fail Exec={lact,$out/bin/lact}

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
      figsoda
      atemu
      cything
      johnrtitor
    ];
    platforms = lib.platforms.linux;
    mainProgram = "lact";
  };
})

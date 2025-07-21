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
  fetchpatch,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "lact";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "ilya-zlobintsev";
    repo = "LACT";
    tag = "v${finalAttrs.version}";
    hash = "sha256-HsDVz9Wd1WoGWIB4Cs/GsvC7RDyHAeXfFGXZDWEmo/c=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-fgF7gOXxB9sQqA5H1hw6A0Fb5tTBPySAbSxVhcKVhcM=";

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

  patches = [
    (fetchpatch {
      name = "fix-tests::snapshot_everything-due-to-outdated-hwdata-649.patch";
      url = "https://github.com/ilya-zlobintsev/LACT/commit/c9a59e48a36d590d7522c22bd15a8f9208bef0ee.patch";
      hash = "sha256-Ehq8vRosqyqpRPeabkdpBHBF6ONqSJHOeq3AXw8PXPU=";
    })
  ];

  postPatch = ''
    substituteInPlace lact-daemon/src/system.rs \
      --replace-fail 'Command::new("uname")' 'Command::new("${coreutils}/bin/uname")'

    substituteInPlace lact-daemon/src/server/handler.rs \
      --replace-fail 'run_command("journalctl",'  'run_command("${systemdMinimal}/bin/journalctl",'

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

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
  vulkan-loader,
  vulkan-tools,
  coreutils,
  nix-update-script,
  hwdata,
  fuse3,
}:

rustPlatform.buildRustPackage rec {
  pname = "lact";
  version = "0.7.2";

  src = fetchFromGitHub {
    owner = "ilya-zlobintsev";
    repo = "LACT";
    tag = "v${version}";
    hash = "sha256-6nNt/EnJKHdldjpCW2pLPBkU5TLGEaqtnUUBraeRa3I=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-NoWngD0LJ+cteoQIJ0iye0MZgmLuuxN2YHHyMqeEABc=";

  nativeBuildInputs = [
    pkg-config
    wrapGAppsHook4
    rustPlatform.bindgenHook
  ];

  buildInputs = [
    gdk-pixbuf
    gtk4
    libdrm
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
        ]
      }"
      "-C link-arg=-Wl,--add-needed,${vulkan-loader}/lib/libvulkan.so"
      "-C link-arg=-Wl,--add-needed,${libdrm}/lib/libdrm.so"
    ]
  );

  checkFlags = [
    # tries and fails to initialize gtk
    "--skip=app::pages::thermals_page::fan_curve_frame::tests::set_get_curve"
  ];

  postPatch = ''
    substituteInPlace lact-daemon/src/server/system.rs \
      --replace-fail 'Command::new("uname")' 'Command::new("${coreutils}/bin/uname")'

    substituteInPlace res/lactd.service \
      --replace-fail ExecStart={lact,$out/bin/lact}

    substituteInPlace res/io.github.lact-linux.desktop \
      --replace-fail Exec={lact,$out/bin/lact}

    # read() looks for the database in /usr/share so we use read_from_file() instead
    substituteInPlace \
      lact-daemon/src/server/handler.rs \
      lact-daemon/src/tests/mod.rs \
      --replace-fail 'Database::read()' 'Database::read_from_file("${hwdata}/share/hwdata/pci.ids")'
  '';

  postInstall = ''
    install -Dm444 res/lactd.service -t $out/lib/systemd/system
    install -Dm444 res/io.github.lact-linux.desktop -t $out/share/applications
    install -Dm444 res/io.github.lact-linux.png -t $out/share/pixmaps
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
    --add-rpath ${
      lib.makeLibraryPath [
        vulkan-loader
        libdrm
      ]
    }
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Linux GPU Configuration Tool for AMD and NVIDIA";
    homepage = "https://github.com/ilya-zlobintsev/LACT";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      figsoda
      atemu
    ];
    platforms = lib.platforms.linux;
    mainProgram = "lact";
  };
}

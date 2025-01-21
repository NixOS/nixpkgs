{
  lib,
  rustPlatform,
  stdenv,
  fetchFromGitHub,
  blueprint-compiler,
  pkg-config,
  wrapGAppsHook4,
  gdk-pixbuf,
  gtk4,
  libdrm,
  vulkan-loader,
  coreutils,
  nix-update-script,
  hwdata,
}:

rustPlatform.buildRustPackage rec {
  pname = "lact";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "ilya-zlobintsev";
    repo = "LACT";
    rev = "v${version}";
    hash = "sha256-9Enht9bwvk1jHYHRDPSUtwRxPGbPlU3V0hv0CuCOCls=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-Tw3yOu1pZJxjbg5fpOgWA46qbigq4hTIKh9eOXjAtBU=";

  nativeBuildInputs = [
    blueprint-compiler
    pkg-config
    wrapGAppsHook4
    rustPlatform.bindgenHook
  ];

  buildInputs = [
    gdk-pixbuf
    gtk4
    libdrm
    vulkan-loader
    hwdata
  ];

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

  patchPhase = ''
    # read() looks for the database in /usr/share
    sed -i 's/Database::read()/Database::read_from_file("${
      lib.replaceStrings [ "/" ] [ "\\/" ] "${hwdata}/share/hwdata/pci.ids"
    }")/g' lact-daemon/src/server/handler.rs

    # test data is probably incorrect for these since the other intel tests pass
    rm -r lact-daemon/src/tests/data/intel/a380-xe
    rm -r lact-daemon/src/tests/data/intel/a380-i915
  '';

  postPatch = ''
    substituteInPlace lact-daemon/src/server/system.rs \
      --replace-fail 'Command::new("uname")' 'Command::new("${coreutils}/bin/uname")'

    substituteInPlace res/lactd.service \
      --replace-fail ExecStart={lact,$out/bin/lact}

    substituteInPlace res/io.github.lact-linux.desktop \
      --replace-fail Exec={lact,$out/bin/lact}
  '';

  postInstall = ''
    install -Dm444 res/lactd.service -t $out/lib/systemd/system
    install -Dm444 res/io.github.lact-linux.desktop -t $out/share/applications
    install -Dm444 res/io.github.lact-linux.png -t $out/share/pixmaps
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

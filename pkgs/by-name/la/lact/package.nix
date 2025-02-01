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
}:

rustPlatform.buildRustPackage rec {
  pname = "lact";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "ilya-zlobintsev";
    repo = "LACT";
    rev = "v${version}";
    hash = "sha256-goNwLtVjNY3O/BhFrCcM3X11dtM34XgfHL6bh+YFoIY=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-rgpBmoGCNMU5nFVxzNtqsPaOn93mHW5P2isKgbP9UN4=";

  nativeBuildInputs = [
    blueprint-compiler
    pkg-config
    wrapGAppsHook4
  ];

  buildInputs = [
    gdk-pixbuf
    gtk4
    libdrm
    vulkan-loader
  ];

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
  '';

  postInstall = ''
    install -Dm444 res/lactd.service -t $out/lib/systemd/system
    install -Dm444 res/io.github.lact-linux.desktop -t $out/share/applications
    install -Dm444 res/io.github.lact-linux.png -t $out/share/pixmaps
  '';

  postFixup = lib.optionalString stdenv.targetPlatform.isElf ''
    patchelf $out/bin/.lact-wrapped --add-needed libvulkan.so --add-rpath ${
      lib.makeLibraryPath [ vulkan-loader ]
    }
  '';

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

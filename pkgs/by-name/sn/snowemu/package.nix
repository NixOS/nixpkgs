{
  lib,
  rustPlatform,
  fetchFromGitHub,
  makeWrapper,
  makeDesktopItem,
  SDL2,
  pkg-config,
  xorg,
  wayland,
  libxkbcommon,
  libGL,
}:

rustPlatform.buildRustPackage rec {
  pname = "snowemu";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "twvd";
    repo = "snow";
    tag = "v${version}";
    hash = "sha256-uBhQfvREjVfgg5Ro+Wat84loGoeDjd9OsnP90b5ssXI=";
    fetchSubmodules = true;
  };
  cargoHash = "sha256-8vMQVmYwtLmop1tmP2f1WjNwV3ymLojfpiji5lcvJBo=";

  nativeBuildInputs = [
    pkg-config
    makeWrapper
  ];

  buildInputs = [
    SDL2.dev
    xorg.libX11
    xorg.libXcursor
    xorg.libXrandr
    xorg.libXi
  ];

  postInstall = ''
    mv $out/bin/snow_frontend_egui $out/bin/snowemu

    install -Dm644 docs/images/snow_icon.png $out/share/icons/hicolor/512x512/apps/${pname}.png

    wrapProgram $out/bin/snowemu \
      --prefix LD_LIBRARY_PATH : ${
        lib.makeLibraryPath [
          wayland
          libxkbcommon
          libGL
        ]
      }
  '';

  desktopItems = [
    (makeDesktopItem {
      name = pname;
      exec = pname;
      icon = pname;
      desktopName = "Snow Emulator";
      comment = meta.description;
      genericName = "Vintage Macintosh emulator";
      categories = [
        "Game"
        "Emulator"
      ];
    })
  ];

  meta = with lib; {
    description = "Snow Macintosh emulator";
    longDescription = ''
      Snow emulates classic (Motorola 680x0-based) Macintosh computers. It features a graphical user interface to operate the emulated machine and provides extensive debugging capabilities. The aim of this project is to emulate the Macintosh on a hardware-level as much as possible, as opposed to emulators that patch the ROM or intercept system calls.
      It currently emulates the Macintosh 128K, Macintosh 512K, Macintosh Plus, Macintosh SE, Macintosh Classic and Macintosh II.
    '';
    homepage = "https://snowemu.com/";
    changelog = "https://github.com/twvd/snow/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ nulleric ];
    platforms = platforms.linux;
    mainProgram = "snowemu";
  };
}

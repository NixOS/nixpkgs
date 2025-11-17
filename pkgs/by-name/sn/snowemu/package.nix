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

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "snowemu";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "twvd";
    repo = "snow";
    tag = "v${finalAttrs.version}";
    hash = "sha256-m3CPKswOB2j2r/BTf9RzCvwPVq3gbKemtk11HKS1nHk=";
    fetchSubmodules = true;
  };
  cargoHash = "sha256-+FS5785F8iWPt6Db+IKRbOFAYNEfHC+jvPVdwkLZ5YI=";

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

    install -Dm644 docs/images/snow_icon.png $out/share/icons/hicolor/apps/snowemu.png

    wrapProgram $out/bin/snowemu \
      --prefix LD_LIBRARY_PATH : ${
        lib.makeLibraryPath [
          wayland
          libxkbcommon
          libGL
        ]
      }
  '';

  desktopItems = makeDesktopItem {
    name = "snowemu";
    exec = "snowemu";
    icon = "snowemu";
    desktopName = "Snow Emulator";
    comment = finalAttrs.meta.description;
    genericName = "Vintage Macintosh emulator";
    categories = [
      "Game"
      "Emulator"
    ];
  };

  meta = {
    description = "Early Macintosh emulator";
    longDescription = ''
      Snow emulates classic (Motorola 680x0-based) Macintosh computers. It features a graphical user interface to operate the emulated machine and provides extensive debugging capabilities. The aim of this project is to emulate the Macintosh on a hardware-level as much as possible, as opposed to emulators that patch the ROM or intercept system calls.
      It currently emulates the Macintosh 128K, Macintosh 512K, Macintosh Plus, Macintosh SE, Macintosh Classic and Macintosh II.
    '';
    homepage = "https://snowemu.com/";
    changelog = "https://github.com/twvd/snow/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ nulleric ];
    platforms = lib.platforms.linux;
    mainProgram = "snowemu";
  };
})

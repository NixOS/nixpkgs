{
  lib,
  rustPlatform,
  fetchFromGitHub,
  makeWrapper,
  copyDesktopItems,
  makeDesktopItem,
  alsa-lib,
  pkg-config,
  libxrandr,
  libxi,
  libxcursor,
  libx11,
  wayland,
  libxkbcommon,
  libGL,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "snowemu";
  version = "1.5.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "twvd";
    repo = "snow";
    tag = "v${finalAttrs.version}";
    hash = "sha256-BA4uCuluSfIGXwBxE2X6Gke0ITsYEPzKoFDwx6jRYsk=";
    fetchSubmodules = true;
  };
  cargoHash = "sha256-C7rCx0g77R+1f0la+j3pVW0bShGPdJD3btAIYg3yzMw=";

  nativeBuildInputs = [
    pkg-config
    makeWrapper
    copyDesktopItems
  ];

  buildInputs = [ alsa-lib ];

  postInstall = ''
    install -Dm644 assets/snow_icon.png $out/share/icons/snowemu.png

    substituteInPlace assets/dev.thomasw.snow.metainfo.xml \
      --replace-fail "snow.desktop" "snowemu.desktop" \
      --replace-fail "/usr/share/icons/hicolor/1024x1024/apps/snow_icon.png" \
        "$out/share/icons/snowemu.png"
    install -Dm644 assets/dev.thomasw.snow.metainfo.xml \
      $out/share/metainfo/dev.thomasw.snow.metainfo.xml

    wrapProgram $out/bin/snowemu \
      --prefix LD_LIBRARY_PATH : ${
        lib.makeLibraryPath [
          libx11
          libxcursor
          libxrandr
          libxi
          wayland
          libxkbcommon
          libGL
        ]
      }
  '';

  desktopItems = [
    (makeDesktopItem {
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
      keywords = [
        "macintosh"
        "emulator"
        "vintage"
        "68k"
      ];
    })
  ];

  passthru.updateScript = nix-update-script { };

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

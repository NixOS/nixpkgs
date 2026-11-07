{
  lib,
  rustPlatform,
  fetchFromGitHub,
  makeDesktopItem,
  copyDesktopItems,
  pkg-config,
  cmake,
  fontconfig,
  glib,
  gtk3,
  freetype,
  openssl,
  libxrandr,
  libxi,
  libxcursor,
  libx11,
  libxcb,
  libGL,
  libxkbcommon,
  wayland,
  withGui ? false, # build GUI version
}:

rustPlatform.buildRustPackage rec {
  pname = "rusty-psn";
  version = "0.7.1";

  src = fetchFromGitHub {
    owner = "RainbowCookie32";
    repo = "rusty-psn";
    tag = "v${version}";
    hash = "sha256-f15De29bv2ZG2963p/8bDVLBTIT/dBXK57X4mYW6FLA=";
  };

  cargoHash = "sha256-/TNnG/CeyGhySIFWjmxqL2UsLFslF+/B0POvoQyFO9w=";

  # Tests require network access
  doCheck = false;

  nativeBuildInputs = [
    pkg-config
  ]
  ++ lib.optionals withGui [
    copyDesktopItems
    cmake
  ];

  buildInputs = [
    openssl
  ]
  ++ lib.optionals withGui [
    fontconfig
    glib
    gtk3
    freetype
    openssl
    libxcb
    libx11
    libxcursor
    libxrandr
    libxi
    libxcb
    libGL
    libxkbcommon
    wayland
  ];

  buildNoDefaultFeatures = true;
  buildFeatures = [ (if withGui then "egui" else "cli") ];

  postFixup = ''
    patchelf --set-rpath "${lib.makeLibraryPath buildInputs}" $out/bin/rusty-psn
  ''
  + lib.optionalString withGui ''
    mv $out/bin/rusty-psn $out/bin/rusty-psn-gui
  '';

  desktopItem = lib.optionalString withGui (makeDesktopItem {
    name = "rusty-psn";
    desktopName = "rusty-psn";
    exec = "rusty-psn-gui";
    comment = "A simple tool to grab updates for PS3 games, directly from Sony's servers using their updates API.";
    categories = [
      "Network"
    ];
    keywords = [
      "psn"
      "ps3"
      "sony"
      "playstation"
      "update"
    ];
  });
  desktopItems = lib.optionals withGui [ desktopItem ];

  meta = {
    description = "Simple tool to grab updates for PS3 games, directly from Sony's servers using their updates API";
    homepage = "https://github.com/RainbowCookie32/rusty-psn/";
    license = lib.licenses.mit;
    platforms = [ "x86_64-linux" ];
    maintainers = with lib.maintainers; [ AngryAnt ];
    mainProgram = if withGui then "rusty-psn-gui" else "rusty-psn";
  };
}

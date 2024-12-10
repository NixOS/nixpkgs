{
  lib,
  stdenv,
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
  xorg,
  libGL,
  withGui ? false, # build GUI version
}:

rustPlatform.buildRustPackage rec {
  pname = "rusty-psn";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "RainbowCookie32";
    repo = "rusty-psn";
    rev = "v${version}";
    sha256 = "sha256-BsbuEsW6cQbWg8BLtEBnjoCfcUCy1xWz9u0wBa8BKtA=";
  };

  cargoSha256 = "sha256-TD5du7I6Hw1PC8s9NI19jYCXlaZMnsdVj/a0q+M8Raw=";

  nativeBuildInputs =
    [
      pkg-config
    ]
    ++ lib.optionals withGui [
      copyDesktopItems
      cmake
    ];

  buildInputs =
    [
      openssl
    ]
    ++ lib.optionals withGui [
      fontconfig
      glib
      gtk3
      freetype
      openssl
      xorg.libxcb
      xorg.libX11
      xorg.libXcursor
      xorg.libXrandr
      xorg.libXi
      xorg.libxcb
      libGL
      libGL.dev
    ];

  buildNoDefaultFeatures = true;
  buildFeatures = [ (if withGui then "egui" else "cli") ];

  postFixup =
    ''
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

  meta = with lib; {
    description = "Simple tool to grab updates for PS3 games, directly from Sony's servers using their updates API";
    homepage = "https://github.com/RainbowCookie32/rusty-psn/";
    license = licenses.mit;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ AngryAnt ];
    mainProgram = "rusty-psn";
  };
}

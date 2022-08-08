{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, makeDesktopItem
, copyDesktopItems
, pkg-config
, openssl
, xorg
, libGL
, withGui ? false # build GUI version
}:

rustPlatform.buildRustPackage rec {
  pname = "rusty-psn";
  version = "0.1.2";

  src = fetchFromGitHub {
    owner = "RainbowCookie32";
    repo = "rusty-psn";
    rev = "v${version}";
    sha256 = "14li5fsaj4l5al6lcxy07g3gzmi0l3cyiczq44q7clq4myhykhhb";
  };

  cargoSha256 = "0kjaq3ik3lwaz7rjb5jaxavpahzp33j7vln3zyifql7j7sbr300f";

  nativeBuildInputs = [
    pkg-config
    copyDesktopItems
  ];

  buildInputs = if withGui then [
    openssl
    xorg.libxcb
    xorg.libX11
    xorg.libXcursor
    xorg.libXrandr
    xorg.libXi
    xorg.libxcb
    libGL
    libGL.dev
  ] else [
    openssl
  ];

  buildNoDefaultFeatures = true;
  buildFeatures = [ (if withGui then "egui" else "cli") ];

  postFixup = ''
    patchelf --set-rpath "${lib.makeLibraryPath buildInputs}" $out/bin/rusty-psn
  '' + lib.optionalString withGui ''
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
  };
}

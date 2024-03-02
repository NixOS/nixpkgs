{ lib, fetchFromGitHub, rustPlatform, adoptopenjdk-icedtea-web, makeWrapper, makeDesktopItem, copyDesktopItems }:

rustPlatform.buildRustPackage rec {
  pname = "stellwerksim-launcher";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "cutestnekoaqua";
    repo = pname;
    rev = version;
    hash = "sha256-cCW0XimsQLlzHOJMTwQN8+grdelihcr/kblOtKp1L8c=";
  };

  nativeBuildInputs = [ makeWrapper copyDesktopItems ];

  desktopItems = [
    (makeDesktopItem rec {
      name = "Stellwerk Simulator Launcher";
      exec = pname;
      icon = pname;
      comment = meta.description;
      desktopName = name;
      genericName = name;
      terminal = true;
      categories = [ "Game" ];
    })
  ];

  cargoHash = "sha256-+JIHv5ZoSKFzWE7WOBEZwuX8t1x567tRonHw2ZaQN2I=";

  postFixup = ''
    wrapProgram $out/bin/stellwerksim-launcher --set PATH ${lib.makeBinPath [
      # Hard requirements
      adoptopenjdk-icedtea-web
      ]}
  '';

  meta = with lib; {
    description = "A Launcher for the java online game Stellwerk Simulator";
    homepage = "https://github.com/cutestnekoaqua/stellwerksim-launcher";
    license = licenses.mit;
    maintainers = [ maintainers.aprl ];
  };
}

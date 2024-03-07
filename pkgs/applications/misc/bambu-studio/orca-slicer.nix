{ lib, fetchFromGitHub, makeDesktopItem, bambu-studio }:
let
  orca-slicer = bambu-studio.overrideAttrs (finalAttrs: previousAttrs: {
    version = "1.9.1";
    pname = "orca-slicer";

    src = fetchFromGitHub {
      owner = "SoftFever";
      repo = "OrcaSlicer";
      rev = "v${finalAttrs.version}";
      hash = "sha256-+JYUpyEr3xraJEb1wDkyle+jAQiNE+AMUTT1fhh4Clw=";
    };

    meta = with lib; {
      description = "G-code generator for 3D printers (Bambu, Prusa, Voron, VzBot, RatRig, Creality, etc";
      homepage = "https://github.com/SoftFever/OrcaSlicer";
      license = licenses.agpl3Only;
      maintainers = with maintainers; [ zhaofengli ovlach pinpox ];
      mainProgram = "orca-slicer";
      platforms = platforms.linux;
    };
  });
in
orca-slicer

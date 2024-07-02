{ lib, appimageTools, fetchurl }:
let
  pname = "icestudio";
  version = "0.12";

  src = fetchurl {
    url = "https://github.com/FPGAwars/icestudio/releases/download/v${version}/${pname}-${version}-linux64.AppImage";
    hash = "sha256-s+hvD+S2f30u8GrYadFOIjexmyicw6bOlFOvyYyjHeE=";
  };
  extraPkgs = pkgs: [ pkgs.python3 ];

  meta = with lib; {
    description = "Visual editor for open FPGA boards";
    homepage = "https://github.com/FPGAwars/icestudio";
    license = licenses.gpl2;
    maintainers = with maintainers; [ imadnyc jleightcap amerino ];
    mainProgram = "icestudio";
    platforms = ["x86_64-linux"];
  };
in
appimageTools.wrapType2 {
  inherit
    pname
    version
    src
    extraPkgs
    meta
    ;
}

{ lib, buildDotnetModule, fetchFromGitHub, pkgs }:

buildDotnetModule rec {
  pname = "Obj2Tiles";
  version = "1.0.13";

  src = fetchFromGitHub {
    owner = "OpenDroneMap";
    repo = "Obj2Tiles";
    rev = version;
    sha256 = "04hwipsbwvwg3y9y4chx1y9sywsyjwyqqcc0i5yfi1hmd430pcqql";
  };

  nativeBuildInputs = with pkgs; [ dotnetCorePackages.sdk_8_0_3xx ];

  buildPhase = ''
    cd Obj2Tiles
    dotnet build -c Release
  '';

  meta =  {
    description = "Converts OBJ files to OGC 3D tiles by performing splitting, decimation and conversion";
    homepage = "https://github.com/OpenDroneMap/Obj2Tiles";
    license = lib.licenses.agplv3;
    maintainers = with lib.maintainers; [ mapperfr ];
  };
}

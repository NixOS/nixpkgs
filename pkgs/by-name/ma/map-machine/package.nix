{ lib, python3Packages, fetchFromGitHub }:

python3Packages.buildPythonApplication rec {
  pname = "map-machine";
  version = "0.1.9";

  src = fetchFromGitHub {
    owner = "enzet";
    repo = "map-machine";
    rev = "v${version}";
    hash = "sha256-aOfvVyTgDxh7T2oAc+S1eU9b/JjXAhfc3WfR27ECXcY=";
  };

  patches = [
    # see https://github.com/enzet/map-machine/issues/152 and https://github.com/enzet/map-machine/pull/157
    ./0001-fix-Makes-fields-a-keyword-arg-for-urllib3-v1-and-v2.patch
  ];

  checkInputs = [
    python3Packages.pytest
  ];

  propagatedBuildInputs = with python3Packages; [
    urllib3
    svgwrite
    shapely
    pyyaml
    pycairo
    portolan
    pillow
    colour
    cairosvg
    moire
  ];

  meta = with lib; {
    description = "Python renderer for OpenStreetMap with custom icons intended to display as many map features as possible";
    homepage = "https://github.com/enzet/map-machine";
    changelog = "https://github.com/enzet/map-machine/blob/main/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ eliandoran ];
    platforms = platforms.unix;
    sourceProvenance = with sourceTypes; [ fromSource ];
    mainProgram = "map-machine";
  };
}

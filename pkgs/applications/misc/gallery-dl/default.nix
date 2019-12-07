{ lib, python3Packages }:

python3Packages.buildPythonApplication rec {
  pname = "gallery_dl";
  version = "1.11.1";

  src = python3Packages.fetchPypi {
    inherit pname version;
    sha256 = "08py1f48ylw83712h8313rxz55igbszxcwr2yxkchpr4233avzph";
  };

  doCheck = false;
  propagatedBuildInputs = with python3Packages; [ requests ];

  meta = {
    description = "Command-line program to download image-galleries and -collections from several image hosting sites";
    homepage = https://github.com/mikf/gallery-dl;
    license = lib.licenses.gpl2;
    maintainers = with lib.maintainers; [ dawidsowa ];
  };
}

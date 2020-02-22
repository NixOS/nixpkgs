{ lib, python3Packages }:

python3Packages.buildPythonApplication rec {
  pname = "gallery_dl";
  version = "1.12.3";

  src = python3Packages.fetchPypi {
    inherit pname version;
    sha256 = "06q6vmbliy935zlf4bbnfgiqyrx9vskz3fsks4jpxi47xs80rqkz";
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

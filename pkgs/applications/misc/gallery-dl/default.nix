{ lib, python3Packages }:

python3Packages.buildPythonApplication rec {
  pname = "gallery_dl";
  version = "1.13.1";

  src = python3Packages.fetchPypi {
    inherit pname version;
    sha256 = "0a5k7gcs3vn6x1f2qg3ajpqsl39pmw2hsj2srd5y2l1xw7mkkqj6";
  };

  doCheck = false;
  propagatedBuildInputs = with python3Packages; [ requests ];

  meta = {
    description = "Command-line program to download image-galleries and -collections from several image hosting sites";
    homepage = "https://github.com/mikf/gallery-dl";
    license = lib.licenses.gpl2;
    maintainers = with lib.maintainers; [ dawidsowa ];
  };
}

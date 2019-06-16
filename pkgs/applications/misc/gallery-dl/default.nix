{ lib, python3Packages }:

python3Packages.buildPythonApplication rec {
  pname = "gallery_dl";
  version = "1.8.6";

  src = python3Packages.fetchPypi {
    inherit pname version;
    sha256 = "0in47v6c82a6mqg4wzxrji7wd8a9qh5386rsr77s3a8613am1n2x";
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

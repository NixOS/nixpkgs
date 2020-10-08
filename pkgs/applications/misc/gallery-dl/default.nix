{ lib, python3Packages }:

python3Packages.buildPythonApplication rec {
  pname = "gallery_dl";
  version = "1.15.0";

  src = python3Packages.fetchPypi {
    inherit pname version;
    sha256 = "1g9hmb5637x8bhm2wzarqnxzj0i93fcdm1myvld2d97a2d32hy6m";
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

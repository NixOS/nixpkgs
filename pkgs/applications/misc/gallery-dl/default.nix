{ lib, python3Packages }:

python3Packages.buildPythonApplication rec {
  pname = "gallery_dl";
  version = "1.14.2";

  src = python3Packages.fetchPypi {
    inherit pname version;
    sha256 = "14a8skaxc4xn2hm8ahp8lzrmwh1f3lbcibvhpprqr3szd6i2p0pf";
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

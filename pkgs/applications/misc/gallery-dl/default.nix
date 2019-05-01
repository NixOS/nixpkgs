{ lib, python3Packages }:

python3Packages.buildPythonApplication rec {
  pname = "gallery_dl";
  version = "1.8.2";

  src = python3Packages.fetchPypi {
    inherit pname version;
    sha256 = "6c5995b7d24dfaae7bdf71b9261e5044b01adbd5d5302aaff9ac4a30bbceedb6";
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

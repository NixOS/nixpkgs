{ lib, python3Packages }:

python3Packages.buildPythonApplication rec {
  pname = "gallery_dl";
  version = "1.15.1";

  src = python3Packages.fetchPypi {
    inherit pname version;
    sha256 = "1pysh0gz3f3dxk5bfkzaii4myrgik396mf6vlks50inpbnslmqsl";
  };

  propagatedBuildInputs = with python3Packages; [ requests ];

  checkInputs = with python3Packages; [ pytestCheckHook ];
  pytestFlagsArray = [
    # requires network access
    "--ignore=test/test_results.py"
  ];

  meta = {
    description = "Command-line program to download image-galleries and -collections from several image hosting sites";
    homepage = "https://github.com/mikf/gallery-dl";
    license = lib.licenses.gpl2;
    maintainers = with lib.maintainers; [ dawidsowa ];
  };
}

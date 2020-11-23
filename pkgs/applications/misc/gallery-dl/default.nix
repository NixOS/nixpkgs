{ lib, python3Packages }:

python3Packages.buildPythonApplication rec {
  pname = "gallery_dl";
  version = "1.15.2";

  src = python3Packages.fetchPypi {
    inherit pname version;
    sha256 = "0f2d1ixg0ir7ispxxggv378dc0m55k9y19075swf893maxf07f35";
  };

  propagatedBuildInputs = with python3Packages; [ requests ];

  checkInputs = with python3Packages; [ pytestCheckHook ];
  pytestFlagsArray = [
    # requires network access
    "--ignore=test/test_results.py"
    "--ignore=test/test_downloader.py"
  ];

  meta = {
    description = "Command-line program to download image-galleries and -collections from several image hosting sites";
    homepage = "https://github.com/mikf/gallery-dl";
    license = lib.licenses.gpl2;
    maintainers = with lib.maintainers; [ dawidsowa ];
  };
}

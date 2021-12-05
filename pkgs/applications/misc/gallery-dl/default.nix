{ lib, buildPythonApplication, fetchPypi, requests, yt-dlp, pytestCheckHook }:

buildPythonApplication rec {
  pname = "gallery_dl";
  version = "1.19.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "db3973a17f1074e4f4cb99b635b94c1926bdd549263e1df909498f3c6aa93484";
  };

  propagatedBuildInputs = [ requests yt-dlp ];

  checkInputs = [ pytestCheckHook ];
  pytestFlagsArray = [
    # requires network access
    "--ignore=test/test_results.py"
    "--ignore=test/test_downloader.py"
  ];

  meta = with lib; {
    description =
      "Command-line program to download image-galleries and -collections from several image hosting sites";
    homepage = "https://github.com/mikf/gallery-dl";
    changelog =
      "https://github.com/mikf/gallery-dl/raw/v${version}/CHANGELOG.md";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ dawidsowa marsam ];
  };
}

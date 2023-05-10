{ lib, buildPythonApplication, fetchPypi, requests, yt-dlp, pytestCheckHook }:

buildPythonApplication rec {
  pname = "gallery-dl";
  version = "1.25.4";
  format = "setuptools";

  src = fetchPypi {
    inherit version;
    pname = "gallery_dl";
    sha256 = "sha256-4x0XjXriEAJWSmbGjBWxZ5WJW9ruGE9wVrdZYTe6wE4=";
  };

  propagatedBuildInputs = [
    requests
    yt-dlp
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pytestFlagsArray = [
    # requires network access
    "--ignore=test/test_results.py"
    "--ignore=test/test_downloader.py"

    # incompatible with pytestCheckHook
    "--ignore=test/test_ytdl.py"
  ];

  pythonImportsCheck = [
    "gallery_dl"
  ];

  meta = with lib; {
    description = "Command-line program to download image-galleries and -collections from several image hosting sites";
    homepage = "https://github.com/mikf/gallery-dl";
    changelog = "https://github.com/mikf/gallery-dl/raw/v${version}/CHANGELOG.md";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ dawidsowa marsam ];
  };
}

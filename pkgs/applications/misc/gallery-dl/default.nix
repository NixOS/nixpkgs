{ lib, buildPythonApplication, fetchPypi, requests, yt-dlp, pytestCheckHook }:

buildPythonApplication rec {
  pname = "gallery-dl";
<<<<<<< HEAD
  version = "1.25.8";
=======
  version = "1.25.4";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  src = fetchPypi {
    inherit version;
    pname = "gallery_dl";
<<<<<<< HEAD
    sha256 = "sha256-6q2F9zSGZp0iZoBvOUIuIEqNs97hbsbzE23XJyTZUDc=";
=======
    sha256 = "sha256-4x0XjXriEAJWSmbGjBWxZ5WJW9ruGE9wVrdZYTe6wE4=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
    changelog = "https://github.com/mikf/gallery-dl/blob/v${version}/CHANGELOG.md";
    license = licenses.gpl2Only;
    mainProgram = "gallery-dl";
=======
    changelog = "https://github.com/mikf/gallery-dl/raw/v${version}/CHANGELOG.md";
    license = licenses.gpl2Only;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    maintainers = with maintainers; [ dawidsowa marsam ];
  };
}

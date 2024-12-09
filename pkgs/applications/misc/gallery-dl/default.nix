{
  lib,
  buildPythonApplication,
  fetchPypi,
  requests,
  yt-dlp,
  pytestCheckHook,
  nix-update-script,
}:

buildPythonApplication rec {
  pname = "gallery-dl";
  version = "1.27.7";
  format = "setuptools";

  src = fetchPypi {
    inherit version;
    pname = "gallery_dl";
    hash = "sha256-9YcxD7AH4U2dOhAiUnknwwGFy9pplFFQ7Rn4cOvDdEc=";
  };

  propagatedBuildInputs = [
    requests
    yt-dlp
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTests = [
    # requires network access
    "test_init"
  ];

  pytestFlagsArray = [
    # requires network access
    "--ignore=test/test_results.py"
    "--ignore=test/test_downloader.py"

    # incompatible with pytestCheckHook
    "--ignore=test/test_ytdl.py"
  ];

  pythonImportsCheck = [ "gallery_dl" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Command-line program to download image-galleries and -collections from several image hosting sites";
    homepage = "https://github.com/mikf/gallery-dl";
    changelog = "https://github.com/mikf/gallery-dl/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.gpl2Only;
    mainProgram = "gallery-dl";
    maintainers = with lib.maintainers; [ dawidsowa ];
  };
}

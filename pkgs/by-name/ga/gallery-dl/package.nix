{
  lib,
  fetchFromGitHub,
  nix-update-script,
  yt-dlp,
  python3Packages,
}:

let
  pname = "gallery-dl";
  version = "1.30.8";
in
python3Packages.buildPythonApplication {
  inherit pname version;
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mikf";
    repo = "gallery-dl";
    tag = "v${version}";
    hash = "sha256-jetfEjKwAtJwOLKRZfnnnlb7G5YCDUzeHIASqJS3gcI=";
  };

  build-system = [ python3Packages.setuptools ];

  dependencies = [
    python3Packages.requests
    python3Packages.pysocks
    yt-dlp
  ];

  nativeCheckInputs = [ python3Packages.pytestCheckHook ];

  disabledTests = [
    # requires network access
    "test_init"
  ];

  disabledTestPaths = [
    # requires network access
    "test/test_results.py"
    "test/test_downloader.py"

    # incompatible with pytestCheckHook
    "test/test_ytdl.py"
  ];

  pythonImportsCheck = [ "gallery_dl" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/mikf/gallery-dl/blob/v${version}/CHANGELOG.md";
    description = "Command-line program to download image-galleries and -collections from several image hosting sites";
    homepage = "https://github.com/mikf/gallery-dl";
    license = lib.licenses.gpl2Only;
    mainProgram = "gallery-dl";
    maintainers = with lib.maintainers; [
      dawidsowa
      FlameFlag
      lucasew
    ];
  };
}

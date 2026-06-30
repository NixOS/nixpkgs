{
  lib,
  fetchFromCodeberg,
  nix-update-script,
  yt-dlp,
  python3Packages,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "gallery-dl";
  version = "1.32.5";
  pyproject = true;

  src = fetchFromCodeberg {
    owner = "mikf";
    repo = "gallery-dl";
    tag = "v${finalAttrs.version}";
    hash = "sha256-6E4PgJ6VWI0c6TyQOZ0siqsMxNNLpymy8/rANWaBVnU=";
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
    changelog = "https://codeberg.org/mikf/gallery-dl/src/tag/v${finalAttrs.version}/CHANGELOG.md";
    description = "Command-line program to download image-galleries and -collections from several image hosting sites";
    homepage = "https://codeberg.org/mikf/gallery-dl";
    license = lib.licenses.gpl2Only;
    mainProgram = "gallery-dl";
    maintainers = with lib.maintainers; [
      dawidsowa
      FlameFlag
    ];
  };
})

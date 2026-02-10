{
  lib,
  fetchFromGitHub,
  nix-update-script,
  yt-dlp,
  python3Packages,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "gallery-dl";
  version = "1.31.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mikf";
    repo = "gallery-dl";
    tag = "v${finalAttrs.version}";
    hash = "sha256-jrTLiZs3LJaFZL40vxWS/1J9HHke9gmV9840AOUtLCU=";
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
    changelog = "https://github.com/mikf/gallery-dl/blob/v${finalAttrs.version}/CHANGELOG.md";
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
})

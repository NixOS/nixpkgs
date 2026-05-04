{
  fetchFromGitHub,
  lib,
  python3Packages,
  versionCheckHook,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "consumo";
  version = "0.13.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "gbr-ufs";
    repo = "consumo";
    tag = finalAttrs.version;
    hash = "sha256-qVvXD7JaaCwVL9WV6SeIN2j5HLEotYEi+X6cYUJxL0Q=";
  };

  build-system = [ python3Packages.uv-build ];

  dependencies = with python3Packages; [
    av
    beautifulsoup4
    brotli
    lxml
    pydantic
    pymupdf
    python-magic
    trafilatura
    typer
    yt-dlp
    zstandard
  ];

  nativeCheckInputs = with python3Packages; [
    pytest-cov-stub
    pytestCheckHook
  ];

  /*
    False positive from pythonRuntimeDepsCheckHook:
      - "bs4" is the import name for beautifulsoup4 (not the PyPI
        package name)
  */
  pythonRemoveDeps = [
    "bs4"
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  __structuredAttrs = true;

  meta = {
    changelog = "https://github.com/gbr-ufs/consumo/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    description = "Content consumption analyzer CLI";
    homepage = "https://gbr-ufs.github.io/consumo/";
    license = lib.licenses.gpl3Plus;
    mainProgram = "consumo";
    maintainers = with lib.maintainers; [ gbr-ufs ];
  };
})

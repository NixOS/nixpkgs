{
  lib,
  fetchFromGitHub,
  nix-update-script,
  python3Packages,
  versionCheckHook,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "pwneye";
  version = "1.3.2";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "Hackerest";
    repo = "pwneye";
    tag = "v${finalAttrs.version}";
    hash = "sha256-CF0A4o+J7KQByoWNRbl2OGh4saqKAf6jJCGgtVQ3y6o=";
  };

  pythonRelaxDeps = true;

  build-system = with python3Packages; [ setuptools ];

  dependencies = with python3Packages; [
    attrs
    certifi
    charset-normalizer
    idna
    ifaddr
    isodate
    lxml
    markdown-it-py
    mdurl
    onvif-python
    ping3
    platformdirs
    pygments
    pyqt6
    pytz
    pyyaml
    requests
    requests-file
    requests-toolbelt
    rich
    rich-argparse
    urllib3
    zeep
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];

  doInstallCheck = true;

  pythonImportsCheck = [ "pwneye" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Tool for discovering and working with ONVIF and RTSP cameras";
    homepage = "https://github.com/Hackerest/pwneye";
    changelog = "https://github.com/Hackerest/pwneye/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "pwneye";
  };
})

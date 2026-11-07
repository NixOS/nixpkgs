{
  lib,
  python3Packages,
  fetchFromGitHub,
  just,
  makeWrapper,
  versionCheckHook,
  nix-update-script,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "justx";
  version = "0.5.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "fpgmaas";
    repo = "justx";
    tag = finalAttrs.version;
    hash = "sha256-eSV959rMcxiLBYoVRsF6XIf4ktZZOVm2oi6etBqJJxo=";
  };

  pythonRelaxDeps = [
    "rich"
    "textual"
  ];

  build-system = [
    python3Packages.hatchling
  ];

  dependencies = with python3Packages; [
    click
    pydantic
    questionary
    rich
    textual
  ];

  pythonImportsCheck = [
    "justx"
  ];

  nativeBuildInputs = [ makeWrapper ];

  # Version in pyproject.toml does that match the release tag version.
  # Remove this patch once they are fixed in the project to be in sync.
  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail 'version = "0.0.1"' 'version = "${finalAttrs.version}"'
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  postFixup = ''
    wrapProgram "$out/bin/justx" \
      --prefix PATH : "${lib.makeBinPath [ just ]}"
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "TUI command launcher built on top of just";
    homepage = "https://fpgmaas.github.io/justx/";
    downloadPage = "https://github.com/fpgmaas/justx";
    changelog = "https://github.com/fpgmaas/justx/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kpbaks ];
    mainProgram = "justx";
  };
})

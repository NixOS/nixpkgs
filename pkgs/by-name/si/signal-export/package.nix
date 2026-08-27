{
  lib,
  python3,
  fetchPypi,
  nix-update-script,
  writableTmpDirAsHomeHook,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "signal-export";
  version = "3.9.2";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) version;
    pname = "signal_export";
    hash = "sha256-ZAQ/qGpNzlpvFMIxKCDhtm5sez0tATY+l+jvXWaNbIc=";
  };

  build-system = with python3.pkgs; [
    pdm-backend
  ];

  propagatedBuildInputs = with python3.pkgs; [
    typer
    beautifulsoup4
    emoji
    filetype
    markdown
    pycryptodome
    sqlcipher3-wheels
  ];

  nativeCheckInputs = [
    python3.pkgs.pytestCheckHook
    # tests/test_overwrite.py asserts that Path.home() exists
    writableTmpDirAsHomeHook
  ];

  pythonImportsCheck = [ "sigexport" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    mainProgram = "sigexport";
    homepage = "https://github.com/carderne/signal-export";
    description = "Export your Signal chats to markdown files with attachments";
    platforms = lib.platforms.unix;
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      phaer
      picnoir
    ];
  };
})

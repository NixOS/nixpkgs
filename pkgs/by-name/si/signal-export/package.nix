{
  lib,
  python3,
  fetchPypi,
  nix-update-script,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "signal-export";
  version = "3.8.3";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) version;
    pname = "signal_export";
    hash = "sha256-V6yo1nimjQJgbf17A/RSe/vykfCxcFFL0xZaQY3k0Tk=";
  };

  build-system = with python3.pkgs; [
    pdm-backend
  ];

  propagatedBuildInputs = with python3.pkgs; [
    typer
    beautifulsoup4
    emoji
    markdown
    pycryptodome
    sqlcipher3-wheels
  ];

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

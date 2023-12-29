{ lib
, python3
, fetchPypi
, nix-update-script
}:

python3.pkgs.buildPythonApplication rec {
  pname = "signal-export";
  version = "1.7.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-OikD5z0Ota0w4PTdLU4cz0YO/bJHAlzy3nup06GtiS4=";
  };

  nativeBuildInputs = with python3.pkgs; [
    setuptools-scm
  ];

  propagatedBuildInputs = with python3.pkgs; [
    setuptools
    typer
    beautifulsoup4
    emoji
    markdown
    pysqlcipher3
  ];

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    mainProgram = "sigexport";
    homepage = "https://github.com/carderne/signal-export";
    description = "Export your Signal chats to markdown files with attachments.";
    platforms = platforms.unix;
    license = licenses.mit;
    maintainers = with maintainers; [ phaer picnoir ];
  };
}

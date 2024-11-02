{ lib
, python3
, fetchPypi
, nix-update-script
}:

python3.pkgs.buildPythonApplication rec {
  pname = "signal-export";
  version = "3.2.0";
  pyproject = true;

  src = fetchPypi {
    inherit version;
    pname = "signal_export";
    hash = "sha256-b0oJXUbJ9545oVMXBcM4MFjK3U3RiAT1lv9NUu6gF04=";
  };

  nativeBuildInputs = with python3.pkgs; [
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

  meta = with lib; {
    mainProgram = "sigexport";
    homepage = "https://github.com/carderne/signal-export";
    description = "Export your Signal chats to markdown files with attachments";
    platforms = platforms.unix;
    license = licenses.mit;
    maintainers = with maintainers; [ phaer picnoir ];
  };
}

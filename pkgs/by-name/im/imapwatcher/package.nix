{
  lib,
  fetchFromGitHub,
  python3,
  replaceVars,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "IMAPWatcher";
  version = "1.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "OpenIndex";
    repo = "IMAPWatcher";
    tag = version;
    hash = "sha256-x+tQ/B10EMf20e1w2FhNpW/LhSfU0/Ef6uu8KkuQYao=";
  };

  build-system = with python3.pkgs; [
    setuptools
  ];

  dependencies = with python3.pkgs; [
    imapclient
  ];

  postPatch =
    let
      setup = replaceVars ./setup.py {
        inherit pname version;
      };
    in
    ''
      ln -s ${setup} setup.py
      ln -s ${./beforeMain.py} src/beforeMain.py
    '';

  meta = {
    description = "Watches one or more IMAP accounts for incoming messages via IMAP IDLE";
    homepage = "https://github.com/OpenIndex/IMAPWatcher";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ baksa ];
    mainProgram = "imapwatcher";
  };
}

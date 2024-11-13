{
  fetchPypi,
  lib,
  python3,
}:
python3.pkgs.buildPythonApplication rec {
  pname = "Exegol";
  version = "4.3.1";
  format = "setuptools";

  # Project has no unit tests
  doCheck = false;

  propagatedBuildInputs = with python3.pkgs; [
    pyyaml
    gitpython
    docker
    requests
    rich
    argcomplete
  ];

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-cMbMmkG52A104iHVwe+6k1Fazi7fISeU/doWJqw5Whw=";
  };

  meta = with lib; {
    description = "Fully featured and community-driven hacking environment";
    longDescription = ''
      Exegol is a community-driven hacking environment, powerful and yet
      simple enough to be used by anyone in day to day engagements. Exegol is
      the best solution to deploy powerful hacking environments securely,
      easily, professionally. Exegol fits pentesters, CTF players, bug bounty
      hunters, researchers, beginners and advanced users, defenders, from
      stylish macOS users and corporate Windows pros to UNIX-like power users.
    '';
    homepage = "https://github.com/ThePorgs/Exegol";
    changelog = "https://github.com/ThePorgs/Exegol/releases/tag/${version}";
    license = licenses.gpl3Only;
    mainProgram = "exegol";
    maintainers = with maintainers; [ _0b11stan ];
  };
}

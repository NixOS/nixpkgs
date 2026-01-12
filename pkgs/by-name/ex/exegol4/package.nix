{
  fetchPypi,
  lib,
  python3Packages,
  xorg,
}:
python3Packages.buildPythonApplication rec {
  pname = "exegol";
  version = "4.3.11";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-+LnZSFRW7EvG+cPwMStgO6qD4AjOGkLzCarXBrW3Aak=";
  };

  build-system = with python3Packages; [ pdm-backend ];

  pythonRelaxDeps = [
    "rich"
    "argcomplete"
  ];

  dependencies =
    with python3Packages;
    [
      pyyaml
      gitpython
      docker
      requests
      rich
      argcomplete
      tzlocal
    ]
    ++ [ xorg.xhost ];

  doCheck = true;

  pythonImportsCheck = [ "exegol" ];

  meta = {
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
    license = lib.licenses.gpl3Only;
    mainProgram = "exegol";
    maintainers = with lib.maintainers; [
      _0b11stan
      charB66
    ];
  };
}

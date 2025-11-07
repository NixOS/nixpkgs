{
  lib,
  fetchFromGitHub,
  python3Packages,
  xorg,
}:
python3Packages.buildPythonApplication rec {
  pname = "exegol";
  version = "5.1.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ThePorgs";
    repo = "Exegol";
    tag = version;
    hash = "sha256-eoOCVYKHWPsaSxdOF3FTg6dS5JdTSlfNTM6Hrf6KTlc=";
  };

  build-system = with python3Packages; [ pdm-backend ];

  pythonRelaxDeps = [
    "rich"
    "argcomplete"
    "supabase"
  ];

  dependencies =
    with python3Packages;
    [
      argcomplete
      cryptography
      docker
      gitpython
      ifaddr
      pydantic
      pyjwt
      pyyaml
      requests
      rich
      supabase
    ]
    ++ pyjwt.optional-dependencies.crypto
    ++ [ xorg.xhost ]
    ++ lib.optional (!stdenv.hostPlatform.isLinux) tzlocal;

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
    changelog = "https://github.com/ThePorgs/Exegol/releases/tag/${src.tag}";
    license = with lib.licenses; [
      gpl3Only
      {
        fullName = "Exegol Software License (ESL) - Version 1.0";
        url = "https://docs.exegol.com/legal/software-license";
        # Please use exegol4 if you prefer to avoid the unfree version of Exegol.
        free = false;
        redistributable = false;
      }
    ];
    mainProgram = "exegol";
    maintainers = with lib.maintainers; [
      _0b11stan
      charB66
    ];
  };
}

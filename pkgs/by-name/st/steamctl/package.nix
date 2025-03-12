{
  fetchFromGitHub,
  lib,
  python3,
}:
python3.pkgs.buildPythonApplication rec {
  pname = "steamctl";
  version = "0.9.5";

  src = fetchFromGitHub {
    owner = "ValvePython";
    repo = "steamctl";
    rev = "refs/tags/v${version}";
    hash = "sha256-reNch5MP31MxyaeKUlANfizOXZXjtIDeSM1kptsWqkc=";
  };

  build-system = [ python3.pkgs.setuptools ];

  dependencies =
    with python3.pkgs;
    [
      appdirs
      argcomplete
      arrow
      beautifulsoup4
      pyqrcode
      steam
      tqdm
      vpk
    ]
    ++ steam.optional-dependencies.client;

  pythonImportsCheck = [ "steamctl" ];

  meta = {
    description = "Take control of Steam from your terminal";
    longDescription = ''
      steamctl is an open-source CLI utility similar to steamcmd.

      It provides access to a number of Steam features and data from the command line.

      While it is possible to download apps and content from Steam, steamctl is not a game launcher.
    '';
    homepage = "https://github.com/ValvePython/steamctl";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jackwilsdon ];
    mainProgram = "steamctl";
  };
}

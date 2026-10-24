{
  fetchFromGitHub,
  python3Packages,
  lib,
}:
python3Packages.buildPythonApplication {
  pname = "rsrcdump";
  version = "0-unstable-2023-12-30";

  src = fetchFromGitHub {
    owner = "jorio";
    repo = "rsrcdump";
    rev = "7426f3cb41e3cd237a01d6f2871f020bfbb6c9aa";
    hash = "sha256-O1BfVIWhZMqNmBAVSqWPXmQ5FZ9Xchki23JGCAADggc=";
  };

  pyproject = true;
  build-system = [
    python3Packages.poetry-core
  ];

  meta = {
    description = "Extract and convert Mac resource forks";
    homepage = "https://github.com/jorio/rsrcdump";
    license = with lib.licenses; [ mit ];
    platforms = lib.platforms.all;
    mainProgram = "rsrcdump";
    maintainers = with lib.maintainers; [ zacharyweiss ];
  };
}

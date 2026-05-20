{
  lib,
  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonApplication {
  pname = "cambrinary";
  version = "unstable-2023-07-16";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "xueyuanl";
    repo = "cambrinary";
    rev = "f0792ef70654a48a7677b6e1a7dee454b2c0971c";
    hash = "sha256-wDcvpKAY/6lBjO5h3qKH3+Y2G2gm7spcKCXFMt/bAtE=";
  };

  nativeBuildInputs = [
    python3Packages.flit
  ];

  propagatedBuildInputs = [
    python3Packages.aiohttp
    python3Packages.beautifulsoup4
  ];

  pythonImportsCheck = [ "cambrinary" ];

  meta = {
    description = "Cambridge dictionary in a terminal";
    mainProgram = "cambrinary";
    homepage = "https://github.com/xueyuanl/cambrinary";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.unix;
    maintainers = [ ];
  };
}

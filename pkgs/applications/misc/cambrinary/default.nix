{
  lib,
  buildPythonApplication,
  fetchFromGitHub,
  flit,
  aiohttp,
  beautifulsoup4,
}:

buildPythonApplication rec {
  pname = "cambrinary";
  version = "unstable-2023-07-16";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "xueyuanl";
    repo = "cambrinary";
    rev = "f0792ef70654a48a7677b6e1a7dee454b2c0971c";
    hash = "sha256-wDcvpKAY/6lBjO5h3qKH3+Y2G2gm7spcKCXFMt/bAtE=";
  };

  nativeBuildInputs = [
    flit
  ];

  propagatedBuildInputs = [
    aiohttp
    beautifulsoup4
  ];

  pythonImportsCheck = [ "cambrinary" ];

  meta = with lib; {
    description = "Cambridge dictionary in a terminal";
    mainProgram = "cambrinary";
    homepage = "https://github.com/xueyuanl/cambrinary";
    license = licenses.gpl3Only;
    platforms = platforms.unix;
    maintainers = with maintainers; [ azahi ];
  };
}

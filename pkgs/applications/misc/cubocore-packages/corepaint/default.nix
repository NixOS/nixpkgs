{
  mkDerivation,
  lib,
  fetchFromGitLab,
  qtbase,
  cmake,
  ninja,
  libcprime,
  libcsys,
}:

mkDerivation rec {
  pname = "corepaint";
  version = "4.5.0";

  src = fetchFromGitLab {
    owner = "cubocore/coreapps";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-ndknVT/gl2P0s3ADW0txiVtAyI/l/ZFWEgufFleS0A4=";
  };

  nativeBuildInputs = [
    cmake
    ninja
  ];

  buildInputs = [
    qtbase
    libcprime
    libcsys
  ];

  meta = {
    description = "Paint app from the C Suite";
    mainProgram = "corepaint";
    homepage = "https://gitlab.com/cubocore/coreapps/corepaint";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ dan4ik605743 ];
    platforms = lib.platforms.linux;
  };
}

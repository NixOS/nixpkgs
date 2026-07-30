{
  lib,
  stdenv,
  fetchFromGitLab,
  qt6,
  cmake,
  ninja,
  libcprime,
  libcsys,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "corepins";
  version = "5.0.1";

  src = fetchFromGitLab {
    owner = "cubocore/coreapps";
    repo = "corepins";
    tag = "v${finalAttrs.version}";
    hash = "sha256-+cWhlqIK2Oqx4Zt1sRd7xvGwmbYOZbMMU+k5uNnkogk=";
  };

  nativeBuildInputs = [
    cmake
    ninja
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    qt6.qtbase
    libcprime
    libcsys
  ];

  meta = {
    description = "Bookmarking app from the C Suite";
    mainProgram = "corepins";
    homepage = "https://gitlab.com/cubocore/coreapps/corepins";
    license = lib.licenses.gpl3Plus;
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
})

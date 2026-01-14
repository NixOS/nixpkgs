{
  lib,
  stdenv,
  fetchFromGitLab,
  qt6,
  libarchive,
  libarchive-qt,
  cmake,
  ninja,
  libcprime,
  libcsys,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "coregarage";
  version = "5.0.0";

  src = fetchFromGitLab {
    owner = "cubocore/coreapps";
    repo = "coregarage";
    tag = "v${finalAttrs.version}";
    hash = "sha256-boe7z8KPnMaoWekBFS4g/Ay98rpREeLMAsHOr2olYws=";
  };

  nativeBuildInputs = [
    cmake
    ninja
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    qt6.qtbase
    libarchive
    libarchive-qt
    libcprime
    libcsys
  ];

  meta = {
    description = "Settings manager for the C Suite";
    mainProgram = "coregarage";
    homepage = "https://gitlab.com/cubocore/coreapps/coregarage";
    license = lib.licenses.gpl3Plus;
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
})

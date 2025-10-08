{
  lib,
  stdenv,
  fetchFromGitLab,
  libnotify,
  cmake,
  ninja,
  qt6,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libcprime";
  version = "5.0.0";

  src = fetchFromGitLab {
    owner = "cubocore";
    repo = "libcprime";
    tag = "v${finalAttrs.version}";
    hash = "sha256-3tAbF4CoZJf92Z2/M/Cq7ruPew34Hl5Ojks7fI6kPbU=";
  };

  patches = [
    ./0001-fix-application-dirs.patch
  ];

  nativeBuildInputs = [
    cmake
    ninja
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qtconnectivity
    libnotify
  ];

  dontWrapQtApps = true;

  meta = {
    description = "Library for bookmarking, saving recent activites, managing settings of C-Suite";
    homepage = "https://gitlab.com/cubocore/libcprime";
    license = lib.licenses.gpl3Plus;
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
})

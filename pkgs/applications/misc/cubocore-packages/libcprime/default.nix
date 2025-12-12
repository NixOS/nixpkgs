{
  lib,
  stdenv,
  fetchFromGitLab,
  fetchpatch,
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

    # cmake-4 support
    (fetchpatch {
      name = "cmake-4.patch";
      url = "https://gitlab.com/cubocore/libcprime/-/commit/505931e9634d1b55ea97bdaa0f68dcd51faaea39.patch";
      hash = "sha256-toWG78tW6qOETTMb63/WtSyIiGkJ00RlPyGTqrWPnLY=";
    })
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

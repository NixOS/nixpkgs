{stdenv
,lib
, cmake
, pkg-config
, fetchFromGitHub
, qtbase
, qttools
, kwidgetsaddons
, kwindowsystem
, fmt
, libpsl
, cxxopts
, wrapQtAppsHook
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "tremotesf";
  version = "2.5.0";

  src = fetchFromGitHub {
    owner = "equeim";
    repo = "tremotesf2";
    rev = finalAttrs.version;
    hash = "sha256-mxk2BRUuet3XSNaKt2Dnnxe5dliazd1ArRSnKyoAp1s=";
    # We need this for src/libtremotesf
    fetchSubmodules = true;
  };

  buildInputs = [
    qtbase
    qttools
    fmt
    libpsl
    kwidgetsaddons
    kwindowsystem
    cxxopts
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  propagatedBuildInputs = [ wrapQtAppsHook ];

  meta = with lib; {
    description = "Remote GUI for transmission-daemon";
    license = licenses.gpl3Plus;
    homepage = "https://github.com/equeim/tremotesf2";
    maintainers = with maintainers; [ sochotnicky ];
  };
})

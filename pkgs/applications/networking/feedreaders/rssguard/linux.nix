{
  pname,
  version,
  meta,
  stdenv,
  fetchFromGitHub,
  cmake,
  kdePackages,
  wrapGAppsHook4,
}:

stdenv.mkDerivation rec {
  inherit pname version meta;

  src = fetchFromGitHub {
    owner = "martinrotter";
    repo = pname;
    rev = "refs/tags/${version}";
    sha256 = "sha256-qWxcjGl4EaLXZ0q6RVy+IKyBcqlx/yYojlGivSXy5Io=";
  };

  buildInputs = [
    kdePackages.qtwebengine
    kdePackages.qttools
    kdePackages.mpvqt
    kdePackages.full
  ];
  nativeBuildInputs = [
    cmake
    wrapGAppsHook4
    kdePackages.wrapQtAppsHook
  ];
  cmakeFlags = [
    "-DCMAKE_BUILD_TYPE=\"Release\""
  ];
}

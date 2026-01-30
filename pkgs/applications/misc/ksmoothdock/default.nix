{
  lib,
  mkDerivation,
  fetchFromGitHub,
  cmake,
  extra-cmake-modules,
  kactivities,
  qtbase,
}:

mkDerivation rec {
  pname = "KSmoothDock";
  version = "6.3";

  src = fetchFromGitHub {
    owner = "dangvd";
    repo = "ksmoothdock";
    rev = "v${version}";
    sha256 = "sha256-hO7xgjFMFrEhQs3oc2peFTjSVEDsl7Ma/TeVybEZMEk=";
  };

  # Upstream seems dead and there are new deprecation warnings in KF5.100
  # Remember, kids: friends don't let friends build with -Werror
  postPatch = ''
    substituteInPlace src/CMakeLists.txt --replace "-Werror" ""
  '';

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
  ];

  buildInputs = [
    kactivities
    qtbase
  ];

  cmakeDir = "../src";

  meta = {
    description = "Cool desktop panel for KDE Plasma 5";
    mainProgram = "ksmoothdock";
    license = lib.licenses.mit;
    homepage = "https://dangvd.github.io/ksmoothdock/";
    platforms = lib.platforms.linux;
  };
}

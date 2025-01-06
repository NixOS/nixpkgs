{
  lib,
  stdenv,
  cmake,
  extra-cmake-modules,
  plasma-framework,
  kwindowsystem,
  plasma-pa,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  pname = "plasma-applet-volumewin7mixer";
  version = "26";

  src = fetchFromGitHub {
    owner = "Zren";
    repo = "plasma-applet-volumewin7mixer";
    rev = "v${version}";
    sha256 = "sha256-VMOUNtAURTHDuJBOGz2N0+3VzxBmVNC1O8dVuyUZAa4=";
  };

  # Adds the CMakeLists.txt not provided by upstream
  patches = [ ./cmake.patch ];
  postPatch = "rm build";
  nativeBuildInputs = [
    cmake
    extra-cmake-modules
  ];
  buildInputs = [
    plasma-framework
    kwindowsystem
    plasma-pa
  ];

  dontWrapQtApps = true;

  meta = with lib; {
    description = "Fork of the default volume plasmoid with a Windows 7 theme (vertical sliders)";
    homepage = "https://github.com/Zren/plasma-applet-volumewin7mixer";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ mdevlamynck ];
  };
}

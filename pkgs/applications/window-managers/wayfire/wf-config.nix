{ stdenv
, lib
, fetchFromGitHub
, cmake
, meson
, ninja
, pkg-config
, doctest
, glm
, libevdev
, libxml2
}:

stdenv.mkDerivation rec {
  pname = "wf-config";
  version = "0.7.1";

  src = fetchFromGitHub {
    owner = "WayfireWM";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-ADUBvDJcPYEB9ZvaFIgTfemo1WYwiWgCWX/z2yrEPtA=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    libevdev
    libxml2
  ];

  propagatedBuildInputs = [
    glm
  ];

  nativeCheckInputs = [
    cmake
    doctest
  ];
  # CMake is just used for finding doctest.
  dontUseCmakeConfigure = true;

  mesonFlags = [
    (lib.mesonEnable "tests" (stdenv.buildPlatform.canExecute stdenv.hostPlatform))
  ];

  doCheck = true;

  meta = with lib; {
    homepage = "https://github.com/WayfireWM/wf-config";
    description = "Library for managing configuration files, written for Wayfire";
    license = licenses.mit;
    maintainers = with maintainers; [ qyliss wucke13 rewine ];
    platforms = platforms.unix;
  };
}

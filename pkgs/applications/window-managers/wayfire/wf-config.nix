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

<<<<<<< HEAD
stdenv.mkDerivation (finalAttrs: {
=======
stdenv.mkDerivation rec {
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  pname = "wf-config";
  version = "0.7.1";

  src = fetchFromGitHub {
    owner = "WayfireWM";
<<<<<<< HEAD
    repo = "wf-config";
    rev = "v${finalAttrs.version}";
    hash = "sha256-ADUBvDJcPYEB9ZvaFIgTfemo1WYwiWgCWX/z2yrEPtA=";
=======
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-ADUBvDJcPYEB9ZvaFIgTfemo1WYwiWgCWX/z2yrEPtA=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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

<<<<<<< HEAD
  meta = {
    homepage = "https://github.com/WayfireWM/wf-config";
    description = "Library for managing configuration files, written for Wayfire";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ qyliss wucke13 rewine ];
    platforms = lib.platforms.unix;
  };
})
=======
  meta = with lib; {
    homepage = "https://github.com/WayfireWM/wf-config";
    description = "Library for managing configuration files, written for Wayfire";
    license = licenses.mit;
    maintainers = with maintainers; [ qyliss wucke13 rewine ];
    platforms = platforms.unix;
  };
}
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

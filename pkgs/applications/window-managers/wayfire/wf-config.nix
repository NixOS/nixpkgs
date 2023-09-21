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

stdenv.mkDerivation (finalAttrs: {
  pname = "wf-config";
  version = "0.7.1";

  src = fetchFromGitHub {
    owner = "WayfireWM";
    repo = "wf-config";
    rev = "v${finalAttrs.version}";
    hash = "sha256-ADUBvDJcPYEB9ZvaFIgTfemo1WYwiWgCWX/z2yrEPtA=";
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

  meta = {
    homepage = "https://github.com/WayfireWM/wf-config";
    description = "Library for managing configuration files, written for Wayfire";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ qyliss wucke13 rewine ];
    platforms = lib.platforms.unix;
  };
})

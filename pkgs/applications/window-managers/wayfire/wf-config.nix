{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  meson,
  ninja,
  pkg-config,
  doctest,
  glm,
  libevdev,
  libxml2,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "wf-config";
  version = "0.11.0-unstable-2026-02-20";

  src = fetchFromGitHub {
    owner = "WayfireWM";
    repo = "wf-config";
    rev = "a2051f5d131a23acdcd96bfeb509d01cf57139ec";
    hash = "sha256-K6VKGeUM9pP0jHw9jIvV5vUdNYfPBldBXG82/WqbYro=";
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
  ];
  checkInputs = [
    doctest
  ];
  # CMake is just used for finding doctest.
  dontUseCmakeConfigure = true;

  strictDeps = true;

  mesonFlags = [
    (lib.mesonEnable "tests" (stdenv.buildPlatform.canExecute stdenv.hostPlatform))
  ];

  doCheck = true;

  meta = {
    homepage = "https://github.com/WayfireWM/wf-config";
    description = "Library for managing configuration files, written for Wayfire";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      teatwig
      wucke13
      wineee
    ];
    platforms = lib.platforms.unix;
  };
})

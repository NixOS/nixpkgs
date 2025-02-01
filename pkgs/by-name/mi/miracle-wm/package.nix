{
  stdenv,
  lib,
  fetchFromGitHub,
  fetchpatch,
  gitUpdater,
  nixosTests,
  boost,
  cmake,
  glib,
  glm,
  gtest,
  json_c,
  libevdev,
  libglvnd,
  libnotify,
  libuuid,
  libxkbcommon,
  mesa,
  mir,
  nlohmann_json,
  pcre2,
  pkg-config,
  wayland,
  yaml-cpp,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "miracle-wm";
  version = "0.3.5";

  src = fetchFromGitHub {
    owner = "mattkae";
    repo = "miracle-wm";
    rev = "v${finalAttrs.version}";
    hash = "sha256-2OoMkD4ChNXzqqzdOvzYRL0UYU7Uecm5yTXCvG45jCI=";
  };

  patches = [
    # Remove when https://github.com/mattkae/miracle-wm/pull/211 merged & in release
    (fetchpatch {
      name = "0001-miracle-wm-Dont-ignore-PKG_CONFIG_PATH.patch";
      url = "https://github.com/mattkae/miracle-wm/commit/a9fe6ed1e7dc605f72e18cdc2d19afb3c187be3a.patch";
      hash = "sha256-zzOwqUjyZGYIy/3BvOiedfCubrqaeglvsAzTXyq3wYU=";
    })
  ];

  postPatch =
    ''
      substituteInPlace session/usr/local/share/wayland-sessions/miracle-wm.desktop.in \
        --replace-fail '@CMAKE_INSTALL_FULL_BINDIR@/miracle-wm' 'miracle-wm'
    ''
    + lib.optionalString (!finalAttrs.finalPackage.doCheck) ''
      substituteInPlace CMakeLists.txt \
        --replace-fail 'add_subdirectory(tests/)' ""
    '';

  strictDeps = true;

  # Source has a path "session/usr/local/...", don't break references to that
  dontFixCmake = true;

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    boost
    glib
    glm
    json_c
    libevdev
    libglvnd
    libnotify
    libuuid
    libxkbcommon
    mesa # gbm.h
    mir
    nlohmann_json
    pcre2
    wayland
    yaml-cpp
  ];

  checkInputs = [ gtest ];

  doCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;

  checkPhase = ''
    runHook preCheck

    ./bin/miracle-wm-tests

    runHook postCheck
  '';

  passthru = {
    updateScript = gitUpdater { rev-prefix = "v"; };
    providedSessions = [ "miracle-wm" ];
    tests.vm = nixosTests.miracle-wm;
  };

  meta = with lib; {
    description = "Tiling Wayland compositor based on Mir";
    longDescription = ''
      miracle-wm is a Wayland compositor based on Mir. It features a tiling window manager at its core, very much in
      the style of i3 and sway. The intention is to build a compositor that is flashier and more feature-rich than
      either of those compositors, like swayfx.

      See the user guide for info on how to use miracle-wm: https://github.com/mattkae/miracle-wm/blob/v${finalAttrs.version}/USERGUIDE.md
    '';
    homepage = "https://github.com/mattkae/miracle-wm";
    license = licenses.gpl3Only;
    mainProgram = "miracle-wm";
    maintainers = with maintainers; [ OPNA2608 ];
    platforms = platforms.linux;
  };
})

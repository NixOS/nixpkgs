{
  stdenv,
  lib,
  fetchFromGitHub,
  gitUpdater,
  nixosTests,
  cmake,
  glib,
  gtest,
  libevdev,
  libnotify,
  libxkbcommon,
  mir,
  nlohmann_json,
  pkg-config,
  yaml-cpp,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "miracle-wm";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "mattkae";
    repo = "miracle-wm";
    rev = "v${finalAttrs.version}";
    hash = "sha256-bpKv0E3nfnJkeYsVgJ/d3f8bCZ1mBn9Faj5YUXsPCAk=";
  };

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
    glib
    libevdev
    libnotify
    libxkbcommon
    mir
    nlohmann_json
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

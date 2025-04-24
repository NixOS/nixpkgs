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
  version = "0.3.7";

  src = fetchFromGitHub {
    owner = "miracle-wm-org";
    repo = "miracle-wm";
    rev = "v${finalAttrs.version}";
    hash = "sha256-31S7Mfz3LIOAmDUl6jbr3kSP2BdLaM0M4xMZ8FHhLH0=";
  };

  patches = [
    # Remove when version > 0.3.7
    (fetchpatch {
      name = "0001-miracle-wm-Dont-override-PKG_CONFIG_PATH.patch";
      url = "https://github.com/miracle-wm-org/miracle-wm/commit/0a8809d4362e1d3abbea6e29fd1234c8fa981bfb.patch";
      hash = "sha256-Fy/fDmV1uXRt4omxccpFkZb0vE8iHYSS9A7E+PEFBOM=";
    })

    # Remove when version > 0.3.7
    (fetchpatch {
      name = "0002-miracle-wm-Fix-mir-2.19-support.patch";
      url = "https://github.com/miracle-wm-org/miracle-wm/commit/a9db8b539a5396e9df6f6f009cbabcbb053f2b05.patch";
      hash = "sha256-VxUVpwBSHuLzs0yEQ7gStpMnHRJJtZ/Shmjb2un3qI0=";
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

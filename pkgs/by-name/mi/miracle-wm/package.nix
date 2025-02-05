{
  stdenv,
  lib,
  fetchFromGitHub,
  gitUpdater,
  nixosTests,
  boost,
  cmake,
  coreutils,
  dbus,
  glib,
  glm,
  gtest,
  json_c,
  libevdev,
  libglvnd,
  libnotify,
  libuuid,
  libxkbcommon,
  libgbm,
  makeWrapper,
  mir,
  nlohmann_json,
  pcre2,
  pkg-config,
  systemd,
  wayland,
  yaml-cpp,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "miracle-wm";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "miracle-wm-org";
    repo = "miracle-wm";
    tag = "v${finalAttrs.version}";
    hash = "sha256-LPcVLpskpmHc8EzdNqMT6BnbY8Le/BVojpXPIqy6tGI=";
  };

  postPatch =
    ''
      substituteInPlace CMakeLists.txt \
        --replace-fail 'DESTINATION /usr/lib' 'DESTINATION ''${CMAKE_INSTALL_LIBDIR}'
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
    makeWrapper
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
    libgbm
    mir
    nlohmann_json
    pcre2
    wayland
    yaml-cpp
  ];

  checkInputs = [ gtest ];

  cmakeFlags = [
    (lib.cmakeBool "SYSTEMD_INTEGRATION" true)
  ];

  doCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;

  checkPhase = ''
    runHook preCheck

    ./bin/miracle-wm-tests

    runHook postCheck
  '';

  postFixup = ''
    patchShebangs $out/libexec/miracle-wm-session-setup
    wrapProgram $out/libexec/miracle-wm-session-setup \
      --prefix PATH : "$out/bin:${
        lib.makeBinPath [
          coreutils # cat
          dbus # dbus-update-activation-environment
          systemd # systemctl
        ]
      }"
  '';

  passthru = {
    updateScript = gitUpdater { rev-prefix = "v"; };
    providedSessions = [ "miracle-wm" ];
    tests.vm = nixosTests.miracle-wm;
  };

  meta = {
    description = "Tiling Wayland compositor based on Mir";
    longDescription = ''
      miracle-wm is a Wayland compositor based on Mir. It features a tiling window manager at its core, very much in
      the style of i3 and sway. The intention is to build a compositor that is flashier and more feature-rich than
      either of those compositors, like swayfx.

      See the user guide for info on how to use miracle-wm: https://wiki.miracle-wm.org/v${finalAttrs.version}/
    '';
    homepage = "https://github.com/mattkae/miracle-wm";
    changelog = "https://github.com/miracle-wm-org/miracle-wm/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    mainProgram = "miracle-wm";
    maintainers = with lib.maintainers; [ OPNA2608 ];
    platforms = lib.platforms.linux;
  };
})

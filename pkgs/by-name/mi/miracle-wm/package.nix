{
  stdenv,
  lib,
  fetchFromGitHub,
  fetchpatch,
  gitUpdater,
  nixosTests,
  boost,
  cmake,
  coreutils,
  dbus,
  glib,
  glm,
  gtest,
  gtk4,
  gtk4-layer-shell,
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
  python3,
  systemd,
  wasmedge,
  wayland,
  wayland-scanner,
  wrapGAppsHook4,
  yaml-cpp,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "miracle-wm";
  version = "0.10.1";

  src = fetchFromGitHub {
    owner = "miracle-wm-org";
    repo = "miracle-wm";
    tag = "v${finalAttrs.version}";
    hash = "sha256-htFgvXYgxQXV2U3F+tXEoaTb0udc2H1aHsIg5E8nRL8=";
  };

  patches = [
    # Mir 2.29 compat, remove when version > 0.10.1
    (fetchpatch {
      name = "0001-miracle-wm-remove-legacy-mir-optional-usage.patch";
      url = "https://github.com/miracle-wm-org/miracle-wm/commit/a4d7b21e0d25667cd270d7ff52f8dccc2a217796.patch";
      hash = "sha256-XBbYSuXUOS9Gbs/LwxbbTAVsFuH8xLj8VhoCAjmCDfQ=";
    })
  ];

  # Mir 2.29 compat, remove when version > 0.10.1 (97a40cd8879898062b2cf7b5d1f5252ffc3b8dce is more than just a compat change)
  postPatch = ''
    substituteInPlace src/policy.{cpp,h} \
      --replace-fail 'handle_raise_window' 'handle_activate_window'
  ''
  + ''
    substituteInPlace CMakeLists.txt \
      --replace-fail 'DESTINATION lib' 'DESTINATION ''${CMAKE_INSTALL_LIBDIR}' \
      --replace-fail '-march=native' '# -march=native'
  '';

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    makeWrapper
    pkg-config
    wayland-scanner
    wrapGAppsHook4
  ];

  buildInputs = [
    boost
    glib
    glm
    gtk4
    gtk4-layer-shell
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
    (python3.withPackages (
      ps: with ps; [
        dbus-next
        tenacity
      ]
    ))
    wasmedge
    wayland
    yaml-cpp
  ];

  checkInputs = [ gtest ];

  # Manually wrapping the few binaries that needs it
  dontWrapGApps = true;

  cmakeFlags = [
    (lib.cmakeBool "BUILD_DEBUG_OVERLAY" true)
    (lib.cmakeBool "BUILD_ERROR_REPORTER" true)
    (lib.cmakeBool "ENABLE_LTO" true)
    (lib.cmakeBool "ENABLE_TESTS" finalAttrs.finalPackage.doCheck)
    (lib.cmakeBool "FEATURE_PLUGIN_SYSTEM" true)
    (lib.cmakeBool "SYSTEMD_INTEGRATION" true)
    (lib.cmakeBool "END_TO_END_TESTS" finalAttrs.finalPackage.doCheck)
  ];

  doCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;

  checkPhase = ''
    runHook preCheck

    export XDG_RUNTIME_DIR=$TMP

    ./tests/miracle-wm-tests

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

    wrapGApp $out/bin/miracle-wm-basic-error-reporter
    wrapGApp $out/bin/miracle-wm-debug-overlay
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
    homepage = "https://miracle-wm.org";
    changelog = "https://github.com/miracle-wm-org/miracle-wm/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    mainProgram = "miracle-wm";
    maintainers = with lib.maintainers; [ OPNA2608 ];
    platforms = lib.platforms.linux;
  };
})

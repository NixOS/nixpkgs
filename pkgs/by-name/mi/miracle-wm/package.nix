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
  yaml-cpp,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "miracle-wm";
  version = "0.9.1";

  src = fetchFromGitHub {
    owner = "miracle-wm-org";
    repo = "miracle-wm";
    tag = "v${finalAttrs.version}";
    hash = "sha256-7JtdSopKBHfFK0KsV0+9OxrOx3vrSydmZSmAiBvKQiI=";
  };

  patches = [
    (fetchpatch {
      name = "0001-miracle-wm-mir2.28.patch";
      url = "https://github.com/miracle-wm-org/miracle-wm/commit/0fcfb54c59327d0776f6e8074e885080731a95c4.patch";
      excludes = [
        ".github/workflows/test-deb-install.yml"
      ];
      hash = "sha256-HuXwPkM0whLFIy8HM6n9bG9I/DZOuzAajmDpJMZt9BQ=";
    })
  ];

  postPatch = ''
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

  cmakeFlags = [
    (lib.cmakeBool "ENABLE_LTO" true)
    (lib.cmakeBool "ENABLE_TESTS" finalAttrs.finalPackage.doCheck)
    # https://github.com/miracle-wm-org/miracle-wm/issues/865
    (lib.cmakeBool "FEATURE_PLUGIN_SYSTEM" false)
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

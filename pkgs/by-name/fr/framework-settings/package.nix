{
  callPackage,
  cmake,
  fetchFromGitHub,
  kdePackages,
  lib,
  nix-update-script,
  qt6,
  stdenv,

  withGui ? true,
  withKcm ? true,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "framework-settings";
  version = "1.0.0";
  dontWrapQtApps = !withGui;

  src = fetchFromGitHub {
    owner = "flamingspaz";
    repo = "framework-settings";
    tag = "v${finalAttrs.version}";
    hash = "sha256-HreJQwrk1g6KpA6NTeIEph6ijHNd3jqov1wV2Vb7uh8=";
  };

  __structuredAttrs = true;
  strictDeps = true;

  nativeBuildInputs = [
    cmake
  ]
  ++ (lib.optional withGui qt6.wrapQtAppsHook)
  ++ (lib.optional (withGui || withKcm) kdePackages.extra-cmake-modules);

  buildInputs =
    with qt6;
    [
      qtbase
      qtdeclarative
    ]
    ++ (lib.optionals (withGui || withKcm) (
      with kdePackages;
      [
        ki18n
      ]
    ))
    ++ (lib.optionals withGui (
      with kdePackages;
      [
        kirigami
      ]
    ))
    ++ (lib.optionals withKcm (
      with kdePackages;
      [
        kcoreaddons
        kcmutils
      ]
    ));

  cmakeFlags = [
    (lib.cmakeBool "BUILD_GUI" withGui)
    (lib.cmakeBool "BUILD_KCM" withKcm)
    (lib.cmakeBool "BUILD_DAEMON" false)
    (lib.cmakeFeature "DAEMON_PATH" (lib.getExe finalAttrs.passthru.daemon))
    (lib.cmakeBool "KDE_INSTALL_USE_QT_SYS_PATHS" true)
  ];

  passthru = {
    daemon = callPackage ./frameworkd.nix { inherit (finalAttrs) src version; };
    updateScript = nix-update-script {
      extraArgs = [
        "--subpackage"
        "daemon"
      ];
    };
  };

  meta = {
    description = "Framework Laptop settings GUI, KDE module, and system service";
    homepage = "https://github.com/flamingspaz/framework-settings";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
  }
  // lib.optionalAttrs withGui {
    mainProgram = "framework-settings";
  };
})

{
  stdenv,
  lib,
  fetchFromGitHub,
  fetchpatch,
  gitUpdater,
  libsForQt5,
  pkg-config,
  qt6Packages,
  rtaudio_6,
  rtmidi,
  withQt6 ? false,
}:

let
  qtPackages = if withQt6 then qt6Packages else libsForQt5;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "bambootracker" + lib.optionalString withQt6 "-qt6";
  version = "0.6.5";

  src = fetchFromGitHub {
    owner = "BambooTracker";
    repo = "BambooTracker";
    tag = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-WoyOqInOOOIEwsMOc2yoTdh9UhJOvFKE1GfkxOuXDe0=";
  };

  patches = [
    # Remove when version > 0.6.5
    (fetchpatch {
      name = "0001-bambootracker-Fix-compiler-warnings.patch";
      url = "https://github.com/BambooTracker/BambooTracker/commit/d670cf8b6113318cd938cf19be76b6b14d3635f1.patch";
      hash = "sha256-yyOMaOYKSc1hbbCL7wjFNPDmX2oMYo10J4hjZJss2zs=";
    })

    # Remove when version > 0.6.5
    (fetchpatch {
      name = "0002-bambootracker-Fix-GCC15-compat.patch";
      url = "https://github.com/BambooTracker/BambooTracker/commit/92c0a7d1cfb05d1c6ae9482181c5c378082b772c.patch";
      hash = "sha256-6K0RZD0LevggxFr92LaNmq+eMgOFJgFX60IgAw7tYdM=";
    })

    # Remove when version > 0.6.5
    (fetchpatch {
      name = "0003-bambootracker-Drop-unused-property.patch";
      url = "https://github.com/BambooTracker/BambooTracker/commit/de4459f0315f099d3e0a2d20b938ec76285f2d46.patch";
      hash = "sha256-zTh6i+hgQZ3kEid0IzQaR/PsrYlnhplccdlaS5g8FeA=";
    })
  ];

  postPatch = lib.optionalString withQt6 ''
    # Work around lrelease finding in qmake being broken by using pre-Qt5.12 code path
    # https://github.com/NixOS/nixpkgs/issues/214765
    substituteInPlace BambooTracker/lang/lang.pri \
      --replace 'equals(QT_MAJOR_VERSION, 5):lessThan(QT_MINOR_VERSION, 12)' 'if(true)'
  '';

  nativeBuildInputs = [
    pkg-config
  ]
  ++ (with qtPackages; [
    qmake
    qttools
    wrapQtAppsHook
  ]);

  buildInputs = [
    rtaudio_6
    rtmidi
  ]
  ++ (
    with qtPackages;
    [
      qtbase
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      qtwayland
    ]
    ++ lib.optionals withQt6 [
      qt5compat
    ]
  );

  qmakeFlags = [
    "CONFIG+=system_rtaudio"
    "CONFIG+=system_rtmidi"
  ]
  ++ lib.optionals stdenv.cc.isClang [
    # Clang is extra-strict about some deprecations
    # https://github.com/BambooTracker/BambooTracker/issues/506
    "CONFIG+=no_warnings_are_errors"
  ];

  postConfigure = "make qmake_all";

  # Wrapping the inside of the app bundles, avoiding double-wrapping
  dontWrapQtApps = stdenv.hostPlatform.isDarwin;

  postInstall = lib.optionalString stdenv.hostPlatform.isDarwin ''
    mkdir -p $out/Applications
    mv $out/{bin,Applications}/BambooTracker.app
    ln -s $out/{Applications/BambooTracker.app/Contents/MacOS,bin}/BambooTracker
    wrapQtApp $out/Applications/BambooTracker.app/Contents/MacOS/BambooTracker
  '';

  passthru = {
    updateScript = gitUpdater {
      rev-prefix = "v";
    };
  };

  meta = {
    description = "Tracker for YM2608 (OPNA) which was used in NEC PC-8801/9801 series computers";
    mainProgram = "BambooTracker";
    homepage = "https://bambootracker.github.io/BambooTracker/";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ OPNA2608 ];
  };
})

{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  wrapQtAppsHook,

  bluez,
  libnotify,
  libXdmcp,
  libXtst,
  opencv,
  qtbase,
  qtmultimedia,
  qtscript,
  qttools,
  qtx11extras,
  qtxmlpatterns,

  # Running with TTS support causes the program to freeze for a few seconds every time at startup,
  # so it is disabled by default
  textToSpeechSupport ? false,
  qtspeech,
}:

let
  # For some reason qtscript wants to use the same version of qtbase as itself
  # This override makes it think that they are the same version
  qtscript' = qtscript.overrideAttrs (oldAttrs: {
    inherit (qtbase) version;
    postPatch = ''
      substituteInPlace .qmake.conf \
          --replace-fail ${oldAttrs.version} ${qtbase.version}
    '';
  });
in
stdenv.mkDerivation (finalAttrs: {
  pname = "actiona";
  version = "3.10.2";

  src = fetchFromGitHub {
    owner = "Jmgr";
    repo = "actiona";
    rev = "v${finalAttrs.version}";
    hash = "sha256-4RKCNEniBBx0kDwdHVZOqXYeGCsH8g6SfVc8JdDV0hI=";
    fetchSubmodules = true;
  };

  patches =
    [
      # Sets the proper search location for the `.so` files and the translations
      ./fix-paths.patch
    ]
    ++ lib.optionals (!textToSpeechSupport) [
      # Removes TTS support
      ./disable-tts.patch
    ];

  postPatch = ''
    substituteInPlace gui/src/mainwindow.cpp executer/src/executer.cpp tools/src/languages.cpp \
        --subst-var out
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
    wrapQtAppsHook
  ];

  buildInputs = [
    bluez
    libnotify
    libXdmcp
    libXtst
    opencv
    qtbase
    qtmultimedia
    qtscript'
    qttools
    qtx11extras
    qtxmlpatterns
  ] ++ lib.optionals textToSpeechSupport [ qtspeech ];

  # RPATH of binary /nix/store/.../bin/... contains a forbidden reference to /build/
  cmakeFlags = [ (lib.cmakeBool "CMAKE_SKIP_BUILD_RPATH" true) ];

  # udev is used by the system-actionpack
  env.NIX_LDFLAGS = "-ludev";

  installPhase = ''
    runHook preInstall

    install -Dm755 {execution,actiontools,tools}/*.so -t $out/lib
    install -Dm755 actions/actionpack*.so -t $out/lib/actions
    install -Dm755 actiona actexec -t $out/bin
    install -Dm644 translations/*.qm -t $out/share/actiona/translations
    install -Dm644 $src/actiona.desktop -t $out/share/applications
    install -Dm644 $src/gui/icons/actiona.png -t $out/share/icons/hicolor/48x48/apps

    runHook postInstall
  '';

  meta = {
    description = "A cross-platform automation tool";
    homepage = "https://github.com/Jmgr/actiona";
    license = lib.licenses.gpl3Only;
    mainProgram = "actiona";
    maintainers = with lib.maintainers; [ tomasajt ];
    platforms = lib.platforms.linux;
  };
})

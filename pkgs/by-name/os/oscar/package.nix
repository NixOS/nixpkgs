{
  lib,
  stdenv,
  fetchFromGitLab,
  libGLU,
  nix-update-script,
  qt6,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "oscar";
  version = "2.0.1";

  src = fetchFromGitLab {
    owner = "CrimsonNape";
    repo = "oscar-sql";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ivOEAP7/pc5yS6mhc/6ButbSjfFmOP4PM7c/S23oyYw=";
  };

  nativeBuildInputs = [
    qt6.qmake
    qt6.qtserialport
    qt6.qttools
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    libGLU
    qt6.qtbase
    qt6.qtserialport
  ];

  strictDeps = true;
  __structuredAttrs = true;

  postPatch = ''
    substituteInPlace oscar/oscar.pro \
      --replace-fail "/bin/bash" "${stdenv.shell}" \
      --replace-fail "\$\$[QT_INSTALL_BINS]/lrelease" "lrelease"
    substituteInPlace oscar/SleepLib/common.cpp \
      --replace-fail 'QString( "/usr/share/" )' 'QString( "${placeholder "out"}/share/" )'
    substituteInPlace Building/Linux/OSCAR20.desktop \
      --replace-fail "Icon=/usr/share/icons/hicolor/48x48/apps/OSCAR20.png" "Icon=OSCAR20"
  '';

  qmakeFlags = [ "OSCAR_QT.pro" ];

  installPhase = ''
    runHook preInstall
    install -Dm755 oscar/OSCAR20 -t "$out/bin"
    # help browser was removed 'temporarily' in https://gitlab.com/pholy/OSCAR-code/-/commit/57c3e4c33ccdd2d0eddedbc24c0e4f2969da3841
    # install -Dm644 oscar/Help/* -t "$out/share/OSCAR20/Help"
    install -Dm644 oscar/Html/* -t "$out/share/OSCAR20/Html"
    install -Dm644 oscar/Translations/* -t "$out/share/OSCAR20/Translations"
    install -Dm644 Building/Linux/OSCAR20.png -t "$out/share/icons/hicolor/48x48/apps"
    install -Dm644 Building/Linux/OSCAR20.svg -t "$out/share/icons/hicolor/scalable/apps"
    install -Dm644 Building/Linux/OSCAR20.desktop -t "$out/share/applications"
    runHook postInstall
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "^v([0-9.]+)$"
    ];
  };

  meta = {
    homepage = "https://www.sleepfiles.com/OSCAR/";
    changelog = "https://gitlab.com/CrimsonNape/oscar-sql/-/raw/${finalAttrs.src.tag}/Htmldocs/release_notes.html";
    description = "Software for reviewing and exploring data produced by CPAP and related machines used in the treatment of sleep apnea";
    mainProgram = "OSCAR20";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      roconnor
      ilkecan
    ];
    # Someone needs to create a suitable installPhase for Darwin and Windows.
    # See https://gitlab.com/pholy/OSCAR-code/-/tree/master/Building.
    platforms = lib.platforms.linux;
  };
})

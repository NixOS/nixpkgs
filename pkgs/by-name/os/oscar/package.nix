{
  lib,
  stdenv,
  qt6,
  fetchFromGitLab,
  libGLU,
  nix-update-script,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "oscar";
  version = "2.0.1";

  src = fetchFromGitLab {
    owner = "CrimsonNape";
    repo = "oscar-sql";
    rev = "v${finalAttrs.version}";
    hash = "sha256-ivOEAP7/pc5yS6mhc/6ButbSjfFmOP4PM7c/S23oyYw=";
  };

  buildInputs = [
    qt6.qtbase
    qt6.qttools
    libGLU
  ];
  nativeBuildInputs = [
    qt6.wrapQtAppsHook
    qt6.qmake
    qt6.qtserialport
  ];

  strictDeps = true;
  __structuredAttrs = true;

  postPatch = ''
    substituteInPlace oscar/oscar.pro \
      --replace-fail "/bin/bash" "${stdenv.shell}" \
      --replace-fail "\$\$[QT_INSTALL_BINS]/lrelease" "${qt6.qttools}/bin/lrelease"
  '';

  qmakeFlags = [ "OSCAR_QT.pro" ];

  installPhase = ''
    runHook preInstall
    install -D oscar/OSCAR20 -t $out/bin
    # help browser was removed 'temporarily' in https://gitlab.com/pholy/OSCAR-code/-/commit/57c3e4c33ccdd2d0eddedbc24c0e4f2969da3841
    # install -D oscar/Help/* -t $out/share/OSCAR/Help
    install -D oscar/Html/* -t $out/share/OSCAR/Html
    install -D oscar/Translations/* -t $out/share/OSCAR/Translations
    install -D Building/Linux/OSCAR.png -t $out/share/icons/hicolor/48x48/apps
    install -D Building/Linux/OSCAR.svg -t $out/share/icons/hicolor/scalable/apps
    install -D Building/Linux/OSCAR.desktop -t $out/share/applications
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
    description = "Software for reviewing and exploring data produced by CPAP and related machines used in the treatment of sleep apnea";
    mainProgram = "OSCAR";
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

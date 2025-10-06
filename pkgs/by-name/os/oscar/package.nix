{
  lib,
  stdenv,
  qt5,
  fetchFromGitLab,
  libGLU,
  nix-update-script,
}:
stdenv.mkDerivation rec {
  pname = "oscar";
  version = "1.6.1";

  src = fetchFromGitLab {
    owner = "CrimsonNape";
    repo = "OSCAR-code";
    rev = "v${version}";
    hash = "sha256-idooSDmozMtf0akhbaQP1aBIv6Ae9UMhMmN1P48u7FE=";
  };

  buildInputs = [
    qt5.qtbase
    qt5.qttools
    qt5.qtserialport
    libGLU
  ];
  nativeBuildInputs = [
    qt5.wrapQtAppsHook
    qt5.qmake
  ];
  postPatch = ''
    substituteInPlace oscar/oscar.pro --replace "/bin/bash" "${stdenv.shell}"
  '';

  qmakeFlags = [ "OSCAR_QT.pro" ];

  installPhase = ''
    runHook preInstall
    install -d $out/bin
    install -d $out/share/OSCAR/Help
    install -d $out/share/OSCAR/Html
    install -d $out/share/OSCAR/Translations
    install -d $out/share/icons/OSCAR
    install -d $out/share/applications
    install -T oscar/OSCAR $out/bin/OSCAR
    # help browser was removed 'temporarily' in https://gitlab.com/pholy/OSCAR-code/-/commit/57c3e4c33ccdd2d0eddedbc24c0e4f2969da3841
    # install oscar/Help/* $out/share/OSCAR/Help
    install oscar/Html/* $out/share/OSCAR/Html
    install oscar/Translations/* $out/share/OSCAR/Translations
    install -T Building/Linux/OSCAR.png $out/share/icons/OSCAR/OSCAR.png
    install -T Building/Linux/OSCAR.desktop $out/share/applications/OSCAR.desktop
    runHook postInstall
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "^v([0-9.]+)$"
    ];
  };

  meta = with lib; {
    homepage = "https://www.sleepfiles.com/OSCAR/";
    description = "Software for reviewing and exploring data produced by CPAP and related machines used in the treatment of sleep apnea";
    mainProgram = "OSCAR";
    license = licenses.gpl3Only;
    maintainers = [ maintainers.roconnor ];
    # Someone needs to create a suitable installPhase for Darwin and Windows.
    # See https://gitlab.com/pholy/OSCAR-code/-/tree/master/Building.
    platforms = platforms.linux;
  };
}

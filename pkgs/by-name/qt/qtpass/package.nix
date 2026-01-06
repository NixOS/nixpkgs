{
  stdenv,
  fetchFromGitHub,
  lib,
  libsForQt5,
  git,
  gnupg,
  pass,
  pwgen,
  qrencode,
  makeWrapper,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "qtpass";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "IJHack";
    repo = "QtPass";
    tag = "v${finalAttrs.version}";
    hash = "sha256-oKLLmsuXD2Hb2LQ4tcJP2gpR6eLaM/JzDhRcRSpUPYI=";
  };

  postPatch = ''
    substituteInPlace src/qtpass.cpp \
      --replace "/usr/bin/qrencode" "${qrencode}/bin/qrencode"
  '';

  buildInputs = [
    git
    gnupg
    pass
    libsForQt5.qtbase
    libsForQt5.qtsvg
  ];

  nativeBuildInputs = [
    libsForQt5.qmake
    libsForQt5.qttools
    libsForQt5.wrapQtAppsHook
    makeWrapper
  ];

  qmakeFlags = [
    # setup hook only sets QMAKE_LRELEASE, set QMAKE_LUPDATE too:
    "QMAKE_LUPDATE=${libsForQt5.qttools.dev}/bin/lupdate"
  ];

  qtWrapperArgs = [
    "--suffix PATH : ${
      lib.makeBinPath [
        git
        gnupg
        pass
        pwgen
      ]
    }"
  ];

  installPhase = lib.optionalString stdenv.hostPlatform.isDarwin ''
    runHook preInstall
    mkdir -p $out/Applications
    cp -r main/QtPass.app $out/Applications
    makeWrapper $out/Applications/QtPass.app/Contents/MacOS/QtPass $out/bin/qtpass
    runHook postInstall
  '';

  postInstall = ''
    install -D qtpass.desktop -t $out/share/applications
    install -D artwork/icon.svg $out/share/icons/hicolor/scalable/apps/qtpass-icon.svg
    install -D qtpass.1 -t $out/share/man/man1
  '';

  meta = {
    description = "Multi-platform GUI for pass, the standard unix password manager";
    mainProgram = "qtpass";
    homepage = "https://qtpass.org";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.all;
  };
})

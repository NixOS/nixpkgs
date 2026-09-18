{
  stdenv,
  fetchFromGitHub,
  lib,
  qt6Packages,
  git,
  gnupg,
  pass,
  pwgen,
  qrencode,
  makeWrapper,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "qtpass";
  version = "1.8.1";

  src = fetchFromGitHub {
    owner = "IJHack";
    repo = "QtPass";
    tag = "v${finalAttrs.version}";
    hash = "sha256-FDqRM7wMyxWBHWg5LYIlXoL4RAtx3wK45IIXn0Z4zXM=";
  };

  postPatch = ''
    substituteInPlace src/qtpass.cpp \
      --replace-fail "/usr/bin/qrencode" "${qrencode}/bin/qrencode"
  '';

  buildInputs = [
    git
    gnupg
    pass
    qt6Packages.qtbase
    qt6Packages.qtsvg
  ];

  nativeBuildInputs = [
    makeWrapper
  ]
  ++ (with qt6Packages; [
    qmake
    qttools
    wrapQtAppsHook
  ]);

  qmakeFlags = [
    # qtpass.pri expects lrelease/lupdate next to qmake ($$[QT_INSTALL_BINS]);
    # in nixpkgs they live in qttools, and the build runs both.
    "QMAKE_LRELEASE=${lib.getDev qt6Packages.qttools}/bin/lrelease"
    "QMAKE_LUPDATE=${lib.getDev qt6Packages.qttools}/bin/lupdate"
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

  # main.pro installs the binary, desktop file, metainfo and icons since
  # 1.8.0; the man page is the one thing it leaves out.
  postInstall = ''
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

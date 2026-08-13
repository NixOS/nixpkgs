{
  lib,
  stdenv,
  fetchFromGitHub,
  libx11,
  libxtst,
  cmake,
  openssl,
  libscrypt,
  testers,
  qt6,
  x11Support ? true,
  waylandSupport ? false,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "qmasterpassword";
  version = "2.0.3";

  src = fetchFromGitHub {
    owner = "bkueng";
    repo = "qMasterPassword";
    rev = "v${finalAttrs.version}";
    hash = "sha256-kNVdE42JFzl6HO84b793gseMhcDyiGzQCmhh6zh2epc=";
  };

  buildInputs = [
    qt6.qtbase
    qt6.qtwayland
    openssl
    libscrypt
  ]
  ++ lib.optionals x11Support [
    libx11
    libxtst
  ];
  nativeBuildInputs = [
    cmake
    qt6.qttools
    qt6.wrapQtAppsHook
  ];
  cmakeFlags = lib.optionals waylandSupport [
    "-DDISABLE_FILL_FORM_SHORTCUTS=1"
  ];

  # Upstream install is mostly defunct. It hardcodes target.path and doesn't
  # install anything but the binary.
  installPhase =
    if stdenv.hostPlatform.isDarwin then
      ''
        mkdir -p "$out"/{Applications,bin}
        mv qMasterPassword.app "$out"/Applications/
        ln -s ../Applications/qMasterPassword.app/Contents/MacOS/qMasterPassword "$out"/bin/qMasterPassword
      ''
    else
      ''
        mkdir -p $out/bin
        mkdir -p $out/share/{applications,doc/qMasterPassword,icons/qmasterpassword,icons/hicolor/512x512/apps,qMasterPassword/translations}
        cp qMasterPassword $out/bin
        cp $src/data/qMasterPassword.desktop $out/share/applications
        cp $src/LICENSE $src/README.md $out/share/doc/qMasterPassword
        cp $src/data/icons/app_icon.png $out/share/icons/hicolor/512x512/apps/qmasterpassword.png
        cp $src/data/icons/* $out/share/icons/qmasterpassword
        cp ./translations/translation_de.qm $out/share/qMasterPassword/translations/translation_de.qm
        cp ./translations/translation_pl.qm $out/share/qMasterPassword/translations/translation_pl.qm
      '';

  passthru = {
    tests.version = testers.testVersion {
      package = finalAttrs.finalPackage;
      version = "v${finalAttrs.version}";
    };
  };

  meta = {
    description = "Stateless Master Password Manager";
    mainProgram = "qMasterPassword";
    longDescription = ''
      Access all your passwords using only a single master password. But in
      contrast to other managers it does not store any passwords: Unique
      passwords are generated from the master password and a site name. This
      means you automatically get different passwords for each account and
      there is no password file that can be lost or get stolen. There is also
      no need to trust any online password service.
    '';
    homepage = "https://github.com/bkueng/qMasterPassword";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ teutat3s ];
    platforms = lib.platforms.all;
  };
})

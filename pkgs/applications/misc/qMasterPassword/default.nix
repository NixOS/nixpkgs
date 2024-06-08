{ lib
, stdenv
, fetchFromGitHub
, libX11
, libXtst
, cmake
, qtbase
, qttools
, qtwayland
, openssl
, libscrypt
, wrapQtAppsHook
, testers
, qMasterPassword
, x11Support ? true
, waylandSupport ? false
}:

stdenv.mkDerivation rec {
  pname = "qMasterPassword";
  version = "2.0";

  src = fetchFromGitHub {
    owner = "bkueng";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-4qxPjrf6r2S0l/hcs6bqfJm56jdDz+0a0xEkqGBYGBs=";
  };

  buildInputs = [ qtbase qtwayland openssl libscrypt ] ++ lib.optionals x11Support [ libX11 libXtst ];
  nativeBuildInputs = [ cmake qttools wrapQtAppsHook ];
  cmakeFlags = lib.optionals waylandSupport [
    "-DDISABLE_FILL_FORM_SHORTCUTS=1"
  ];

  # Upstream install is mostly defunct. It hardcodes target.path and doesn't
  # install anything but the binary.
  installPhase = if stdenv.isDarwin then ''
    mkdir -p "$out"/{Applications,bin}
    mv qMasterPassword.app "$out"/Applications/
    ln -s ../Applications/qMasterPassword.app/Contents/MacOS/qMasterPassword "$out"/bin/qMasterPassword
  '' else ''
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
      package = qMasterPassword;
      version = "v${version}";
    };
  };

  meta = with lib; {
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
    license = licenses.gpl3;
    maintainers = with lib.maintainers; [ tadeokondrak teutat3s ];
    platforms = platforms.all;
  };
}

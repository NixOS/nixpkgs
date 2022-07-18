{ lib, stdenv, mkDerivation, fetchFromGitHub, qtbase, qmake, qttools, libX11, libXtst, openssl, libscrypt }:

mkDerivation rec {
  pname = "qMasterPassword";
  version = "1.2.3";

  src = fetchFromGitHub {
    owner = "bkueng";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-eUJD9FoGaDzADKm3wZHs5Bhdt7RoM1WTTVNP6xUV7gs=";
  };

  buildInputs = [ qtbase libX11 libXtst openssl libscrypt ];
  nativeBuildInputs = [ qmake qttools ];

  # Upstream install is mostly defunct. It hardcodes target.path and doesn't
  # install anything but the binary.
  installPhase = if stdenv.isDarwin then ''
    mkdir -p "$out"/{Applications,bin}
    mv qMasterPassword.app "$out"/Applications/
    ln -s ../Applications/qMasterPassword.app/Contents/MacOS/qMasterPassword "$out"/bin/qMasterPassword
  '' else ''
    mkdir -p $out/bin
    mkdir -p $out/share/{applications,doc/qMasterPassword,icons/qmasterpassword,icons/hicolor/512x512/apps,qMasterPassword/translations}
    mv qMasterPassword $out/bin
    mv data/qMasterPassword.desktop $out/share/applications
    mv LICENSE README.md $out/share/doc/qMasterPassword
    mv data/icons/app_icon.png $out/share/icons/hicolor/512x512/apps/qmasterpassword.png
    mv data/icons/* $out/share/icons/qmasterpassword
    lrelease ./data/translations/translation_de.ts
    lrelease ./data/translations/translation_pl.ts
    mv ./data/translations/translation_de.qm $out/share/qMasterPassword/translations/translation_de.qm
    mv ./data/translations/translation_pl.qm $out/share/qMasterPassword/translations/translation_pl.qm
  '';

  meta = with lib; {
    description = "Stateless Master Password Manager";
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
    maintainers = [ maintainers.tadeokondrak ];
    platforms = platforms.all;
  };
}

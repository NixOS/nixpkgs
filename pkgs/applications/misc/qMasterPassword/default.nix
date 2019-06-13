{ stdenv, fetchFromGitHub, qtbase, qmake, libX11, libXtst, openssl, libscrypt }:

stdenv.mkDerivation rec {
  name = "qMasterPassword";
  version = "1.2.2";

  src = fetchFromGitHub {
    owner = "bkueng";
    repo = name;
    rev = "v${version}";
    sha256 = "0l0jarvfdc69rcjl2wa0ixq8gp3fmjsy9n84m38sxf3n9j2bh13c";
  };

  buildInputs = [ qtbase libX11 libXtst openssl libscrypt ];
  nativeBuildInputs = [ qmake ];

  # Upstream install is mostly defunct. It hardcodes target.path and doesn't
  # install anything but the binary.
  installPhase = if stdenv.isDarwin then ''
    mkdir -p "$out"/{Applications,bin}
    mv qMasterPassword.app "$out"/Applications/
    ln -s ../Applications/qMasterPassword.app/Contents/MacOS/qMasterPassword "$out"/bin/qMasterPassword
  '' else ''
    mkdir -p $out/bin
    mkdir -p $out/share/{applications,doc/qMasterPassword,icons/qmasterpassword,icons/hicolor/512x512/apps}
    mv qMasterPassword $out/bin
    mv data/qMasterPassword.desktop $out/share/applications
    mv LICENSE README.md $out/share/doc/qMasterPassword
    mv data/icons/app_icon.png $out/share/icons/hicolor/512x512/apps/qmasterpassword.png
    mv data/icons/* $out/share/icons/qmasterpassword
  '';

  meta = with stdenv.lib; {
    description = "Stateless Master Password Manager";
    longDescription = ''
      Access all your passwords using only a single master password. But in
      contrast to other managers it does not store any passwords: Unique
      passwords are generated from the master password and a site name. This
      means you automatically get different passwords for each account and
      there is no password file that can be lost or get stolen. There is also
      no need to trust any online password service.
    '';
    homepage = https://github.com/bkueng/qMasterPassword;
    license = licenses.gpl3;
    maintainers = [ maintainers.tadeokondrak ];
    platforms = platforms.all;
  };
}

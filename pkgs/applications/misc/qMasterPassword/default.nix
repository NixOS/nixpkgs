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

  installPhase = ''
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
      homepage = https://github.com/bkueng/qMasterPassword;
      license = licenses.gpl3;
      maintainers = [ maintainers.tadeokondrak ];
      platforms = platforms.all;
  };
}

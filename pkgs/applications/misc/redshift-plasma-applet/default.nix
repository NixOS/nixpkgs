{ stdenv, cmake, plasma-framework, redshift, fetchFromGitHub, }:

let version = "1.0.17"; in

stdenv.mkDerivation {
  name = "redshift-plasma-applet-${version}";

  src = fetchFromGitHub {
    owner = "kotelnik";
    repo = "plasma-applet-redshift-control";
    rev = "v${version}";
    sha256 = "1lp1rb7i6c18lrgqxsglbvyvzh71qbm591abrbhw675ii0ca9hgj";
  };

  patchPhase = ''
    substituteInPlace package/contents/ui/main.qml \
      --replace "redshiftCommand: 'redshift'" \
                "redshiftCommand: '${redshift}/bin/redshift'" \
      --replace "redshiftOneTimeCommand: 'redshift -O " \
                "redshiftOneTimeCommand: '${redshift}/bin/redshift -O "

    substituteInPlace package/contents/ui/config/ConfigAdvanced.qml \
      --replace "'redshift -V'" \
                "'${redshift}/bin/redshift -V'"
  '';

  buildInputs = [
    cmake
    plasma-framework
  ];


  meta = with stdenv.lib; {
    description = "KDE Plasma 5 widget for controlling Redshift";
    homepage = https://github.com/kotelnik/plasma-applet-redshift-control;
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ benley ];
  };
}

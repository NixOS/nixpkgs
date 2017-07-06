{ stdenv, cmake, extra-cmake-modules, plasma-framework, redshift, fetchFromGitHub, }:

let version = "1.0.18"; in

stdenv.mkDerivation {
  name = "redshift-plasma-applet-${version}";

  src = fetchFromGitHub {
    owner = "kotelnik";
    repo = "plasma-applet-redshift-control";
    rev = "v${version}";
    sha256 = "122nnbafa596rxdxlfshxk45lzch8c9342bzj7kzrsjkjg0xr9pq";
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

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
  ];

  buildInputs = [ plasma-framework ];

  meta = with stdenv.lib; {
    description = "KDE Plasma 5 widget for controlling Redshift";
    homepage = https://github.com/kotelnik/plasma-applet-redshift-control;
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ benley zraexy ];
  };
}

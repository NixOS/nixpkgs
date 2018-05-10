{ stdenv, fetchFromGitHub, pkgconfig, vte, gtk }:

stdenv.mkDerivation rec {
  name = "stupidterm-2018-03-10";

  nativeBuildInputs = [ pkgconfig ];

  buildInputs = [ vte gtk ];

  src = fetchFromGitHub {
    owner = "esmil";
    repo = "stupidterm";
    rev = "0463519a96c9e4f9ce9fdc99d8e776499346ccba";
    sha256 = "1vbk53xyjn33myb3fix6y7sxb1x3rndrkk5l9qa60qaw2ivkr965";
  };

  makeFlags = "PKGCONFIG=${pkgconfig}/bin/pkg-config binary=stupidterm";

  installPhase = ''
    mkdir -p $out/bin $out/share/applications $out/share/stupidterm
    cp stupidterm $out/bin
    substituteAll ${./stupidterm.desktop} $out/share/applications/stupidterm.desktop
    substituteAll stupidterm.ini $out/share/stupidterm/stupidterm.ini
  '';

  meta = with stdenv.lib; {
    description = "Simple wrapper around the VTE terminal emulator widget for GTK+";
    longDescription = ''
      Simple wrapper around the VTE terminal emulator widget for GTK+
    '';
    homepage = https://github.com/esmil/stupidterm;
    license = licenses.lgpl3Plus;
    maintainers = [ maintainers.etu ];
    platforms = platforms.linux;
  };
}

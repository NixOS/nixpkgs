{ stdenv, fetchFromGitHub, pkgconfig, vte, gtk }:

stdenv.mkDerivation rec {
  name = "stupidterm-2018-09-25";

  nativeBuildInputs = [ pkgconfig ];

  buildInputs = [ vte gtk ];

  src = fetchFromGitHub {
    owner = "esmil";
    repo = "stupidterm";
    rev = "d1bc020797330df83d427e361d3620e346a4e792";
    sha256 = "1yh2vhq3d0qbh0dh2h9yc7s9gkffgkb987vvwz2bdnvlskrjmmdj";
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

{ stdenv, fetchFromGitHub, pkgconfig, vte, gtk }:

stdenv.mkDerivation rec {
  name = "stupidterm-20170315-752316a";

  buildInputs = [ pkgconfig vte gtk ];

  src = fetchFromGitHub {
    owner = "esmil";
    repo = "stupidterm";
    rev = "752316a783f52317ffd9f05d32e208dbcafc5ba6";
    sha256 = "1d8fyhr9sgpxgkwzkyiws0kvhmqfwwyycvcr1qf2wjldiax222lv";
  };

  preBuild = ''
    makeFlags="PKGCONFIG=${pkgconfig}/bin/pkg-config binary=stupidterm"
  '';

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

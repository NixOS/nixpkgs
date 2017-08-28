{ stdenv, fetchFromGitHub, pkgconfig, libnotify, gdk_pixbuf }:

stdenv.mkDerivation rec {
  name = "et-${version}";
  version = "2017-03-04";

  src = fetchFromGitHub {
    owner = "geistesk";
    repo = "et";
    rev = "151e9b6bc0d2d4f45bda8ced740ee99d0f2012f6";
    sha256 = "1a1jdnzmal05k506bbvzlwsj2f3kql6l5xc1gdabm79y6vaf4r7s";
  };

  buildInputs = [ libnotify gdk_pixbuf ];
  nativeBuildInputs = [ pkgconfig ];

  installPhase = ''
    mkdir -p $out/bin
    cp et $out/bin
    cp et-status.sh $out/bin/et-status
  '';

  meta = with stdenv.lib; {
    description = "Minimal libnotify-based (egg) timer for GNU/Linux";
    homepage = https://github.com/geistesk/et;
    license = licenses.gpl3;
    platforms = platforms.unix;
    maintainers = with maintainers; [ geistesk ];
  };
}

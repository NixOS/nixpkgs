{ stdenv, fetchFromGitHub, pkgconfig, libnotify, gdk_pixbuf }:

stdenv.mkDerivation rec {
  name = "et-${version}";
  version = "0.1";

  src = fetchFromGitHub {
    owner = "geistesk";
    repo = "et";
    rev = "${version}";
    sha256 = "1d2hq6p1y2ynk0a3l35lwbm1fcl9kg7rpjcin8bx4xcdpbw42y94";
  };

  buildInputs = [ libnotify gdk_pixbuf ];
  nativeBuildInputs = [ pkgconfig ];

  installPhase = ''
    mkdir -p $out/bin
    cp et $out/bin
    cp et-status.sh $out/bin/et-status
  '';

  meta = with stdenv.lib; {
    description = "Minimal libnotify-based (egg) timer";
    homepage = https://github.com/geistesk/et;
    license = licenses.gpl3;
    platforms = platforms.unix;
    maintainers = with maintainers; [ geistesk ];
  };
}

{ stdenv, fetchFromGitHub, pkgconfig, libnotify, gdk-pixbuf }:

stdenv.mkDerivation rec {
  pname = "et";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "geistesk";
    repo = "et";
    rev = "${version}";
    sha256 = "167w9qwfpd63rgy0xmkkkh5krmd91q42c3ijy3j099krgdfbb9bc";
  };

  buildInputs = [ libnotify gdk-pixbuf ];
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

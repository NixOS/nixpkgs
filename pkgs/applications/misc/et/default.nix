{ stdenv, fetchFromGitHub, pkgconfig, libnotify, gdk-pixbuf }:

stdenv.mkDerivation rec {
  pname = "et";
  version = "0.1.2";

  src = fetchFromGitHub {
    owner = "geistesk";
    repo = "et";
    rev = version;
    sha256 = "0i0lgmnly8n7y4y6pb10pxgxyz8s5zk26k8z1g1578v1wan01lnq";
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
    homepage = "https://github.com/geistesk/et";
    license = licenses.gpl3;
    platforms = platforms.unix;
    maintainers = with maintainers; [ geistesk ];
  };
}

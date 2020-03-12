{ stdenv, fetchFromGitHub, pkgconfig, gobject-introspection, mpv }:

stdenv.mkDerivation rec {
  name = "mpv-mpris-${version}.so";
  version = "0.3";

  src = fetchFromGitHub {
    owner = "hoyon";
    repo = "mpv-mpris";
    rev = version;
    sha256 = "02lqsgp296s8wr0yh6wm8h7nhn53rj254zahpzbwdv15apgy0z17";
  };

  nativeBuildInputs = [ pkgconfig ];

  buildInputs = [ gobject-introspection mpv ];

  installPhase = ''
    cp mpris.so $out
  '';

  meta = with stdenv.lib; {
    description = "MPRIS plugin for mpv";
    homepage = https://github.com/hoyon/mpv-mpris;
    license = licenses.mit;
    maintainers = with maintainers; [ jfrankenau ];
  };
}

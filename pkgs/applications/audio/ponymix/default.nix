{ stdenv, fetchurl, libpulseaudio, libnotify, pkgconfig }:

stdenv.mkDerivation rec {
  name = "ponymix-${version}";
  version = "4";
  src = fetchurl {
    url = "http://code.falconindy.com/archive/ponymix/${name}.tar.xz";
    sha256 = "008pk3sqc8955k2f502z1syzv43a4q0yk5ws69lgpqfsy1mzki2d";
  };

  buildInputs = [ libpulseaudio libnotify ];
  nativeBuildInputs = [ pkgconfig ];

  postPatch = ''substituteInPlace Makefile --replace "\$(DESTDIR)/usr" "$out"'';

  meta = {
    description = "CLI PulseAudio Volume Control";
    homepage = "http://github.com/falconindy/ponymix";
    license = "mit";
  };
}

{ stdenv, fetchurl, libpulseaudio, libnotify, pkgconfig }:

stdenv.mkDerivation rec {
  name = "ponymix-${version}";
  version = "5";
  src = fetchurl {
    url = "http://code.falconindy.com/archive/ponymix/${name}.tar.xz";
    sha256 = "0qn2kms9h9b7da2xzkdgzrykhhdywr4psxnz03j8rg7wa9nwfw0x";
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

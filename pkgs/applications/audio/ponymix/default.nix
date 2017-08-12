{ stdenv, fetchFromGitHub, libpulseaudio, libnotify, pkgconfig }:

stdenv.mkDerivation rec {
  name = "ponymix-${version}";
  version = "5";

  src = fetchFromGitHub {
    owner  = "falconindy";
    repo   = "ponymix";
    rev    = version;
    sha256 = "08yp7fprmzm6px5yx2rvzri0l60bra5h59l26pn0k071a37ks1rb";
  };

  buildInputs = [ libpulseaudio libnotify ];
  nativeBuildInputs = [ pkgconfig ];

  postPatch = ''substituteInPlace Makefile --replace "\$(DESTDIR)/usr" "$out"'';

  meta = with stdenv.lib; {
    description = "CLI PulseAudio Volume Control";
    homepage = http://github.com/falconindy/ponymix;
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ ericsagnes ];
  };
}

{ stdenv, fetchFromGitHub, makeWrapper, SDL, alsaLib, autoreconfHook, gtk2, libjack2, ladspaH
, ladspaPlugins, libsamplerate, libsndfile, pkgconfig, libpulseaudio, lame
, vorbis-tools }:

stdenv.mkDerivation rec {
  name = "mhwaveedit-${version}";
  version = "1.4.24";

  src = fetchFromGitHub {
    owner = "magnush";
    repo = "mhwaveedit";
    rev = "v${version}";
    sha256 = "037pbq23kh8hsih994x2sv483imglwcrqrx6m8visq9c46fi0j1y";
  };

  nativeBuildInputs = [ autoreconfHook makeWrapper pkgconfig ];

  preAutoreconf = "(cd docgen && sh gendocs.sh)";

  buildInputs = [
    SDL alsaLib gtk2 libjack2 ladspaH libsamplerate libsndfile libpulseaudio
  ];

  configureFlags = [ "--with-default-ladspa-path=${ladspaPlugins}/lib/ladspa" ];

  postInstall = ''
    wrapProgram $out/bin/mhwaveedit \
      --prefix PATH : ${lame}/bin/ \
      --prefix PATH : ${vorbis-tools}/bin/
  '';

  meta = with stdenv.lib; {
    description = "Graphical program for editing, playing and recording sound files";
    homepage = https://github.com/magnush/mhwaveedit;
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.goibhniu ];
  };
}

{ stdenv, fetchurl, makeWrapper, SDL , alsaLib, gtk, libjack2, ladspaH
, ladspaPlugins, libsamplerate, libsndfile, pkgconfig, libpulseaudio, lame
, vorbis-tools }:

stdenv.mkDerivation  rec {
  name = "mhwaveedit-${version}";
  version = "1.4.23";

  src = fetchurl {
    url = "http://download.gna.org/mhwaveedit/${name}.tar.bz2";
    sha256 = "010rk4mr631s440q9cfgdxx2avgzysr9aq52diwdlbq9cddifli3";
  };

  buildInputs = [ SDL alsaLib gtk libjack2 ladspaH libsamplerate libsndfile
     pkgconfig libpulseaudio makeWrapper ];

  configureFlags = "--with-default-ladspa-path=${ladspaPlugins}/lib/ladspa";

  postInstall = ''
    wrapProgram $out/bin/mhwaveedit \
      --prefix PATH : ${lame}/bin/ \
      --prefix PATH : ${vorbis-tools}/bin/
  '';

  meta = with stdenv.lib; {
    description = "Graphical program for editing, playing and recording sound files";
    homepage = https://gna.org/projects/mhwaveedit;
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.goibhniu ];
  };
}

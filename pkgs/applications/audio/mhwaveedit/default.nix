{ stdenv, fetchurl, makeWrapper, SDL, alsaLib, autoreconfHook, gtk2, libjack2, ladspaH
, ladspaPlugins, libsamplerate, libsndfile, pkgconfig, libpulseaudio, lame
, vorbis-tools }:

stdenv.mkDerivation  rec {
  name = "mhwaveedit-${version}";
  version = "1.4.23";

  src = fetchurl {
    url = "https://github.com/magnush/mhwaveedit/archive/v${version}.tar.gz";
    sha256 = "1lvd54d8kpxwl4gihhznx1b5skhibz4vfxi9k2kwqg808jfgz37l";
  };

  nativeBuildInputs = [ autoreconfHook ];

  preAutoreconf = "(cd docgen && sh gendocs.sh)";

  buildInputs = [
     SDL alsaLib gtk2 libjack2 ladspaH libsamplerate libsndfile
     pkgconfig libpulseaudio makeWrapper
  ];

  configureFlags = [ "--with-default-ladspa-path=${ladspaPlugins}/lib/ladspa" ];

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

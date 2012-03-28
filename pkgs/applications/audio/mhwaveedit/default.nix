{ stdenv, fetchurl, SDL , alsaLib, gtk, jackaudio, ladspaH
, ladspaPlugins, libsamplerate, libsndfile, pkgconfig, pulseaudio }:

stdenv.mkDerivation  rec {
  name = "mhwaveedit-${version}";
  version = "1.4.21";

  src = fetchurl {
    url = "http://download.gna.org/mhwaveedit/${name}.tar.bz2";
    sha256 = "0jl7gvhwsz4fcn5d146h4m6i3hlxdsw4mmj280cv9g70p6zqi1w7";
  };

  buildInputs =
   [ SDL alsaLib gtk jackaudio ladspaH libsamplerate libsndfile
     pkgconfig pulseaudio
   ];

  configureFlags = "--with-default-ladspa-path=${ladspaPlugins}/lib/ladspa";

  meta = with stdenv.lib; {
    description = "graphical program for editing, playing and recording sound files";
    homepage = https://gna.org/projects/mhwaveedit;
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.goibhniu ];
  };
}

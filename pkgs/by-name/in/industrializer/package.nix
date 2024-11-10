{ lib, stdenv
, fetchurl
, alsa-lib
, audiofile
, autoconf
, automake
, gnome2
, gtk2
, libGL
, libjack2
, libtool
, libxml2
, pkg-config
}:

stdenv.mkDerivation rec {
  pname = "industrializer";
  version = "0.2.7";
  src = fetchurl {
    url = "mirror://sourceforge/project/${pname}/ps${pname}-${version}.tar.xz";
    sha256 = "0k688k2wppam351by7cp9m7an09yligzd89padr8viqy63gkdk6v";
  };

  nativeBuildInputs = [ pkg-config autoconf automake ];

  buildInputs = [
    alsa-lib
    audiofile
    gnome2.gtkglext
    gtk2
    libGL
    libjack2
    libtool
    libxml2
  ];

  preConfigure = "./autogen.sh";

  meta = {
    description = "This program generates synthesized percussion sounds using physical modelling";
    longDescription = ''
      The range of sounds possible include but is not limited to cymbal sounds, metallic noises, bubbly sounds, and chimes.
      After a sound is rendered, it can be played and then saved to a .WAV file.
    '';
    homepage = "https://sourceforge.net/projects/industrializer/";
    license = lib.licenses.gpl2Plus;
    maintainers = [ lib.maintainers.magnetophon ];
    platforms = lib.platforms.linux;
    mainProgram = "psindustrializer";
  };
}

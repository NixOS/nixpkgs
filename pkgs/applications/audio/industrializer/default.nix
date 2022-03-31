{ lib, stdenv
, fetchurl
, alsa-lib
, audiofile
, autoconf
, automake
, gnome2
, gtk2
, libjack2
, libtool
, libxml2
, pkg-config
}:

stdenv.mkDerivation rec {
  pname = "industrializer";
  version = "0.2.6";
  src = fetchurl {
    url = "mirror://sourceforge/project/${pname}/ps${pname}-${version}.tar.bz2";
    sha256 = "0vls94hqpkk8h17da6fddgqbl5dgm6250av3raimhhzwvm5r1gfi";
  };

  nativeBuildInputs = [ pkg-config autoconf automake ];

  buildInputs = [
    alsa-lib
    audiofile
    gnome2.gtkglext
    gtk2
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
  };
}

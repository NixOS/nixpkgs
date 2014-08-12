{ stdenv, fetchurl, pkgconfig, unzip, portaudio, wxGTK, sox }:

stdenv.mkDerivation rec {
  name = "espeakedit-1.48.03";

  src = fetchurl {
    url = "mirror://sourceforge/espeak/${name}.zip";
    sha256 = "0x8s7vpb7rw5x37yjzy1f98m4f2csdg89libb74fm36gn8ly0hli";
  };

  buildInputs = [ pkgconfig unzip portaudio wxGTK ];

  # TODO:
  # Uhm, seems like espeakedit still wants espeak-data/ in $HOME, even thought
  # it should use $espeak/share/espeak-data. Have to contact upstream to get
  # this fixed.
  #
  # Workaround:
  #  cp -r $(nix-build -A espeak)/share/espeak-data ~
  #  chmod +w ~/espeak-data

  patches = [
    ./espeakedit-fix-makefile.patch
    ./espeakedit-configurable-sox-path.patch
    ./espeakedit-configurable-path-espeak-data.patch
  ];

  postPatch = ''
    # Disable -Wall flag because it's noisy
    sed -i "s/-Wall//g" src/Makefile

    # Fixup paths (file names from above espeak-configurable* patches)
    for file in src/compiledata.cpp src/readclause.cpp src/speech.h; do
        sed -e "s|@sox@|${sox}/bin/sox|" \
            -e "s|@prefix@|$out|" \
            -i "$file"
    done
  '' + stdenv.lib.optionalString (portaudio.api_version == 19) ''
    cp src/portaudio19.h src/portaudio.h
  '';

  buildPhase = ''
    make -C src
  '';

  installPhase = ''
    mkdir -p "$out/bin"
    cp src/espeakedit "$out/bin"
  '';

  meta = with stdenv.lib; {
    description = "Phoneme editor for espeak";
    homepage = http://espeak.sourceforge.net/;
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
  };
}

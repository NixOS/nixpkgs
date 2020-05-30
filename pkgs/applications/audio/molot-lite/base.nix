{ stdenv, fetchurl, unzip, lv2 }:

rec {
  version = "unstable-2014-04-23";

  src = fetchurl {
    # the source is zipped inside the repository, so this doesn't work:
    # url = "mirror://sourceforge/molot/molot_src.zip";
    url = "https://sourceforge.net/p/molot/code/ci/master/tree/molot_src.zip?format=raw";
    sha256 = "1c47dwfgrmn9459px8s5zikcqyr0777v226qzcxlr6azlcjwr51b";
  };

  buildInputs = [ unzip lv2 ];

  unpackPhase = "unzip $src";

  installFlags = [ "INSTALL_DIR=$(out)/lib/lv2" ];

  meta = with stdenv.lib; {
    description = "a stereo and mono audio signal dynamic range compressor in LV2 format";
    homepage = "https://sourceforge.net/projects/molot/";
    license = licenses.gpl3Plus;
    maintainers = [ maintainers.magnetophon ];
    platforms = platforms.linux;
  };
}

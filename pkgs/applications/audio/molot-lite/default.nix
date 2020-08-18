{ stdenv, fetchurl, unzip, lv2 }:

stdenv.mkDerivation {
  pname = "molot-lite";
  version = "unstable-2014-04-23";

  src = fetchurl {
    # fetchzip does not accept urls that do not end with .zip.
    url = "https://sourceforge.net/p/molot/code/ci/c4eddc426f8d5821e8ebcf1d67265365e4c8c52a/tree/molot_src.zip?format=raw";
    sha256 = "1c47dwfgrmn9459px8s5zikcqyr0777v226qzcxlr6azlcjwr51b";
  };

  nativeBuildInputs = [ unzip ];
  buildInputs = [ lv2 ];

  unpackPhase = ''
    unzip $src
  '';

  buildPhase = ''
    make -C Molot_Mono_Lite
    make -C Molot_Stereo_Lite
  '';

  installPhase = ''
    make install INSTALL_DIR=$out/lib/lv2 -C Molot_Mono_Lite
    make install INSTALL_DIR=$out/lib/lv2 -C Molot_Stereo_Lite
  '';

  meta = with stdenv.lib; {
    description = "Stereo and mono audio signal dynamic range compressor in LV2 format";
    homepage = "https://sourceforge.net/projects/molot/";
    license = licenses.gpl3Plus;
    maintainers = [ maintainers.magnetophon ];
    platforms = platforms.linux;
  };
}

{ stdenv, fetchFromGitHub, mkDerivation
, qmake, qtmultimedia, gst_all_1 }:

mkDerivation {
  name = "caster-soundboard";
  version = "unstable-2019-9-28";
  src = fetchFromGitHub {
    owner = "JupiterBroadcasting";
    repo = "CasterSoundboard";
    rev = "1a84315b3a3d4bdca1a4b784bd19460637f44438";
    sha256 = "1npjcxw304hv8ihwv13cslbn2rcd6iqnknyqz94rdi496d1kfwv1";
  };
  sourceRoot = "source/CasterSoundboard";

  buildInputs = [
    qtmultimedia
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-ugly
  ];
  nativeBuildInputs = [ qmake ];

  enableParallelBuilding = true;

  qtWrapperArgs = [
    ''--prefix GST_PLUGIN_SYSTEM_PATH_1_0 : "$GST_PLUGIN_SYSTEM_PATH_1_0"''
  ];

  meta = {
    description = "A soundboard for hot-keying and playing back sounds.";
    homepage = "https://github.com/JupiterBroadcasting/CasterSoundboard";
    maintainers = [ stdenv.lib.maintainers.iqubic ];
    license = stdenv.lib.licenses.lgpl3;
    platforms = stdenv.lib.platforms.linux;
  };
}

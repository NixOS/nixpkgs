{ stdenvNoCC, molot-mono-lite, molot-stereo-lite }:
with stdenvNoCC.lib;


stdenvNoCC.mkDerivation {
  pname = "molot-lite";
  version = molot-mono-lite.version;

  buildCommand = ''
    mkdir -p $out/lib/lv2/
    ln -s ${makeLibraryPath [molot-mono-lite]}/lv2/Molot_Mono_Lite.lv2 $out/lib/lv2
    ln -s ${makeLibraryPath [molot-stereo-lite]}/lv2/Molot_Stereo_Lite.lv2 $out/lib/lv2
  '';
}

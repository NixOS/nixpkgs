{
  stdenv,
  alsa-plugins,
  writeShellScriptBin,
}:
let
  arch = if stdenv.hostPlatform.system == "i686-linux" then "32" else "64";
in
writeShellScriptBin "ap${arch}" ''
  ALSA_PLUGIN_DIRS=${alsa-plugins}/lib/alsa-lib "$@"
''

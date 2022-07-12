{ faust
, jack2
, qtbase
, libsndfile
, alsa-lib
, which
, writeText
, makeWrapper
}:

faust.wrapWithBuildEnv rec {

  baseName = "faust2jaqt";

  scripts = [
    "faust2jaqt"
    "faust2jackserver"
  ];

  propagatedBuildInputs = [
    jack2
    qtbase
    libsndfile
    alsa-lib
    which
  ];

  dontWrapQtApps = true;

  # Wrap the binary coming out of the the compilation script, so it knows QT_PLUGIN_PATH
  wrapBinary = writeText "wrapBinary" ''
    source ${makeWrapper}/nix-support/setup-hook
    for p in $FILES; do
      binary=$(basename --suffix=.dsp "$p")
      mv $binary ."$binary"-wrapped
      makeWrapper ./."$binary"-wrapped ."$binary"-temp  --set QT_PLUGIN_PATH "${qtbase}/${qtbase.qtPluginPrefix}"
      mv ."$binary"-temp $binary
    done
  '';
  # append the wrapping code to the compilation script
  preFixup = ''
    for script in "$out"/bin/*; do
      echo $script
      cat ${wrapBinary} >> $script
    done
  '';
}

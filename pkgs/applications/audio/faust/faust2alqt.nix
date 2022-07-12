{ faust
, alsa-lib
, qtbase
, writeText
, makeWrapper
}:

faust.wrapWithBuildEnv rec {

  baseName = "faust2alqt";

  propagatedBuildInputs = [
    alsa-lib
    qtbase
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

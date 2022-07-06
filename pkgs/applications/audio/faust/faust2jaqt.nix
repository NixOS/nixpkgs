{ faust
, jack2
, qtbase
, libsndfile
, alsa-lib
, which
, writeText
, runtimeShell
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
    for p in $FILES; do
      binary=$(basename --suffix=.dsp "$p")
      touch "$binary"-temp-wrap.sh
      echo '#!${runtimeShell}' >> "$binary"-temp-wrap.sh
      echo 'export QT_PLUGIN_PATH=${qtbase}/${qtbase.qtPluginPrefix}' >> "$binary"-temp-wrap.sh
      echo "./."$binary"-wrapped" >> "$binary"-temp-wrap.sh
      mv "$binary" ."$binary"-wrapped
      mv "$binary"-temp-wrap.sh "$binary"
      chmod +x "$binary"
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

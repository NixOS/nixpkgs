{ faust
, alsa-lib
, qtbase
, writeText
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
    for p in $FILES; do
      binary=$(basename --suffix=.dsp "$p")
      touch "$binary"-temp-wrap.sh
      echo '#!/usr/bin/env bash' >> "$binary"-temp-wrap.sh
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

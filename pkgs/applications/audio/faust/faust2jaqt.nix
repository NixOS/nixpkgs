{ faust
, jack2
<<<<<<< HEAD
, qtbase
, libsndfile
, alsa-lib
, writeText
, buildPackages
, which
}:
let
  # Wrap the binary coming out of the the compilation script, so it knows QT_PLUGIN_PATH
  wrapBinary = writeText "wrapBinary" ''
    source ${buildPackages.makeWrapper}/nix-support/setup-hook
    for p in $FILES; do
      workpath=$PWD
      cd -- "$(dirname "$p")"
      binary=$(basename --suffix=.dsp "$p")
      rm -f .$binary-wrapped
      wrapProgram $binary --set QT_PLUGIN_PATH "${qtbase}/${qtbase.qtPluginPrefix}"
      sed -i $binary -e 's@exec@cd "$(dirname "$(readlink -f "''${BASH_SOURCE[0]}")")" \&\& exec@g'
      cd $workpath
    done
  '';
in
=======
, qt4
, libsndfile
, alsa-lib
, which
}:

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
faust.wrapWithBuildEnv {

  baseName = "faust2jaqt";

  scripts = [
    "faust2jaqt"
    "faust2jackserver"
  ];

  propagatedBuildInputs = [
    jack2
<<<<<<< HEAD
    qtbase
=======
    qt4
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    libsndfile
    alsa-lib
    which
  ];

<<<<<<< HEAD

  dontWrapQtApps = true;

  preFixup = ''
    for script in "$out"/bin/*; do
      # append the wrapping code to the compilation script
      cat ${wrapBinary} >> $script
      # prevent the qmake error when running the script
      sed -i "/QMAKE=/c\ QMAKE="${qtbase.dev}/bin/qmake"" $script
    done
  '';
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}

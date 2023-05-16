{ stdenv, lib, fetchFromGitHub, faust2jaqt, faust2lv2 }:
stdenv.mkDerivation rec {
  pname = "faustPhysicalModeling";
<<<<<<< HEAD
  version = "2.60.3";
=======
  version = "2.54.9";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "grame-cncm";
    repo = "faust";
    rev = version;
<<<<<<< HEAD
    sha256 = "sha256-kaKDZKs/UsrqYlGmGgpSRcqN7FypxLCcIF72klovD4k=";
=======
    sha256 = "sha256-1ZS7SVTWI1vNOGycZIDyKLgwfNooIGDa8Wmr6qfFSkU=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  buildInputs = [ faust2jaqt faust2lv2 ];

<<<<<<< HEAD
  dontWrapQtApps = true;

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  buildPhase = ''
    cd examples/physicalModeling

    for f in *MIDI.dsp; do
      faust2jaqt -time -vec -double -midi -nvoices 16 -t 99999 $f
      faust2lv2  -time -vec -double -gui -nvoices 16 -t 99999 $f
    done
  '';

  installPhase = ''
    mkdir -p $out/lib/lv2 $out/bin
    mv *.lv2/ $out/lib/lv2
    for f in $(find . -executable -type f); do
      cp $f $out/bin/
    done
  '';

  meta = with lib; {
    description = "The physical models included with faust compiled as jack standalone and lv2 instruments";
    homepage = "https://github.com/grame-cncm/faust/tree/master-dev/examples/physicalModeling";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ magnetophon ];
  };
}

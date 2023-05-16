{ lib, stdenv, fetchFromGitHub, faust2jaqt, faust2lv2 }:
stdenv.mkDerivation rec {
  pname = "faustCompressors";
  version = "1.2";

  src = fetchFromGitHub {
    owner = "magnetophon";
    repo = "faustCompressors";
    rev = "v${version}";
    sha256 = "144f6g17q4m50kxzdncsfzdyycdfprnpwdaxcwgxj4jky1xsha1d";
  };

  buildInputs = [ faust2jaqt faust2lv2 ];

<<<<<<< HEAD
  dontWrapQtApps = true;

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  buildPhase = ''
    echo "hack out autoComp.dsp due to https://github.com/grame-cncm/faust/407/issues "
    rm autoComp.dsp
    for f in *.dsp;
    do
      echo "compiling standalone from" $f
      faust2jaqt -time -double -t 99999 $f
    done

    for f in *.dsp;
    do
      echo "Compiling plugin from" $f
      faust2lv2  -time -double -gui -t 99999 $f
    done
  '';

  installPhase = ''
    mkdir -p $out/lib/lv2
    mv *.lv2/ $out/lib/lv2
    mkdir -p $out/bin
    rm newlib.sh
<<<<<<< HEAD
    for f in $(find . -executable -type f); do
=======
    for f in $(find . -executable -type f);
    do
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      cp $f $out/bin/
    done
  '';

  meta = {
    description = "A collection of bread and butter compressors";
    homepage = "https://github.com/magnetophon/faustCompressors";
    license = lib.licenses.gpl3;
    maintainers = [ lib.maintainers.magnetophon ];
  };
}

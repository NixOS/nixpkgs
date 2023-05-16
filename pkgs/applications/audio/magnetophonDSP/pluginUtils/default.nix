{ lib, stdenv, fetchFromGitHub, faust2jaqt, faust2lv2 }:
stdenv.mkDerivation rec {
  pname = "pluginUtils";
  version = "1.1";

  src = fetchFromGitHub {
    owner = "magnetophon";
    repo = "pluginUtils";
    rev = "V${version}";
    sha256 = "1hnr5sp7k6ypf4ks61lnyqx44dkv35yllf3a3xcbrw7yqzagwr1c";
  };

  buildInputs = [ faust2jaqt faust2lv2 ];

<<<<<<< HEAD
  dontWrapQtApps = true;

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  buildPhase = ''
    for f in *.dsp
      do
        echo "Building jack standalone for $f"
        faust2jaqt -vec -time -t 99999 "$f"
        echo "Building lv2 for $f"
        faust2lv2 -vec -time -gui -t 99999 "$f"
      done
  '';

  installPhase = ''
    rm -f *.dsp
    rm -f *.lib
    mkdir -p $out/lib/lv2
    mv *.lv2/ $out/lib/lv2
    mkdir -p $out/bin
<<<<<<< HEAD
    for f in $(find . -executable -type f); do
      cp $f $out/bin/
    done
 '';
=======
    cp * $out/bin/
  '';
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = {
    description = "Some simple utility lv2 plugins";
    homepage = "https://github.com/magnetophon/pluginUtils";
    license = lib.licenses.gpl3;
    maintainers = [ lib.maintainers.magnetophon ];
  };
}

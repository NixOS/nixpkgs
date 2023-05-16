{ lib, stdenv, fetchFromGitHub, faust2jaqt, faust2lv2 }:
stdenv.mkDerivation rec {
  pname = "Tambura";
  version = "1.0";

  src = fetchFromGitHub {
    owner = "olilarkin";
    repo = pname;
    rev = "v${version}";
    sha256 = "1w80cmiyzca1wirf5gypg3hcix1ky777id8wnd3k92mn1jf4a24y";
  };

  buildInputs = [ faust2jaqt faust2lv2 ];

<<<<<<< HEAD
  dontWrapQtApps = true;

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  buildPhase = ''
    faust2jaqt -vec -time -t 99999 ${pname}.dsp
    faust2lv2 -vec -time -gui -t 99999 ${pname}.dsp
  '';

  installPhase = ''
    mkdir -p $out/bin
<<<<<<< HEAD
    for f in $(find . -executable -type f); do
      cp $f $out/bin/
    done
=======
    cp ${pname} $out/bin/
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    mkdir -p $out/lib/lv2
    cp -r ${pname}.lv2/ $out/lib/lv2
  '';

  meta = with lib; {
    description = "A FAUST patch inspired by the Indian Tambura/Tanpura - a four string drone instrument, known for its unique rich harmonic timbre";
    homepage = "https://github.com/olilarkin/Tambura";
    license = licenses.gpl2;
    maintainers = [ maintainers.magnetophon ];
  };
}

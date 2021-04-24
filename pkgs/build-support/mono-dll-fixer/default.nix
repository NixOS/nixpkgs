{ stdenv, perl }:

stdenv.mkDerivation {
  name = "mono-dll-fixer";

  src = ./dll-fixer.pl;
  dontUnpack = true;

  buildInputs = [ perl ];

  installPhase = ''
    cp $src $out
    chmod +x $out
  '';
}

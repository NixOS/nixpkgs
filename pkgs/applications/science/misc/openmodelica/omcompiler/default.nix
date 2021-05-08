{gfortran, flex, bison, jre, openblas, curl, readline, expat,
libffi, binutils, mkOpenModelicaDerivation}:

mkOpenModelicaDerivation rec {
  pname = "omcompiler";
  omtarget = "omc";
  omdir = "OMCompiler";
  omdeps = [];
  omautoconf = true;

  nativeBuildInputs = [gfortran flex bison];

  buildInputs = [jre openblas curl readline expat libffi binutils];

  preFixup = ''
    for entry in $(find $out -name libipopt.so); do
      patchelf --shrink-rpath --allowed-rpath-prefixes /nix/store $entry
      patchelf --set-rpath '$ORIGIN':"$(patchelf --print-rpath $entry)" $entry
    done
  '';
}

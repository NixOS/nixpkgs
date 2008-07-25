{stdenv, wrapperDir}:

stdenv.mkDerivation {
  name = "setuid-wrapper";
  buildCommand = ''
    ensureDir $out/bin
    gcc -Wall -O2 -DWRAPPER_DIR=\"${wrapperDir}\" ${./setuid-wrapper.c} -o $out/bin/setuid-wrapper
    strip -s $out/bin/setuid-wrapper
  '';
}

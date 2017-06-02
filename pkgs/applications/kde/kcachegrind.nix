{
  mkDerivation, lib, kdeWrapper,
  extra-cmake-modules, kdoctools,
  kio, ki18n,
  perl, python, php
}:

kdeWrapper {
  unwrapped = mkDerivation {
    name = "kcachegrind";
    meta = {
      license = with lib.licenses; [ gpl2 ];
      maintainers = with lib.maintainers; [ orivej ];
    };
    nativeBuildInputs = [ extra-cmake-modules kdoctools ];
    buildInputs = [ perl python php kio ki18n ];
    enableParallelBuilding = true;
  };

  targets = [
    "bin/kcachegrind"
    "bin/dprof2calltree"    # perl
    "bin/hotshot2calltree"  # python
    "bin/memprof2calltree"  # perl
    "bin/op2calltree"       # perl
    "bin/pprof2calltree"    # php
  ];
}

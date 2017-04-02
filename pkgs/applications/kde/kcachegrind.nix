{
  kdeApp, lib, kdeWrapper,
  cmake, automoc4,
  kdelibs, perl, python, php
}:

kdeWrapper {
  unwrapped = kdeApp {
    name = "kcachegrind";
    meta = {
      license = with lib.licenses; [ gpl2 ];
      maintainers = with lib.maintainers; [ orivej ];
    };
    nativeBuildInputs = [ cmake automoc4 ];
    buildInputs = [ kdelibs perl python php ];
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

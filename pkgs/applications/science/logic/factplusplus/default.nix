{ stdenv, lib, fetchFromBitbucket, cmake, jdk }:

stdenv.mkDerivation rec {
  pname = "factplusplus";
  version = "1.6.5";

  src = fetchFromBitbucket {
    owner = "dtsarkov";
    repo = "factplusplus";
    rev = "Release-${version}";
    sha256 = "wzK1QJsNN0Q73NM+vjaE/vLuGf8J1Zu5ZPAkZNiKnME=";
  };

  buildInputs = [ jdk ];

  nativeBuiltInputs = [ cmake ];

  configurePhase = ''
    sed -i 's/OS = MACOSX/OS = LINUX/g' Makefile.include
    printf '%s\n%s\n' '#include <iostream>' "$(cat Kernel/AtomicDecomposer.cpp)" > Kernel/AtomicDecomposer.cpp
  '';

  installPhase = ''
    mkdir -p $out/bin
    mkdir -p $out/lib
    install -m 755 FaCT++.{C,JNI,KE,Kernel}/obj/*.{so,o} $out/lib/
    install -m 755 FaCT++/obj/FaCT++ $out/bin/FaCT++
  '';

   meta = with lib; {
    description = "Tableaux-based reasoner for expressive Description Logics (DL)";
    homepage    = "http://owl.cs.manchester.ac.uk/tools/fact/";
    maintainers = [ maintainers.mgttlinger ];
    license     = licenses.gpl2Plus;
    platforms   = platforms.linux;
  };
}

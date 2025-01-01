{
  stdenv,
  lib,
  fetchFromBitbucket,
  jdk,
}:

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

  configurePhase = ''
    runHook preConfigure

    sed -i 's/OS = MACOSX/OS = LINUX/g' Makefile.include
    printf '%s\n%s\n' '#include <iostream>' "$(cat Kernel/AtomicDecomposer.cpp)" > Kernel/AtomicDecomposer.cpp

    runHook postConfigure
  '';

  installPhase = ''
    runHook preInstall

    install -Dm755 FaCT++.{C,JNI,KE,Kernel}/obj/*.{so,o} -t $out/lib/
    install -Dm755 FaCT++/obj/FaCT++ -t $out/bin

    runHook postInstall
  '';

  meta = with lib; {
    description = "Tableaux-based reasoner for expressive Description Logics (DL)";
    homepage = "http://owl.cs.manchester.ac.uk/tools/fact/";
    maintainers = [ maintainers.mgttlinger ];
    license = licenses.gpl2Plus;
    platforms = with platforms; linux ++ darwin ++ windows;
    broken = !stdenv.hostPlatform.isLinux;
    mainProgram = "FaCT++";
  };
}

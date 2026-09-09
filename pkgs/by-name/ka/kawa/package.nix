{
  lib,
  stdenv,
  fetchurl,
  jdk11,
  ant,
  makeWrapper,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kawa";
  version = "3.1.1";

  src = fetchurl {
    url = "mirror://gnu/kawa/kawa-${finalAttrs.version}.tar.gz";
    hash = "sha256-jJpQzWsQAVTJAb0ZCzrNL7g1PzNiLEos6Po5Kn8J4Bk=";
  };

  nativeBuildInputs = [
    jdk11
    ant
    makeWrapper
  ];

  buildPhase = ''
    runHook preBuild

    ant -Denable-java-frontend=yes

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/java
    cp lib/kawa.jar $out/share/java/kawa.jar

    # Install info files
    mkdir -p $out/share/info
    cp doc/*.info* $out/share/info/

    # Install man pages
    mkdir -p $out/share/man/man1
    cp doc/kawa.man $out/share/man/man1/kawa.1
    cp doc/qexo.man $out/share/man/man1/qexo.1

    mkdir -p $out/bin
    makeWrapper ${jdk11}/bin/java $out/bin/kawa \
      --add-flags "-Dkawa.home=$out -jar $out/share/java/kawa.jar"

    runHook postInstall
  '';

  meta = {
    description = "Scheme implementation running on the Java platform";
    longDescription = ''
      Kawa is a general-purpose programming language that runs on the Java platform.
      It aims to combine the benefits of dynamic scripting languages (less boiler-plate
      code, fast and easy start-up, a REPL, no required compilation step) with the
      benefits of traditional compiled languages (fast execution, static error detection,
      modularity, zero-overhead Java platform integration).
    '';
    homepage = "https://www.gnu.org/software/kawa";
    license = [
      lib.licenses.mit
      lib.licenses.gpl2Plus
    ];
    maintainers = with lib.maintainers; [ siraben ];
    platforms = lib.platforms.unix;
  };
})

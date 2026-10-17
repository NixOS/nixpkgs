{
  lib,
  stdenv,
  jre,
  setJavaClassPath,
  coursier,
  makeWrapper,
}:

stdenv.mkDerivation rec {
  pname = "firrtl2";
  version = "6.0.0";
  scalaVersion = "2.13";

  # Required by CI
  strictDeps = true;
  __structuredAttrs = true;

  deps = stdenv.mkDerivation {
    pname = "${pname}-deps";
    inherit version;
    nativeBuildInputs = [ coursier ];
    buildCommand = ''
      export COURSIER_CACHE=$(pwd)
      cs fetch edu.berkeley.cs:${pname}_${scalaVersion}:${version} > deps
      mkdir -p $out/share/java
      cp $(< deps) $out/share/java
    '';
    outputHashMode = "recursive";
    outputHash = "sha256-gO//jEM+Gb+SktSbVnqGTUbDXgHucsEHQe0S+uWSHQ0=";
  };

  nativeBuildInputs = [
    makeWrapper
    setJavaClassPath
  ];
  buildInputs = [ deps ];

  dontUnpack = true;

  installPhase = ''
    runHook preInstall

    makeWrapper ${jre}/bin/java $out/bin/${pname} \
      --add-flags "-cp $CLASSPATH firrtl2.stage.FirrtlMain"

    runHook postInstall
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    $out/bin/firrtl2 --firrtl-source "${''
      circuit test:
        module test:
          input a: UInt<8>
          input b: UInt<8>
          output o: UInt
          o <= add(a, not(b))
    ''}" -o test.v
    cat test.v
    grep -qFe "module test" -e "endmodule" test.v
  '';

  meta = {
    description = "Flexible Intermediate Representation for RTL";
    mainProgram = "firrtl2";
    longDescription = ''
      Firrtl is an intermediate representation (IR) for digital circuits
      designed as a platform for writing circuit-level transformations.
    '';
    homepage = "https://www.chisel-lang.org/firrtl/";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
}

{
  lib,
  stdenv,
  jre,
  setJavaClassPath,
  coursier,
  makeWrapper,
}:

stdenv.mkDerivation rec {
  pname = "firrtl";
  version = "1.5.3";
  scalaVersion = "2.13"; # pin, for determinism

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
    outputHash = "sha256-xy3zdJZk6Q2HbEn5tRQ9Z0AjyXEteXepoWDaATjiUUw=";
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
      --add-flags "-cp $CLASSPATH firrtl.stage.FirrtlMain"

    runHook postInstall
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    $out/bin/firrtl --firrtl-source "${''
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

  meta = with lib; {
    description = "Flexible Intermediate Representation for RTL";
    mainProgram = "firrtl";
    longDescription = ''
      Firrtl is an intermediate representation (IR) for digital circuits
      designed as a platform for writing circuit-level transformations.
    '';
    homepage = "https://www.chisel-lang.org/firrtl/";
    license = licenses.asl20;
    maintainers = [ ];
  };
}

{
  lib,
  stdenv,
  jre,
  coursier,
  makeWrapper,
  setJavaClassPath,
}:

let
  baseName = "scalafmt";
  version = "3.10.6";
  deps = stdenv.mkDerivation {
    name = "${baseName}-deps-${version}";
    buildCommand = ''
      export COURSIER_CACHE=$(pwd)
      ${coursier}/bin/cs fetch org.scalameta:scalafmt-cli_2.13:${version} > deps
      mkdir -p $out/share/java
      cp $(< deps) $out/share/java/
    '';
    outputHashMode = "recursive";
    outputHash = "sha256-ZSVatzkY+6oiVL4MPf3oyFZiTYaXQ0PNfYvS3O/kU+A=";
  };
in
stdenv.mkDerivation {
  pname = baseName;
  inherit version;

  nativeBuildInputs = [
    makeWrapper
    setJavaClassPath
  ];
  buildInputs = [ deps ];

  dontUnpack = true;

  installPhase = ''
    runHook preInstall

    makeWrapper ${jre}/bin/java $out/bin/${baseName} \
      --add-flags "-cp $CLASSPATH org.scalafmt.cli.Cli"

    runHook postInstall
  '';

  installCheckPhase = ''
    $out/bin/${baseName} --version | grep -q "${version}"
  '';

  passthru.updateScript = ./update.sh;

  meta = {
    description = "Opinionated code formatter for Scala";
    homepage = "http://scalameta.org/scalafmt";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.markus1189 ];
    mainProgram = "scalafmt";
  };
}

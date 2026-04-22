{
  lib,
  stdenv,
  jre,
  coursier,
  makeWrapper,
  setJavaClassPath,
  testers,
  giter8,
}:

let
  pname = "giter8";
  version = "0.18.0";
  deps = stdenv.mkDerivation {
    name = "${pname}-deps-${version}";
    buildCommand = ''
      export COURSIER_CACHE=$(pwd)
      ${coursier}/bin/cs fetch org.foundweekends.giter8:giter8_2.13:${version} > deps
      mkdir -p $out/share/java
      cp $(< deps) $out/share/java/
    '';
    outputHashMode = "recursive";
    outputHash = "sha256-MrFuyktyXADZ8lh/vzpVNi12IbKjM/Q8P7X8EE4KFNo=";
  };
in
stdenv.mkDerivation {
  inherit pname version;

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [
    makeWrapper
    setJavaClassPath
  ];
  buildInputs = [ deps ];

  dontUnpack = true;

  installPhase = ''
    runHook preInstall

    makeWrapper ${jre}/bin/java $out/bin/g8 \
      --add-flags "-cp $CLASSPATH giter8.Giter8"

    runHook postInstall
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    $out/bin/g8 --version | grep -q "${version}"
  '';

  passthru.updateScript = ./update.sh;

  passthru.tests.version = testers.testVersion {
    package = giter8;
    command = "g8 --version";
  };

  meta = {
    description = "A command line tool to apply templates defined on GitHub";
    homepage = "https://www.foundweekends.org/giter8/";
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.agilesteel ];
    changelog = "https://github.com/foundweekends/giter8/releases/tag/v${version}";
    mainProgram = "g8";
  };
}

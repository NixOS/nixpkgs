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
<<<<<<< HEAD
  version = "3.10.2";
=======
  version = "3.9.8";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  deps = stdenv.mkDerivation {
    name = "${baseName}-deps-${version}";
    buildCommand = ''
      export COURSIER_CACHE=$(pwd)
      ${coursier}/bin/cs fetch org.scalameta:scalafmt-cli_2.13:${version} > deps
      mkdir -p $out/share/java
      cp $(< deps) $out/share/java/
    '';
    outputHashMode = "recursive";
<<<<<<< HEAD
    outputHash = "sha256-98RW+aCgf+gEvupbq5+eVlybdfDWn80otoZU6g5un+c=";
=======
    outputHash = "sha256-mZrRb2n+ZE0DmQaH9iSMzPcpdZPtflekkP8bHv6Qw4k=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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

<<<<<<< HEAD
  passthru.updateScript = ./update.sh;

=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  meta = {
    description = "Opinionated code formatter for Scala";
    homepage = "http://scalameta.org/scalafmt";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.markus1189 ];
    mainProgram = "scalafmt";
  };
}

{
  lib,
  fetchurl,
  makeWrapper,
  nextflow,
  nf-test,
  openjdk11,
  stdenv,
  testers,
}:
stdenv.mkDerivation rec {

  pname = "nf-test";
  version = "0.8.4";

  src = fetchurl {
    url = "https://github.com/askimed/${pname}/releases/download/v${version}/${pname}-${version}.tar.gz";
    hash = "sha256-gCO75uNUKU+6UUST9CP4DnWGnl2vflH0y4CId/3IQ4E=";
  };
  sourceRoot = ".";

  buildInputs = [
    makeWrapper
  ];

  nativeBuildInputs = [
    nextflow
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/nf-test
    install -Dm644 nf-test.jar $out/share/nf-test

    mkdir -p $out/bin
    makeWrapper ${openjdk11}/bin/java $out/bin/nf-test \
      --add-flags "-jar $out/share/nf-test/nf-test.jar" \
      --prefix PATH : ${lib.makeBinPath nativeBuildInputs} \

    runHook postInstall
  '';

  passthru.tests.version = testers.testVersion {
    package = nf-test;
    command = "nf-test version";
  };

  meta = with lib; {
    description = "Simple test framework for Nextflow pipelines";
    homepage = "https://www.nf-test.com/";
    changelog = "https://github.com/askimed/nf-test/releases";
    license = licenses.mit;
    maintainers = with maintainers; [ rollf ];
    mainProgram = "nf-test";
    platforms = platforms.unix;
  };
}

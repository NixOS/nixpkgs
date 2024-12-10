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
  version = "0.9.1";

  src = fetchurl {
    url = "https://github.com/askimed/nf-test/releases/download/v${version}/nf-test-${version}.tar.gz";
    hash = "sha256-NjmB6bL9j6p4CWeVWU9q+aAe+dgH6lwUNZYARm41p8M=";
  };
  sourceRoot = ".";

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/nf-test
    install -Dm644 nf-test.jar $out/share/nf-test

    mkdir -p $out/bin
    makeWrapper ${openjdk11}/bin/java $out/bin/nf-test \
      --add-flags "-jar $out/share/nf-test/nf-test.jar" \
      --prefix PATH : ${lib.makeBinPath [ nextflow ]} \

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

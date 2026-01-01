{
  lib,
  stdenv,
  fetchurl,
  gawk,
  git,
  gnugrep,
  installShellFiles,
  jre,
  makeWrapper,
  testers,
  unzip,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "crowdin-cli";
<<<<<<< HEAD
  version = "4.12.0";

  src = fetchurl {
    url = "https://github.com/crowdin/crowdin-cli/releases/download/${finalAttrs.version}/crowdin-cli.zip";
    hash = "sha256-y6JBlZ1h/1iWr8r+323sYpQNpzM3pHtC/CzQt4HL7MQ=";
=======
  version = "4.11.0";

  src = fetchurl {
    url = "https://github.com/crowdin/crowdin-cli/releases/download/${finalAttrs.version}/crowdin-cli.zip";
    hash = "sha256-5nQq/p6Zd/CC9Qqwwxk3Cu3CoCL2eNgNGHVC3pRGnVI=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  nativeBuildInputs = [
    installShellFiles
    makeWrapper
    unzip
  ];

  installPhase = ''
    runHook preInstall

    install -D crowdin-cli.jar $out/lib/crowdin-cli.jar

    installShellCompletion --cmd crowdin --bash ./crowdin_completion

    makeWrapper ${jre}/bin/java $out/bin/crowdin \
      --argv0 crowdin \
      --add-flags "-jar $out/lib/crowdin-cli.jar" \
      --prefix PATH : ${
        lib.makeBinPath [
          gawk
          gnugrep
          git
        ]
      }

    runHook postInstall
  '';

  passthru.tests.version = testers.testVersion { package = finalAttrs.finalPackage; };

<<<<<<< HEAD
  meta = {
    mainProgram = "crowdin";
    homepage = "https://github.com/crowdin/crowdin-cli/";
    description = "Command-line client for the Crowdin API";
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ DamienCassou ];
=======
  meta = with lib; {
    mainProgram = "crowdin";
    homepage = "https://github.com/crowdin/crowdin-cli/";
    description = "Command-line client for the Crowdin API";
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
    license = licenses.mit;
    maintainers = with maintainers; [ DamienCassou ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
})

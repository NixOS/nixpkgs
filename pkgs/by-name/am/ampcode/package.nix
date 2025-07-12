{
  lib,
  writeShellApplication,
  nodejs_22,
  testers,
}:

writeShellApplication {
  name = "amp";

  runtimeInputs = [
    nodejs_22
  ];

  text = ''
    exec npx --yes @sourcegraph/amp "$@"
  '';

  passthru.tests.version = testers.testVersion {
    package = (
      writeShellApplication {
        name = "amp";
        runtimeInputs = [ nodejs_22 ];
        text = ''exec npx --yes @sourcegraph/amp "$@"'';
      }
    );
    command = "HOME=$(mktemp -d) amp --version";
  };

  meta = {
    description = "CLI for Amp, an agentic coding agent in research preview from Sourcegraph";
    homepage = "https://ampcode.com/";
    downloadPage = "https://www.npmjs.com/package/@sourcegraph/amp";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [
      keegancsmith
      owickstrom
      ghuntley
    ];
    mainProgram = "amp";
  };
}

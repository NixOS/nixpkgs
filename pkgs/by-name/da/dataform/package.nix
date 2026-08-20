{
  lib,
  buildNpmPackage,
  fetchurl,
  nix-update-script,
  nodejs,
  makeWrapper,
  testers,
  runCommand,
  writableTmpDirAsHomeHook,
  cacert,
}:

buildNpmPackage (finalAttrs: {
  pname = "dataform";
  version = "3.0.64";

  __structuredAttrs = true;
  strictDeps = true;

  inherit nodejs;

  src = fetchurl {
    url = "https://registry.npmjs.org/@dataform/cli/-/cli-${finalAttrs.version}.tgz";
    hash = "sha256-ump4LsQzxkSsRzbBbJA4XxHW0C2abhfG+Wf10EZLt5g=";
  };

  # Inject the locally committed lockfile into the extracted source
  postPatch = ''
    cp ${./package-lock.json} package-lock.json
  '';

  npmDepsHash = "sha256-2Uzh78D9KQzJSpDYOSi2DmJBeKqXbZpLYXlSy+a3Bs4=";

  dontNpmBuild = true;

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    wrapProgram $out/bin/dataform \
      --prefix PATH : ${lib.makeBinPath [ nodejs ]}
  '';

  passthru = {
    updateScript = nix-update-script {
      extraArgs = [ "--generate-lockfile" ];
    };

    tests = {
      version = testers.testVersion {
        package = finalAttrs.finalPackage;
      };

      help = testers.runCommand {
        name = "${finalAttrs.pname}-help-test";
        nativeBuildInputs = [ finalAttrs.finalPackage ];
        script = ''
          dataform --help | grep -F "dataform [command]"
          touch $out
        '';
      };

      # `dataform install` should refuse to run against a workflow_settings.yaml
      # project -- this is expected behavior, not a bug: packages for these
      # projects are resolved at runtime instead.
      install-refuses = testers.testBuildFailure' {
        name = "${finalAttrs.pname}-install-refuses-test";
        drv =
          runCommand "${finalAttrs.pname}-install-refuses-test"
            {
              nativeBuildInputs = [ finalAttrs.finalPackage ];
            }
            ''
              dataform init test-project my-test-db US
              cd test-project
              dataform install .
            '';
        expectedBuilderLogEntries = [
          "No installation is needed when using workflow_settings.yaml"
        ];
      };

      # `dataform compile` on a freshly-initialized workflow_settings.yaml
      # project lazily fetches @dataform/core from the npm registry the
      # first time it's needed -- this is the "packages are installed at
      # runtime" behavior from the `install` refusal message actually
      # happening. Needs network + a CA bundle, unlike the other tests here.
      workflow = testers.runCommand {
        name = "${finalAttrs.pname}-workflow-test";
        nativeBuildInputs = [
          finalAttrs.finalPackage
          writableTmpDirAsHomeHook
          cacert
        ];
        script = ''
          dataform init test-project my-test-db US
          test -d test-project/definitions
          test -d test-project/includes
          test -f test-project/workflow_settings.yaml
          grep -F "my-test-db" test-project/workflow_settings.yaml
          grep -F "US" test-project/workflow_settings.yaml

          cd test-project
          dataform compile . | grep -F "Compiled 0 action(s)."

          touch $out
        '';
      };
    };
  };

  meta = {
    mainProgram = "dataform";
    description = "Dataform CLI";
    longDescription = ''
      Dataform is a framework for managing SQL based data operations in BigQuery
      Dataform CLI is an open-source command-line tool that allows developers to locally build,
      compile, test, and execute SQLX data transformation pipelines for BigQuery.
    '';
    homepage = "https://github.com/dataform-co/dataform";
    downloadPage = "https://www.npmjs.com/package/@dataform/cli";
    changelog = "https://github.com/dataform-co/dataform/releases#release-${finalAttrs.version}";
    license = lib.licenses.asl20;
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
    identifiers = {
      cpeParts = lib.meta.cpeFullVersionWithVendor "dataform-co" finalAttrs.version;
      purlParts = {
        type = "npm";
        spec = "%40dataform/cli@${finalAttrs.version}";
      };
    };
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ KristijanZic ];
  };
})

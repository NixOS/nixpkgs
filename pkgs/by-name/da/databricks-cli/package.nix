{
  lib,
  buildGoModule,
  fetchFromGitHub,
  git,
  python3,
}:

buildGoModule rec {
  pname = "databricks-cli";
  version = "0.227.0";

  src = fetchFromGitHub {
    owner = "databricks";
    repo = "cli";
    rev = "v${version}";
    hash = "sha256-bmTPtxkVtGzjxgmXpIHus7vUUg3IKGWmlUT8iOU+dtM=";
  };

  vendorHash = "sha256-ItcGzgGIDQOnAwUA/mPy+oNjChKPTVo7QK3gsidB1xQ=";

  excludedPackages = [ "bundle/internal" ];

  postBuild = ''
    mv "$GOPATH/bin/cli" "$GOPATH/bin/databricks"
  '';

  checkFlags =
    "-skip="
    + (lib.concatStringsSep "|" [
      # Need network
      "TestTerraformArchiveChecksums"
      "TestExpandPipelineGlobPaths"
      "TestRelativePathTranslationDefault"
      "TestRelativePathTranslationOverride"
    ]);

  nativeCheckInputs = [
    git
    (python3.withPackages (
      ps: with ps; [
        setuptools
        wheel
      ]
    ))
  ];

  preCheck = ''
    # Some tested depends on git and remote url
    git init
    git remote add origin https://github.com/databricks/cli.git
  '';

  meta = with lib; {
    description = "Databricks CLI";
    mainProgram = "databricks";
    homepage = "https://github.com/databricks/cli";
    changelog = "https://github.com/databricks/cli/releases/tag/v${version}";
    license = licenses.databricks;
    maintainers = with maintainers; [ kfollesdal ];
  };
}

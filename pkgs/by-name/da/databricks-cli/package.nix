{
  lib,
  buildGoModule,
  fetchFromGitHub,
  gitMinimal,
  python3,
}:

buildGoModule rec {
  pname = "databricks-cli";
  version = "0.243.0";

  src = fetchFromGitHub {
    owner = "databricks";
    repo = "cli";
    rev = "v${version}";
    hash = "sha256-U1ZQFRPL9iYtCHJXBdgCgaE1LZgKOWdYJ1gFAsgWPI8=";
  };

  vendorHash = "sha256-InVmtV3PH75exsftC3sxz9/xt9drJPlXgRYqvqnp+yM=";

  excludedPackages = [
    "bundle/internal"
    "acceptance"
    "integration"
  ];

  postBuild = ''
    mv "$GOPATH/bin/cli" "$GOPATH/bin/databricks"
  '';

  checkFlags =
    "-skip="
    + (lib.concatStringsSep "|" [
      # Need network
      "TestConsistentDatabricksSdkVersion"
      "TestTerraformArchiveChecksums"
      "TestExpandPipelineGlobPaths"
      "TestRelativePathTranslationDefault"
      "TestRelativePathTranslationOverride"
      # Use venv
      "TestVenvSuccess"
    ]);

  nativeCheckInputs = [
    gitMinimal
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
    maintainers = with maintainers; [
      kfollesdal
      taranarmo
    ];
  };
}

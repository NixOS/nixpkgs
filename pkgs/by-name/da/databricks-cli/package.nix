{
  lib,
  buildGoModule,
  fetchFromGitHub,
  gitMinimal,
  python3,
}:

buildGoModule rec {
  pname = "databricks-cli";
  version = "0.244.0";

  src = fetchFromGitHub {
    owner = "databricks";
    repo = "cli";
    rev = "v${version}";
    hash = "sha256-TGbmGAS3hS9m6CNTtHQ0N3Fz6Ei+ry06enfYtWK/xOw=";
  };

  vendorHash = "sha256-W1tAFLSy5rX07Dkj+r+T6whbuTevpxxtakG2caUdWJQ=";

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
      # Use uv venv which doesn't work with nix
      # https://github.com/astral-sh/uv/issues/4450
      "TestVenvSuccess"
      "TestPatchWheel"
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

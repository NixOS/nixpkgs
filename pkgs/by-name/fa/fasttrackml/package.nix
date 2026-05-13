{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "fasttrackml";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "G-Research";
    repo = "fasttrackml";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Z1Hx8nYaifdlnFqp709+rKVXXXMa6cS3+evTG8ZnwrU=";
  };

  vendorHash = "sha256-GPnhE85mHg4KyPeB6+fUP4Y1MlpYTgidqawPddg5kyw=";

  tags = [
    "netgo"
    "osusergo"
    "sqlite_foreign_keys"
    "sqlite_math_functions"
    "sqlite_omit_load_extension"
    "sqlite_unlock_notify"
  ];

  # skip several tests that need network access
  checkFlags =
    let
      skippedTests = [
        # failed to connect to `host=localhost user=postgres database=postgres
        "TestImportTestSuite/Test_Ok/sqlite->postgres"
        "TestImportTestSuite/Test_Ok/sqlcipher->postgres"
        "TestImportTestSuite/Test_Ok/postgres->sqlite"
        "TestImportTestSuite/Test_Ok/postgres->sqlcipher"
        "TestImportTestSuite/Test_Ok/postgres->postgres"

        # test timed out after 10m0s while creating Google Cloud storage bucket
        "TestGetArtifactGSTestSuite/Test_Error"
        "TestGetArtifactGSTestSuite/Test_Ok"
        "TestListArtifactGSTestSuite/Test_Error"
        "TestListArtifactGSTestSuite/Test_Ok"

        # test failure while trying to create/access S3 bucket
        "TestGetArtifactS3TestSuite/Test_Error"
        "TestGetArtifactS3TestSuite/Test_Ok"
        "TestListArtifactS3TestSuite/Test_Error"
        "TestListArtifactS3TestSuite/Test_Ok"

        # connect: network is unreachable
        "TestArtifactFlowTestSuite/Test_Ok/TestCustomNamespaces"
        "TestArtifactFlowTestSuite/Test_Ok/TestExplicitDefaultAndCustomNamespaces"
        "TestArtifactFlowTestSuite/Test_Ok/TestImplicitDefaultAndCustomNamespaces"
      ];
    in
    [ "-skip=^${builtins.concatStringsSep "$|^" skippedTests}$" ];

  postInstall = ''
    # we don't need this binary and it messes with our real python
    rm $out/bin/python
  '';

  meta = {
    description = "API for logging parameters and metrics when running machine learning code";
    homepage = "https://github.com/G-Research/fasttrackml";
    changelog = "https://github.com/G-Research/fasttrackml/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ jherland ];
    platforms = lib.platforms.unix;
    mainProgram = "fasttrackml";
  };
})

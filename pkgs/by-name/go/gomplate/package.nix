{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "gomplate";
  version = "4.3.2";

  src = fetchFromGitHub {
    owner = "hairyhenderson";
    repo = "gomplate";
    tag = "v${finalAttrs.version}";
    hash = "sha256-94zZuig/AN/UzZx66YbrkBX2Nq+/gPLXlcOz1ar8weE=";
  };

  vendorHash = "sha256-AS69mXZ5Faedj1cv7bfOfBfvdMQrCH1o9p6UN/O8ZLs=";

  ldflags = [
    "-s"
    "-X github.com/${finalAttrs.src.owner}/${finalAttrs.pname}/v4/version.Version=${finalAttrs.version}"
  ];

  preCheck = ''
    # some tests require network access
    rm net/net_test.go \
      internal/tests/integration/datasources_blob_test.go \
      internal/tests/integration/datasources_git_test.go \
      internal/tests/integration/test_ec2_utils_test.go \
      render_test.go
    # some tests rely on external tools we'd rather not depend on
    rm internal/tests/integration/datasources_consul_test.go \
      internal/tests/integration/datasources_vault*_test.go
  '';

  postInstall = ''
    rm $out/bin/gen
  '';

  meta = {
    description = "Flexible commandline tool for template rendering";
    mainProgram = "gomplate";
    homepage = "https://gomplate.ca/";
    changelog = "https://github.com/hairyhenderson/gomplate/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      ris
      jlesquembre
    ];
  };
})

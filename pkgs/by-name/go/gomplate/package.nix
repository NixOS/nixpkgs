{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "gomplate";
  version = "4.3.3";

  src = fetchFromGitHub {
    owner = "hairyhenderson";
    repo = "gomplate";
    tag = "v${finalAttrs.version}";
    hash = "sha256-LhCOpXptsZLoVXYH2u+YIXPlqNTMQ3tQt+KY8c54oA0=";
  };

  vendorHash = "sha256-lesPZAnN7K6hWYqAB69pGo4fVQAQH0VTh4DBtl2yhg8=";

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

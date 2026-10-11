{
  lib,
  buildGoLatestModule,
  fetchFromGitHub,
}:

buildGoLatestModule (finalAttrs: {
  pname = "octo-sts";
  version = "0.10.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "octo-sts";
    repo = "app";
    tag = "v${finalAttrs.version}";
    hash = "sha256-tG3/2ZP9OPzCRLi1FFDP+hs1bnLH71T4hgBwOtGaYvQ=";
  };

  vendorHash = "sha256-e6dSxVKXeF1LOb8tzFnbM3nXzT5KnpxG8H819W/pnLU=";

  # Upstream publishes container images for these two components.
  subPackages = [
    "cmd/app"
    "cmd/webhook"
  ];

  ldflags = [
    "-s"
    "-w"
  ];

  preCheck = ''
    # unset to run all tests
    unset subPackages
  '';

  # Requires network access to fetch OIDC discovery documents
  checkFlags = [ "-skip=^TestCompile$" ];

  __darwinAllowLocalNetworking = true;

  postInstall = ''
    mv $out/bin/app $out/bin/octo-sts
    mv $out/bin/webhook $out/bin/octo-sts-webhook
  '';

  meta = {
    description = "GitHub App that acts like a Security Token Service (STS) for the GitHub API";
    homepage = "https://github.com/octo-sts/app";
    changelog = "https://github.com/octo-sts/app/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ ytausch ];
    mainProgram = "octo-sts";
  };
})

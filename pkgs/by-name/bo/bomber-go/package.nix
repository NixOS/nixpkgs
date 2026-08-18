{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "bomber-go";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "devops-kung-fu";
    repo = "bomber";
    tag = "v${finalAttrs.version}";
    hash = "sha256-D3xs8lVhrRKVVQYzHN7CQNw5NTC+AxgsWvJxnV0lwGY=";
  };

  vendorHash = "sha256-mhGnuNuvMvX4WsqnS7QkWcrPfWEyaQsSKDUOpg9YrO8=";

  ldflags = [ "-s" ];

  nativeInstallCheckInputs = [ versionCheckHook ];

  checkFlags = [
    # Requires network access
    "-skip=TestEnrich|TestScanner_enrichVulnerabilities"
  ];

  doInstallCheck = true;

  meta = {
    description = "Tool to scans Software Bill of Materials (SBOMs) for vulnerabilities";
    homepage = "https://github.com/devops-kung-fu/bomber";
    changelog = "https://github.com/devops-kung-fu/bomber/releases/tag/v${finalAttrs.src.tag}";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "bomber";
  };
})

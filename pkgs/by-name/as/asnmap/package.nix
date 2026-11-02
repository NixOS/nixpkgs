{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
  writableTmpDirAsHomeHook,
}:

buildGoModule (finalAttrs: {
  pname = "asnmap";
  version = "1.2.0";

  __darwinAllowLocalNetworking = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "projectdiscovery";
    repo = "asnmap";
    tag = "v${finalAttrs.version}";
    hash = "sha256-4ra7Ex8ri5iRS+nBtCtFqsgaOxVaVPDIPFibom/aYqQ=";
  };

  vendorHash = "sha256-rSBznMd4lyXb1m06CCEMJdsmWWXY8ZxW1wTOugl9M18=";

  nativeInstallCheckInputs = [
    versionCheckHook
    writableTmpDirAsHomeHook
  ];

  ldflags = [ "-s" ];

  # Tests require network access
  doCheck = false;

  doInstallCheck = true;

  versionCheckKeepEnvironment = [ "HOME" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Tool to gather network ranges using ASN information";
    homepage = "https://github.com/projectdiscovery/asnmap";
    changelog = "https://github.com/projectdiscovery/asnmap/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "asnmap";
  };
})

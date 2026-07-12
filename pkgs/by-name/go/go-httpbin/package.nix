{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
  nixosTests,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "go-httpbin";
  version = "2.23.1";

  src = fetchFromGitHub {
    owner = "mccutchen";
    repo = "go-httpbin";
    tag = "v${finalAttrs.version}";
    hash = "sha256-IB+uqCt5kb08z2O8ex/npMjXIpUX8BQoME57Dd1b/9w=";
  };

  vendorHash = null;

  env.CGO_ENABLED = 0;

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${finalAttrs.version}"
  ];

  __darwinAllowLocalNetworking = true;

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru = {
    tests = { inherit (nixosTests) go-httpbin; };
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Reasonably complete and well-tested golang port of httpbin, with zero dependencies outside the go stdlib";
    homepage = "https://github.com/mccutchen/go-httpbin";
    changelog = "https://github.com/mccutchen/go-httpbin/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ defelo ];
    mainProgram = "go-httpbin";
  };
})

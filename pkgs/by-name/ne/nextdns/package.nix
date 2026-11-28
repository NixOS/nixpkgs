{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "nextdns";
  version = "1.50.2";

  __structuredAttrs = true;

  __darwinAllowLocalNetworking = true;

  src = fetchFromGitHub {
    owner = "nextdns";
    repo = "nextdns";
    tag = "v${finalAttrs.version}";
    hash = "sha256-RR63A3+RXlEodNl6Bn0KyYyZSgSjicLmfR8pbu5/eOk=";
  };

  vendorHash = "sha256-3Evnbwg3Q2SrmJUrPIEirMeHYnySofS4EEGvd7x6H7E=";

  ldflags = [
    "-s"
    "-X main.version=${finalAttrs.version}"
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "version";

  meta = {
    description = "NextDNS DNS/53 to DoH Proxy";
    homepage = "https://nextdns.io";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      pnelson
      stepbrobd
    ];
    mainProgram = "nextdns";
  };
})

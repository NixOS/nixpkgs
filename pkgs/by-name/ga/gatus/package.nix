{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
}:

buildGoModule (finalAttrs: {
  pname = "gatus";
  version = "5.35.0";

  src = fetchFromGitHub {
    owner = "TwiN";
    repo = "gatus";
    rev = "v${finalAttrs.version}";
    hash = "sha256-I1HjeJ4/yLLgcoIEOQCv3WQDNrpIAFhzDvVpz24T7gU=";
  };

  vendorHash = "sha256-PBy/0My0TdlolpagDSdt7r2dPPLJOVHEsU1xaV8RFjg=";

  subPackages = [ "." ];

  passthru.tests = {
    inherit (nixosTests) gatus;
  };

  meta = {
    description = "Automated developer-oriented status page";
    homepage = "https://gatus.io";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ undefined-moe ];
    mainProgram = "gatus";
  };
})

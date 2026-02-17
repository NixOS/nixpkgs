{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
}:

buildGoModule (finalAttrs: {
  pname = "gatus";
  version = "5.34.0";

  src = fetchFromGitHub {
    owner = "TwiN";
    repo = "gatus";
    rev = "v${finalAttrs.version}";
    hash = "sha256-+Ulttz13SzPnB+EFsyK2H/bv2vXn+uA/zv6UY9HKrgY=";
  };

  vendorHash = "sha256-xN38oaMcErkq4FtWi/Kzp9fhC5dk8CeJYehlwtVgf0M=";

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

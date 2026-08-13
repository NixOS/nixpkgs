{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
}:

buildGoModule (finalAttrs: {
  pname = "snid";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "AGWA";
    repo = "snid";
    tag = "v${finalAttrs.version}";
    hash = "sha256-syKEtG/B1Yy0BAQqlR6o4uIRSwCnFOBsPpV4arqO/I4=";
  };

  vendorHash = "sha256-cVarG6Tx4yWpZE5BLZsMtLV9LF1lsiFfIXxhYiNjQlY=";

  passthru = {
    tests.nixos = nixosTests.snid;
    services.default = {
      imports = [ (lib.modules.importApply ./service.nix { }) ];
      snid.package = finalAttrs.finalPackage;
    };
  };

  meta = {
    description = "Zero config TLS proxy server that uses SNI";
    homepage = "https://github.com/AGWA/snid";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ tomfitzhenry ];
    mainProgram = "snid";
  };
})

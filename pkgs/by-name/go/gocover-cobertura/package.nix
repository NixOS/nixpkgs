{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "gocover-cobertura";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "boumenot";
    repo = "gocover-cobertura";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-9KYNK6YV+iYB5Mmporzzw0aYTPCanvX7JALoP72dMtU=";
  };

  deleteVendor = true;
  vendorHash = "sha256-tPCiU7UVltYaHM1JVRje6EeG6Thn+3qm5I3MjKvD1/o=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    description = "Simple helper tool for generating XML output in Cobertura format for CIs like Jenkins and others from go tool cover output";
    homepage = "https://github.com/boumenot/gocover-cobertura";
    license = lib.licenses.mit;
    mainProgram = "gocover-cobertura";
    maintainers = with lib.maintainers; [
      gabyx
      hmajid2301
    ];
  };
})

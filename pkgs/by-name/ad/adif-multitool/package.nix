{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule (finalAttrs: {
  pname = "adif-multitool";
  version = "0.1.20";

  vendorHash = "sha256-U9BpTDHjUZicMjKeyxyM/eOxJeAY2DMQMHOEMiCeN/U=";

  src = fetchFromGitHub {
    owner = "flwyd";
    repo = "adif-multitool";
    tag = "v${finalAttrs.version}";
    hash = "sha256-qeAH8UTyEZn8As3wTjluONpjeT/5l9zicN5+8uwnbLo=";
  };

  meta = {
    description = "Command-line program for working with ham logfiles";
    homepage = "https://github.com/flwyd/adif-multitool";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ mafo ];
    mainProgram = "adifmt";
  };
})

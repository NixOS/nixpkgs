{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "adif-multitool";
  version = "0.1.20";

  vendorHash = "sha256-U9BpTDHjUZicMjKeyxyM/eOxJeAY2DMQMHOEMiCeN/U=";

  src = fetchFromGitHub {
    owner = "flwyd";
    repo = "adif-multitool";
    tag = "v${version}";
    hash = "sha256-qeAH8UTyEZn8As3wTjluONpjeT/5l9zicN5+8uwnbLo=";
  };

  meta = with lib; {
    description = "Command-line program for working with ham logfiles";
    homepage = "https://github.com/flwyd/adif-multitool";
    license = licenses.asl20;
    maintainers = with maintainers; [ mafo ];
    mainProgram = "adifmt";
  };
}

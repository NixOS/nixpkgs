{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "adif-multitool";
  version = "0.1.18";

  vendorHash = "sha256-U9BpTDHjUZicMjKeyxyM/eOxJeAY2DMQMHOEMiCeN/U=";

  src = fetchFromGitHub {
    owner = "flwyd";
    repo = "adif-multitool";
    rev = "v${version}";
    hash = "sha256-GH35dcSjoOTaQiA4j9F5fbz3XStkjlKA0he7msaJHD8=";
  };

  meta = {
    description = "Command-line program for working with ham logfiles.";
    homepage = "https://github.com/flwyd/adif-multitool";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ mafo ];
    mainProgram = "adifmt";
  };
}

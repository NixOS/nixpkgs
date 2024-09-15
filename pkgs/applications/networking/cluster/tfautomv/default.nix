{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "tfautomv";
  version = "0.6.2";

  src = fetchFromGitHub {
    owner = "busser";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-qUeIbHJqxGkt2esMm4w6fM52ZE16jWnxugVXxqBh1Qc=";
  };

  # checks require unfree programs like terraform/terragrunt
  doCheck = false;

  vendorHash = "sha256-BZ8IhVPxZTPQXBotFBrxV3dfwvst0te8R84I/urq3gY=";

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    homepage = "https://github.com/busser/tfautomv";
    description = "When refactoring a Terraform codebase, you often need to write moved blocks. This can be tedious. Let tfautomv do it for you";
    mainProgram = "tfautomv";
    license = licenses.asl20;
    maintainers = with maintainers; [ qjoly ];
  };
}

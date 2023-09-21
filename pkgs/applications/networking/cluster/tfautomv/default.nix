{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "tfautomv";
  version = "0.5.3";

  src = fetchFromGitHub {
    owner = "busser";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-A1/sf+QjxQ8S2Cqmw9mD0r4aqA2Ssopeni0YNLND9L8=";
  };

  vendorHash = "sha256-zAshnSqZT9lx9EWvJsMwi6rqvhUWJ/3uJnk+44TGzlU=";

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    homepage = "https://github.com/busser/tfautomv";
    description = "When refactoring a Terraform codebase, you often need to write moved blocks. This can be tedious. Let tfautomv do it for you";
    license = licenses.asl20;
    maintainers = with maintainers; [ qjoly ];
  };
}

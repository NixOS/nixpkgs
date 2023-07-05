{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "tfautomv";
  version = "0.5.2";

  src = fetchFromGitHub {
    owner = "busser";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-/Pli1gTG/68BtPdvF+BAwxFaeBrjj69h6Mtcbfm7UZ8=";
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

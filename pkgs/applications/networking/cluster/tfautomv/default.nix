{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "tfautomv";
<<<<<<< HEAD
  version = "0.5.3";

  src = fetchFromGitHub {
    owner = "busser";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-A1/sf+QjxQ8S2Cqmw9mD0r4aqA2Ssopeni0YNLND9L8=";
  };

  vendorHash = "sha256-zAshnSqZT9lx9EWvJsMwi6rqvhUWJ/3uJnk+44TGzlU=";
=======
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "padok-team";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-shpoi/N/gfzisjj1tvZGSEuorqaoOJMhYOjx+Y8F/Ds=";
  };

  vendorHash = "sha256-BjmtUamecTSwT7gHM/6uz1r/P8O0TWzp9Dk43rdmxXU=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
<<<<<<< HEAD
    homepage = "https://github.com/busser/tfautomv";
=======
    homepage = "https://github.com/padok-team/tfautomv";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    description = "When refactoring a Terraform codebase, you often need to write moved blocks. This can be tedious. Let tfautomv do it for you";
    license = licenses.asl20;
    maintainers = with maintainers; [ qjoly ];
  };
}

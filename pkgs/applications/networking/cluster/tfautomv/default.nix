{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "tfautomv";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "padok-team";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-shpoi/N/gfzisjj1tvZGSEuorqaoOJMhYOjx+Y8F/Ds=";
  };

  vendorHash = "sha256-BjmtUamecTSwT7gHM/6uz1r/P8O0TWzp9Dk43rdmxXU=";

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    homepage = "https://github.com/padok-team/tfautomv";
    description = "When refactoring a Terraform codebase, you often need to write moved blocks. This can be tedious. Let tfautomv do it for you";
    license = licenses.asl20;
    maintainers = with maintainers; [ qjoly ];
  };
}

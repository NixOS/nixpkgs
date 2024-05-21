{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "nilaway";
  version = "0-unstable-2024-04-04";

  src = fetchFromGitHub {
    owner = "uber-go";
    repo = "nilaway";
    rev = "755a685ab68b85d9b36833b38972a559f217d396";
    hash = "sha256-sDDBITrGD79pcbsrcrs6D8njBp4kuK1NkuBPwzIkaUE=";
  };

  vendorHash = "sha256-1j7NwfqrinEQL6XBO0PvwzxFytujoCtynMEXL2oTLkM=";

  excludedPackages = [ "tools" ];

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    description = "Static Analysis tool to detect potential Nil panics in Go code";
    homepage = "https://github.com/uber-go/nilaway";
    license = licenses.asl20;
    maintainers = with maintainers; [ prit342 jk ];
    mainProgram = "nilaway";
  };
}

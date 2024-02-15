{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "nilaway";
  version = "unstable-2023-11-17";

  src = fetchFromGitHub {
    owner = "uber-go";
    repo = "nilaway";
    rev = "a267567c6ffff900df0c3394d031ee70079ec8df";
    hash = "sha256-Ro1nSTEZcE9u4Ol6CSLBTiPrh72Ly9UcrXyvffzPfow=";
  };

  vendorHash = "sha256-kbVjkWW5D8jp5QFYGiyRuGFArRsQukJIR8xwaUUIUBs=";

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    description = "Static Analysis tool to detect potential Nil panics in Go code";
    homepage = "https://github.com/uber-go/nilaway";
    license = licenses.asl20;
    maintainers = with maintainers; [ prit342 jk ];
    mainProgram = "nilaway";
  };
}

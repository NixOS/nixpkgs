{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule {
  pname = "nilaway";
  version = "0-unstable-2025-03-07";

  src = fetchFromGitHub {
    owner = "uber-go";
    repo = "nilaway";
    rev = "19305c7c699bd0d370acd26d6769df1d7af8fb29";
    hash = "sha256-99L9dF76vZbh1NdXtKu5Bcnnca94Roybm3q18SDmZAk=";
  };

  vendorHash = "sha256-pthCLpy5pISKwdmeaJxPq8BxJLUwLwS2/hGMBt6/O4I=";

  subPackages = [ "cmd/nilaway" ];
  excludedPackages = [ "tools" ];

  ldflags = [
    "-s"
    "-w"
  ];

  preCheck = ''
    # test all paths
    unset subPackages
  '';

  meta = with lib; {
    description = "Static Analysis tool to detect potential Nil panics in Go code";
    homepage = "https://github.com/uber-go/nilaway";
    license = licenses.asl20;
    maintainers = with maintainers; [
      prit342
      jk
    ];
    mainProgram = "nilaway";
  };
}

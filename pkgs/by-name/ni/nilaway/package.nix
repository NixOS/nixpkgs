{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "nilaway";
  version = "0-unstable-2024-06-29";

  src = fetchFromGitHub {
    owner = "uber-go";
    repo = "nilaway";
    rev = "e90288479601315af13b7fdd3ccd6b50c53a8e7c";
    hash = "sha256-6bArrCcAZc8DWJlDxKKmlHAbcEuU68HgqJTK9s7ZGig=";
  };

  vendorHash = "sha256-rLyU2HdlkDFh+MBIVnbEIIlVR7/mq9heZWzN7GRw0Dc=";

  excludedPackages = [ "tools" ];

  ldflags = [
    "-s"
    "-w"
  ];

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

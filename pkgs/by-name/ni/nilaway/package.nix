{
  lib,
  buildGoModule,
  fetchFromGitHub,

  unstableGitUpdater,
}:

buildGoModule {
  pname = "nilaway";
  version = "0-unstable-2026-09-18";

  src = fetchFromGitHub {
    owner = "uber-go";
    repo = "nilaway";
    rev = "acb8859b9031bb9496be97e027df5573f9fb5340";
    hash = "sha256-GvDZ5tlvOrTI93tYcIcLd45ZHdqwFopVtoBffD/kbuM=";
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

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    description = "Static Analysis tool to detect potential Nil panics in Go code";
    homepage = "https://github.com/uber-go/nilaway";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      prit342
      jk
    ];
    mainProgram = "nilaway";
  };
}

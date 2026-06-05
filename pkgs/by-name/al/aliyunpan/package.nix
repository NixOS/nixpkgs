{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "aliyunpan";
  version = "0.3.9";

  src = fetchFromGitHub {
    owner = "tickstep";
    repo = "aliyunpan";
    tag = "v${finalAttrs.version}";
    hash = "sha256-inkden/ZiIxJVZLhM6OVTV4qbesEPJbX2sn4LNZF+FE=";
  };

  vendorHash = "sha256-PKx40HqXm1nyqjNBSJdW5ucRAkMj9w3fbQYjAGALM1k=";

  ldflags = [
    "-s"
    "-w"
    "-X main.Version=v${finalAttrs.version}"
  ];

  # skip test
  checkFlags =
    let
      skippedTests = [
        # require network access
        "TestGetQRCodeLoginResult"
        # depend specific local file
        "TestBoltUltraFiles"
        "TestLocalSyncDb"
        "TestLocalGet"
      ];
    in
    [ "-skip=^${builtins.concatStringsSep "$|^" skippedTests}$" ];

  postInstall = ''
    mkdir -p "$out/share/doc/aliyunpan"
    cp README.md "$out/share/doc/aliyunpan/"
    cp docs/manual.md "$out/share/doc/aliyunpan/"
    cp docs/plugin_manual.md "$out/share/doc/aliyunpan/"
  '';

  meta = {
    description = "Command line client for Aliyun Drive";
    homepage = "https://github.com/tickstep/aliyunpan";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ xiangpingjiang ];
    mainProgram = "aliyunpan";
  };
})

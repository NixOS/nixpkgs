{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "aliyunpan";
  version = "0.3.8";

  src = fetchFromGitHub {
    owner = "tickstep";
    repo = "aliyunpan";
    tag = "v${finalAttrs.version}";
    hash = "sha256-6aukI4woQvNI8zcstF92VL7M70GKAiwj9viaTX3iJ2o=";
  };

  vendorHash = "sha256-or1C88KE0RkXL08ZjaXELqKlNP3PoY31ib4PWDdDmNA=";

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

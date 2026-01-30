{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "aliyunpan";
  version = "0.3.7";

  src = fetchFromGitHub {
    owner = "tickstep";
    repo = "aliyunpan";
    tag = "v${finalAttrs.version}";
    hash = "sha256-9sbAKv2SOZPKnP56vL0rfMEDhTpIV524s9sIvlWAM6o=";
  };

  vendorHash = "sha256-tNUXB+pU/0gJL3oG9rdk6J+SvO5ASqkuO+gVZiRdaVg=";

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

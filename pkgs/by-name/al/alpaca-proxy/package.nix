{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule (finalAttrs: {
  pname = "alpaca-proxy";
  version = "2.0.13";

  src = fetchFromGitHub {
    owner = "samuong";
    repo = "alpaca";
    tag = "v${finalAttrs.version}";
    hash = "sha256-dzTWruf/1eU34UeLzZkTSxbAqhCfxRuXMPYuKPGImUc=";
  };

  vendorHash = "sha256-pxCMomMmHqPWdjLi7C4LfcjbgdjMzJVvyhOd1YmHWTU=";

  ldflags = [
    "-s"
    "-w"
    "-X=main.BuildVersion=v${finalAttrs.version}"
  ];

  postInstall = ''
    # executable is renamed to alpaca-proxy, to avoid collision with the alpaca python application
    mv $out/bin/alpaca $out/bin/alpaca-proxy
  '';

  meta = {
    description = "HTTP forward proxy with PAC and NTLM authentication support";
    homepage = "https://github.com/samuong/alpaca";
    changelog = "https://github.com/samuong/alpaca/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    maintainers = with lib.maintainers; [ _1nv0k32 ];
    mainProgram = "alpaca-proxy";
  };
})

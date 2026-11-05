{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "pingtunnel";
  version = "3.1";

  src = fetchFromGitHub {
    owner = "esrrhs";
    repo = "pingtunnel";
    rev = finalAttrs.version;
    hash = "sha256-epqj2BBGFLOR1vej0V0SqeoQKH1JTd+qj0EV/uixO20=";
  };

  vendorHash = "sha256-VZWDjZ8JB1Ao7SeqD/W/Bol/YXJd5N4Iy6A4jCt4p2U=";

  nativeInstallCheckInputs = [ versionCheckHook ];

  ldflags = [ "-s" ];

  postInstall = ''
    mv $out/bin/cmd $out/bin/pingtunnel
  '';

  doInstallCheck = true;

  versionCheckProgramArg = [ "-v" ];

  __darwinAllowLocalNetworking = true;

  meta = {
    description = "Tool that send TCP/UDP traffic over ICMP";
    homepage = "https://github.com/esrrhs/pingtunnel";
    changelog = "https://github.com/esrrhs/pingtunnel/releases/tag/v${finalAttrs.src.rev}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ oluceps ];
    mainProgram = "pingtunnel";
  };
})

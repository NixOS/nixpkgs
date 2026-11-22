{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "api-linter";
  version = "2.4.1";

  src = fetchFromGitHub {
    owner = "googleapis";
    repo = "api-linter";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ov3CuG35j7BwgyaQ7Bh7btmpNdH0g/PPse2A8NtBL18=";
  };

  vendorHash = "sha256-NKhNc+2RxAhLplaJSgFinCBl+cPZbhGMdv4ZvNojD3o=";

  subPackages = [ "cmd/api-linter" ];

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    description = "Linter for APIs defined in protocol buffers";
    homepage = "https://github.com/googleapis/api-linter/";
    changelog = "https://github.com/googleapis/api-linter/releases/tag/${finalAttrs.src.rev}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ xrelkd ];
    mainProgram = "api-linter";
  };
})

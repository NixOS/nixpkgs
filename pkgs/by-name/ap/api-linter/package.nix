{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "api-linter";
  version = "2.3.1";

  src = fetchFromGitHub {
    owner = "googleapis";
    repo = "api-linter";
    tag = "v${finalAttrs.version}";
    hash = "sha256-xks5oKfJSMV4MbPFrYGWv82XeBLYbGgXF4r4kbFX93Q=";
  };

  vendorHash = "sha256-wPySRFqm396YRqEUZNMkA19SxqBNApwr8hm0PRA5cO0=";

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

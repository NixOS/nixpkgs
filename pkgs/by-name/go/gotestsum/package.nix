{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:
buildGoModule (finalAttrs: {
  pname = "gotestsum";
  version = "1.12.3";

  src = fetchFromGitHub {
    owner = "gotestyourself";
    repo = "gotestsum";
    tag = "v${finalAttrs.version}";
    hash = "sha256-j8lB0TIHK8/yMzaTB5OOaboEtnB6IsTybz8sJbNoQt4=";
  };

  vendorHash = "sha256-UInHqKzntK0fYsUKZ2jW4akymeRd3sMQKf8+//TQb7g=";

  doCheck = false;

  ldflags = [
    "-s"
    "-w"
    "-X gotest.tools/gotestsum/cmd.version=${finalAttrs.version}"
  ];

  subPackages = [ "." ];

  meta = {
    homepage = "https://github.com/gotestyourself/gotestsum";
    changelog = "https://github.com/gotestyourself/gotestsum/releases/tag/v${finalAttrs.version}";
    description = "Human friendly `go test` runner";
    mainProgram = "gotestsum";
    platforms = with lib.platforms; linux ++ darwin;
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ isabelroses ];
  };
})

{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:
buildGoModule (finalAttrs: {
  pname = "gotestsum";
  version = "1.12.1";

  src = fetchFromGitHub {
    owner = "gotestyourself";
    repo = "gotestsum";
    tag = "v${finalAttrs.version}";
    hash = "sha256-nIdGon14bAaSxUmJNlpLztQVbA8SJ76+Ve46gbM0awk=";
  };

  vendorHash = "sha256-x48jjd6cIX/M8U+5QwrKalt1iLgeQKeJItLJsxXrPgY=";

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

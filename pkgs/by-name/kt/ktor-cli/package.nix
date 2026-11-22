{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "ktor-cli";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "ktorio";
    repo = "ktor-cli";
    tag = finalAttrs.version;
    hash = "sha256-okw/h/q+7t1WFKjsVej3aChaLf9PC1ovKcwRYDSODz0=";
  };

  subPackages = "cmd/ktor";

  vendorHash = "sha256-Cv/Jq4dWVzotfCCclrwufmC0I2pgPe/YHKWqcLzjt2E=";

  ldflags = [
    "-s"
    "-w"
    "-X main.Version=${finalAttrs.version}"
  ];

  meta = {
    description = "Command-line tool for creating Ktor projects";
    homepage = "https://github.com/ktorio/ktor-cli";
    changelog = "https://github.com/ktorio/ktor-cli/releases/tag/${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ nartsiss ];
    mainProgram = "ktor";
  };
})

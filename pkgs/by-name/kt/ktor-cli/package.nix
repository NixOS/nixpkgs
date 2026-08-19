{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "ktor-cli";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "ktorio";
    repo = "ktor-cli";
    tag = finalAttrs.version;
    hash = "sha256-DZEEaTz55vIBU8Byl51cEWgXu2Wjmctz/9XBAKX8VKY=";
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

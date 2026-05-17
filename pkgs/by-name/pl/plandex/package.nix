{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule (finalAttrs: {
  pname = "plandex";
  version = "2.2.1";

  src = fetchFromGitHub {
    owner = "plandex-ai";
    repo = "plandex";
    rev = "cli/v${finalAttrs.version}";
    hash = "sha256-JfmKuney9VLoh3XQ9TNydUmiFne+SHWhoNKB15GPVPM=";
  };

  ldflags = [
    "-X plandex-cli/version.Version=${finalAttrs.version}"
  ];

  sourceRoot = "${finalAttrs.src.name}/app/cli";

  vendorHash = "sha256-K6KzOxiXZY9cuCh6mTYZ/QNh+yV4y5cQk2xjL3YMLQo=";

  meta = {
    mainProgram = "plandex";
    description = "AI driven development in your terminal. Designed for large, real-world tasks. The cli part";
    homepage = "https://plandex.ai/";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ viraptor ];
  };
})

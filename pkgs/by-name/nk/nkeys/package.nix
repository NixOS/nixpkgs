{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "nkeys";
  version = "0.4.17";

  src = fetchFromGitHub {
    owner = "nats-io";
    repo = "nkeys";
    tag = "v${finalAttrs.version}";
    hash = "sha256-kBkd9PTmkZn5hBmtPIufFzV0ER32BdofHut1iyxNrL4=";
  };

  vendorHash = "sha256-WszCsYEK0xOuSNI3UxJJLWKus8viVREaNj4xVQY6eBM=";

  meta = {
    description = "Public-key signature system for NATS";
    homepage = "https://github.com/nats-io/nkeys";
    changelog = "https://github.com/nats-io/nkeys/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "nk";
  };
})

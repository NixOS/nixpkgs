{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "nkeys";
  version = "0.4.16";

  src = fetchFromGitHub {
    owner = "nats-io";
    repo = "nkeys";
    tag = "v${finalAttrs.version}";
    hash = "sha256-GR1OvyA8bjZRTPTn12izxQXjACIaXFbGsSquHucusRY=";
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

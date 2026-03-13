{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "nkeys";
  version = "0.4.15";

  src = fetchFromGitHub {
    owner = "nats-io";
    repo = "nkeys";
    tag = "v${finalAttrs.version}";
    hash = "sha256-hlVPfL3ecEmqXRsV3skiOD7B1s2a0ZZ5RX6LV6ISEWI=";
  };

  vendorHash = "sha256-3gyWzCYpkXnEURKB05GtGJxDMk6oIzWS4u3U5OUd3p4=";

  meta = {
    description = "Public-key signature system for NATS";
    homepage = "https://github.com/nats-io/nkeys";
    changelog = "https://github.com/nats-io/nkeys/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "nk";
  };
})

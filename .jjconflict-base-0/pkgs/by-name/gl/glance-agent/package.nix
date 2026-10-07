{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:
buildGoModule (finalAttrs: {
  pname = "glance-agent";
  version = "0.1.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "glanceapp";
    repo = "agent";
    tag = "v${finalAttrs.version}";
    hash = "sha256-eNhOelHR3EB3RWWMe7fG6vklgADX7XFy6QMI4Lfr8oM=";
  };

  vendorHash = "sha256-vjcyZctfgnAhzFEF0c+GhtWQqa4gVvLLj0E3sCLS0RE=";

  ldflags = [
    "-s"
    "-X github.com/glanceapp/agent/internal/agent.buildVersion=${finalAttrs.version}"
  ];

  meta = {
    homepage = "https://github.com/glanceapp/agent";
    description = "Lightweight service that exposes system metrics via an HTTP API";
    license = lib.licenses.gpl3Only;
    mainProgram = "agent";
    maintainers = with lib.maintainers; [ yarn ];
  };
})

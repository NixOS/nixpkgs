{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "go-ecoflow-exporter";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "tess1o";
    repo = "go-ecoflow-exporter";
    tag = finalAttrs.version;
    hash = "sha256-E28FKSRGStZC2daHQ5snWNonH27W3J3n6JnVv0WfH/I=";
  };

  vendorHash = "sha256-A6mA0sJ5+QXEA6aRuVSwcfZVF3fYo1xXJgeHQcHzfVw=";

  ldflags = [
    "-s"
    "-w"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/tess1o/go-ecoflow-exporter/releases/tag/${finalAttrs.version}";
    homepage = "https://github.com/tess1o/go-ecoflow-exporter";
    description = "Ecoflow solar battery mqtt timescale, redis, prometheus metrics exporter";
    license = lib.licenses.mit;
    mainProgram = "go-ecoflow-exporter";
    maintainers = with lib.maintainers; [ paepcke ];
  };
})

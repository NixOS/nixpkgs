{
  lib,
  buildGoModule,
  fetchFromForgejo,
}:

buildGoModule (finalAttrs: {
  pname = "composia";
  version = "0.2.1";

  __structuredAttrs = true;

  src = fetchFromForgejo {
    domain = "forgejo.alexma.top";
    owner = "alexma233";
    repo = "composia";
    tag = "v${finalAttrs.version}";
    hash = "sha256-h5Smj0C+6ysO8Iwh0owkdo0FCkBgkKlxpBlCdMftkhw=";
  };

  vendorHash = "sha256-mLhKepFDJSaaRL1HV+Uf3gcFPS/YZrHL8z8Qw3zd6es=";

  subPackages = "cmd/composia cmd/composia-controller cmd/composia-agent";

  ldflags = [
    "-s"
    "-w"
    "-X forgejo.alexma.top/alexma233/composia/internal/version.Value=${finalAttrs.version}"
  ];

  meta = {
    description = "Self-hosted Docker Compose control plane and CLI";
    homepage = "https://docs.composia.xyz";
    changelog = "https://forgejo.alexma.top/alexma233/composia/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ alexma233 ];
    mainProgram = "composia";
    platforms = lib.platforms.linux;
  };
})

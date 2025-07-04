{
  lib,
  buildGoModule,
  fetchgit,
}:
buildGoModule {
  pname = "kontemplate";
  version = "1.8.0-unstable-2024-06-09";

  src = fetchgit {
    url = "https://code.tvl.fyi/depot.git";
    hash = "sha256-Cv/y1Tj+hUKP0gi9ceS1Gml1WRYbUGSeWfJfXyX6dLA=";
    rev = "b16ddb54b0327606cec2df220eaabb1328e18e3e";
  };

  modRoot = "ops/kontemplate";

  vendorHash = "sha256-xPGVM2dq5fAVOiuodOXhDm3v3k+ncNLhlk6aCtF5S9E=";

  meta = {
    description = "Extremely simple Kubernetes resource templates";
    mainProgram = "kontemplate";
    homepage = "https://code.tvl.fyi/about/ops/kontemplate";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [
      mbode
      tazjin
    ];
    platforms = lib.platforms.unix;

    longDescription = ''
      Kontemplate is a simple CLI tool that can take sets of
      Kubernetes resource files with placeholders and insert values
      per environment.

      It can be used as a simple way of deploying the same set of
      resources to different Kubernetes contexts with context-specific
      configuration.
    '';
  };
}

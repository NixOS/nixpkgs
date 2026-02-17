{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:

buildGoModule (finalAttrs: {
  pname = "grizzly";
  version = "0.7.1";

  src = fetchFromGitHub {
    owner = "grafana";
    repo = "grizzly";
    rev = "v${finalAttrs.version}";
    hash = "sha256-1caG2QIBfbCgg9TLsW4XB0w+4dqUkQEsdWwRazbWeQA=";
  };

  vendorHash = "sha256-JxYafSralKqd/AB6fhTuQvt0q+/Zeu7dmZwVAAkolxY=";

  subPackages = [ "cmd/grr" ];

  meta = {
    description = "Utility for managing Jsonnet dashboards against the Grafana API";
    homepage = "https://grafana.github.io/grizzly/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ nrhtr ];
    platforms = lib.platforms.unix;
    mainProgram = "grr";
  };
})

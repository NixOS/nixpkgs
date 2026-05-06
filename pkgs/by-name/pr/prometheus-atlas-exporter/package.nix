{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "atlas-exporter";
  version = "1.0.5";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "czerwonk";
    repo = "atlas_exporter";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-GvjZhQsKR0qqSnfHarLct1z5BdusvODLnVxOtZCLAXo=";
  };

  vendorHash = "sha256-Wq1rMkKfGiLG3qIL51VZoUWIsb3ANs1p81g94iYNJwE=";

  meta = {
    description = "Prometheus exporter for RIPE Atlas measurement results";
    mainProgram = "atlas_exporter";
    homepage = "https://github.com/czerwonk/atlas_exporter";
    license = lib.licenses.lgpl3;
    maintainers = with lib.maintainers; [ clerie ];
  };
})

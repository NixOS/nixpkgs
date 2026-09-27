{
  lib,
  rustPlatform,
  fetchFromGitHub,
  withJson ? true,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "statix";
  version = "0.5.8-unstable-2026-07-17";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "molybdenumsoftware";
    repo = "statix";
    rev = "52530001bdbc8e94aae0d406a929c7ad7f09d9d1";
    hash = "sha256-5GBxiBDnhGJUCWc4Fc6YgODcJkUepV8dP/tY+lSrC5I=";
  };

  cargoHash = "sha256-E3/G8kVHFexNebkDXtDR5rucGRfmpUw6/At1/DDgBdQ=";

  buildFeatures = lib.optional withJson "json";

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version=branch" ];
  };

  meta = {
    description = "Lints and suggestions for the nix programming language";
    homepage = "https://github.com/molybdenumsoftware/statix";
    license = lib.licenses.mit;
    mainProgram = "statix";
    maintainers = with lib.maintainers; [
      mightyiam
      nerdypepper
      progrm_jarvis
    ];
  };
})

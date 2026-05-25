{
  lib,
  rustPlatform,
  fetchCrate,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "mandown";
  version = "1.1.0";

  src = fetchCrate {
    inherit (finalAttrs) pname version;
    hash = "sha256-a+1tm9YlBuroTtgCL0nTjASaPiJHif89pRH0CWw7RjM=";
  };

  cargoHash = "sha256-ZyjoAvsqUyHgfEsG3+CvJatmBt0AJ2ga6HRJ8Y7her0=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Markdown to groff (man page) converter";
    homepage = "https://gitlab.com/kornelski/mandown";
    license = with lib.licenses; [
      asl20 # or
      mit
    ];
    maintainers = [ lib.maintainers.da157 ];
    mainProgram = "mandown";
  };
})

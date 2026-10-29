{
  lib,
  fetchCrate,
  rustPlatform,
  pkg-config,
  libgit2,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "starship-jj";
  version = "0.7.0";

  src = fetchCrate {
    inherit (finalAttrs) pname version;
    hash = "sha256-oisz3V3UDHvmvbA7+t5j7waN9NykMUWGOpEB5EkmYew=";
  };

  env.LIBGIT2_NO_VENDOR = 1;

  cargoHash = "sha256-NNeovW27YSK/fO2DjAsJqBvebd43usCw7ni47cgTth8=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ libgit2 ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Starship plugin for jj";
    homepage = "https://gitlab.com/lanastara_foss/starship-jj";
    changelog = "https://gitlab.com/lanastara_foss/starship-jj/-/blob/${finalAttrs.version}/CHANGELOG.md";
    maintainers = with lib.maintainers; [
      nemith
    ];
    license = lib.licenses.mit;
    mainProgram = "starship-jj";
  };
})

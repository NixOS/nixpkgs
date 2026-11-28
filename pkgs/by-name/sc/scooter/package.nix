{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  oniguruma,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "scooter";
  version = "0.10.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "thomasschafer";
    repo = "scooter";
    tag = "v${finalAttrs.version}";
    hash = "sha256-cUnHwwJHi/m/xm8fMMmdm4IkcC648BHPzK/QvKadz5o=";
  };

  cargoHash = "sha256-ktrGw48yzcjqbNgK48iPjYZMsUEPrXvyWMVS62Xt1rA=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ oniguruma ];

  # Ensure that only the `scooter` package is built (excluding `xtask`)
  cargoBuildFlags = [
    "--package"
    "scooter"
  ];

  # Many tests require filesystem writes which fail in Nix sandbox
  doCheck = false;

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  meta = {
    description = "Interactive find and replace in the terminal";
    homepage = "https://github.com/thomasschafer/scooter";
    changelog = "https://github.com/thomasschafer/scooter/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ felixzieger ];
    mainProgram = "scooter";
  };
})

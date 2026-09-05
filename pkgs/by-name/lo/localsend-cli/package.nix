{
  lib,
  rustPlatform,
  fetchFromGitHub,
  cacert,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "localsend-cli";
  version = "1.18.1";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "localsend";
    repo = "localsend";
    tag = "v${finalAttrs.version}";
    hash = "sha256-uxMfO39U0cC7Svf8QL4WUJJowuwmTjChrZ4VOWcgb4E=";
  };

  cargoHash = "sha256-khnrHc/88j+JG3sSKvNUsu6JcrM83zIt+W3tT7dz2Ac=";

  cargoBuildFlags = [
    "--package"
    "localsend-cli"
  ];

  checkInputs = [
    cacert
  ];

  __darwinAllowLocalNetworking = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Open source cross-platform alternative to AirDrop (cli version)";
    homepage = "https://github.com/localsend/localsend";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ zendo ];
    mainProgram = "localsend-cli";
  };
})

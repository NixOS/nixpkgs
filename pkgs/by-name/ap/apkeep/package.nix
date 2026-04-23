{
  lib,
  fetchCrate,
  rustPlatform,
  openssl,
  pkg-config,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "apkeep";
  version = "0.18.0";

  src = fetchCrate {
    inherit (finalAttrs) pname version;
    hash = "sha256-Sk8CQaMXtPPJh2nGgGthyzuvkVViQ0jtqPjAqo2dtpg=";
  };

  cargoHash = "sha256-PTuhD73R0AxykkVeFEHaVnXrOTHJoRl0CxBJmeh3WgQ=";

  prePatch = ''
    rm .cargo/config.toml
  '';

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
  ];

  meta = {
    description = "Command-line tool for downloading APK files from various sources";
    homepage = "https://github.com/EFForg/apkeep";
    changelog = "https://github.com/EFForg/apkeep/blob/${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = [ ];
    mainProgram = "apkeep";
  };
})

{
  lib,
  fetchCrate,
  rustPlatform,
  openssl,
  pkg-config,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "apkeep";
  version = "1.0.0";

  src = fetchCrate {
    inherit (finalAttrs) pname version;
    hash = "sha256-UFkcncZJlqNa3vvrKGxpF3FSfEB4I16taJcS9RJFdrA=";
  };

  cargoHash = "sha256-tB7kOAJ8TzuXfks//v0ghFbezCqxjy//Ow1Xvt4rA8o=";

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

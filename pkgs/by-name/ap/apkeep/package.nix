{
  lib,
  fetchCrate,
  rustPlatform,
  openssl,
  pkg-config,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "apkeep";
  version = "1.1.0";

  src = fetchCrate {
    inherit (finalAttrs) pname version;
    hash = "sha256-fc7evdDy6HlAWMS/RIaO4qA2eNsgcW7ol63JIXYllOQ=";
  };

  cargoHash = "sha256-f18BuiZuhIXizdMKZQmTQJOdv0UvcBYwxbeqewg+sQ8=";

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

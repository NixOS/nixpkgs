{
  lib,
  rustPlatform,
  fetchCrate,
}:
rustPlatform.buildRustPackage rec {
  pname = "stylance-cli";
  version = "0.7.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-NIUZvyT5CetUjHDoMYaXIZ2nhwH9SaXPnatvkkQhChA=";
  };

  cargoHash = "sha256-JCmxbpwJOIbY9Vr+LZxf9x1eabUD25uuLDQ/KW5ChnM=";

  meta = {
    description = "Library and cli tool for working with scoped CSS in rust";
    mainProgram = "stylance";
    homepage = "https://github.com/basro/stylance-rs";
    changelog = "https://github.com/basro/stylance-rs/blob/v${version}/CHANGELOG.md";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ dav-wolff ];
  };
}

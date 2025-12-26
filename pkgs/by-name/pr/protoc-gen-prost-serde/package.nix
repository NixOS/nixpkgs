{
  fetchCrate,
  lib,
  rustPlatform,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "protoc-gen-prost-serde";
  version = "0.4.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-tgsGyUVoQZQcOqh56KGVwS3VcxwbKzBL3P2VpYs72Ok=";
  };

  cargoHash = "sha256-otsovgqCC+IdxbdGBaPfjK61bZsHtWwY0QqZBPQxnvw=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Protoc plugin that generates serde serialization implementations for `protoc-gen-prost`";
    mainProgram = "protoc-gen-prost-serde";
    homepage = "https://github.com/neoeinstein/protoc-gen-prost";
    changelog = "https://github.com/neoeinstein/protoc-gen-prost/blob/main/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      felschr
      sitaaax
    ];
  };
}

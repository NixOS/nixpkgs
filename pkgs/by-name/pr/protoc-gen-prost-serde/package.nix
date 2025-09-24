{
  fetchCrate,
  lib,
  rustPlatform,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "protoc-gen-prost-serde";
  version = "0.3.1";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-RQlNVGa6BRIqIGodqNN3eGl//hkUWrq7GpTGpRBCDgE=";
  };

  cargoHash = "sha256-OWSXA3S3o5eqM3pg2MPxx3HrCma778YJaPFOJq7S5zY=";

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Protoc plugin that generates serde serialization implementations for `protoc-gen-prost`";
    mainProgram = "protoc-gen-prost-serde";
    homepage = "https://github.com/neoeinstein/protoc-gen-prost";
    changelog = "https://github.com/neoeinstein/protoc-gen-prost/blob/main/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [
      felschr
      sitaaax
    ];
  };
}

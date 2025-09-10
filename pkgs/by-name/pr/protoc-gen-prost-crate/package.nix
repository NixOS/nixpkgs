{
  fetchCrate,
  lib,
  rustPlatform,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "protoc-gen-prost-crate";
  version = "0.4.1";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-9rIFDZbI6XGDsNzFMnMYY4loJxojdz6vnQKAz9eDAyQ=";
  };

  cargoHash = "sha256-DjxoORk/DNXQ7ht7L4lxzMfst1i3m/cT7sqn2HoRN9U=";

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Protoc plugin that generates Cargo crates and include files for `protoc-gen-prost`";
    mainProgram = "protoc-gen-prost-crate";
    homepage = "https://github.com/neoeinstein/protoc-gen-prost";
    changelog = "https://github.com/neoeinstein/protoc-gen-prost/blob/main/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [
      felschr
      sitaaax
    ];
  };
}

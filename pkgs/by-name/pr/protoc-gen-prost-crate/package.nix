{
  fetchCrate,
  lib,
  rustPlatform,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "protoc-gen-prost-crate";
  version = "0.5.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-FBgvDhlyVAegF5n9U6Tunn+MpXdek4f1xWIS3sJ4soI=";
  };

  cargoHash = "sha256-29sM+d6+yaIsZKyxieHP4Q7mB2HAyWEwuBIgFCF281U=";

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

{
  fetchCrate,
  lib,
  rustPlatform,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "protoc-gen-prost-crate";
  version = "0.4.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-+TSZ2QstAF8DXsHunV/nQyqF++0bFud1ZWJQEI3JEwc=";
  };

  cargoHash = "sha256-KbErgnXG11ngzLVSktuyUAupYs1ZD64z3plKVtzLx1A=";

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

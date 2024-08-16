{
  fetchCrate,
  lib,
  rustPlatform,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "protoc-gen-tonic";
  version = "0.4.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-3qz1ea9lEsZjhWNA0lcwqsPkNmjj2ZBljqNRr5/2lKM=";
  };

  cargoHash = "sha256-nUsRoDaP+omZdOTnaxvHbJT1uNGtyfgXyEFZbp/CeYA=";

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Protoc plugin that generates Tonic gRPC server and client code using the Prost code generation engine";
    mainProgram = "protoc-gen-tonic";
    homepage = "https://github.com/neoeinstein/protoc-gen-prost";
    changelog = "https://github.com/neoeinstein/protoc-gen-prost/blob/main/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [
      felschr
      sitaaax
    ];
  };
}

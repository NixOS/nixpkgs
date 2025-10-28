{
  fetchCrate,
  lib,
  rustPlatform,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "protoc-gen-tonic";
  version = "0.4.1";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-H7YQ8y6YA8kjR9bhHfBOYu0OEFc8ezqXkqC6jGScs3s=";
  };

  cargoHash = "sha256-ihEHLFCC5jNpFIIvBUFCxKvpjY/OhOH5UgbvuQMFv3s=";

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

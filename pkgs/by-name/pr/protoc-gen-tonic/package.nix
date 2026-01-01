{
  fetchCrate,
  lib,
  rustPlatform,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "protoc-gen-tonic";
<<<<<<< HEAD
  version = "0.5.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-F3AVlkyIbSaA6u7/Pm6qM9AuONddSwqcCU6OAHoVwxk=";
  };

  cargoHash = "sha256-y8d3ZARKwUbT5RiN59FKDSPjk1LYNR4qePg5EIUVe2c=";

  passthru.updateScript = nix-update-script { };

  meta = {
=======
  version = "0.4.1";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-H7YQ8y6YA8kjR9bhHfBOYu0OEFc8ezqXkqC6jGScs3s=";
  };

  cargoHash = "sha256-ihEHLFCC5jNpFIIvBUFCxKvpjY/OhOH5UgbvuQMFv3s=";

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    description = "Protoc plugin that generates Tonic gRPC server and client code using the Prost code generation engine";
    mainProgram = "protoc-gen-tonic";
    homepage = "https://github.com/neoeinstein/protoc-gen-prost";
    changelog = "https://github.com/neoeinstein/protoc-gen-prost/blob/main/CHANGELOG.md";
<<<<<<< HEAD
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
=======
    license = licenses.asl20;
    maintainers = with maintainers; [
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      felschr
      sitaaax
    ];
  };
}

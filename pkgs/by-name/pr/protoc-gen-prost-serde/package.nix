{
  fetchCrate,
  lib,
  rustPlatform,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "protoc-gen-prost-serde";
  version = "0.3.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-O2Mpft31ZQncqETWzwD73I1nX1Wt5XVHcTJUk5qhRLY=";
  };

  cargoHash = "sha256-aUWmNS3jF1I0NLApBn3GMMv6ID9mM/j7r7sPFCsFIuw=";

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

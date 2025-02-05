{
  fetchCrate,
  lib,
  rustPlatform,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "protoc-gen-prost";
  version = "0.4.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-Bz5/LyKludw0Tz3r+xr4DMRdMSz/nRzjs7Q66z1PrTU=";
  };

  cargoHash = "sha256-X6yEJBgW9XzCNSxEQYj6LdPjbCPyh4SnKwdA/+sNNeg=";

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Protocol Buffers compiler plugin powered by Prost";
    mainProgram = "protoc-gen-prost";
    homepage = "https://github.com/neoeinstein/protoc-gen-prost";
    changelog = "https://github.com/neoeinstein/protoc-gen-prost/blob/main/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [
      felschr
      sitaaax
    ];
  };
}

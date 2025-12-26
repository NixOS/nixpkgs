{
  fetchCrate,
  lib,
  rustPlatform,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "protoc-gen-prost";
  version = "0.5.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-oeoPQ3hYMQl6sXszpnw6er2HBkxpo4s17XjR0VRKrSA=";
  };

  cargoHash = "sha256-b4nzT+/tCuhd+vh+JDA+/Wx3VJuEgqPYHbNDv8TiImo=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Protocol Buffers compiler plugin powered by Prost";
    mainProgram = "protoc-gen-prost";
    homepage = "https://github.com/neoeinstein/protoc-gen-prost";
    changelog = "https://github.com/neoeinstein/protoc-gen-prost/blob/main/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      felschr
      sitaaax
    ];
  };
}

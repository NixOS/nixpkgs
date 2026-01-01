{
  fetchCrate,
  lib,
  rustPlatform,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "protoc-gen-prost";
<<<<<<< HEAD
  version = "0.5.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-oeoPQ3hYMQl6sXszpnw6er2HBkxpo4s17XjR0VRKrSA=";
  };

  cargoHash = "sha256-b4nzT+/tCuhd+vh+JDA+/Wx3VJuEgqPYHbNDv8TiImo=";

  passthru.updateScript = nix-update-script { };

  meta = {
=======
  version = "0.4.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-Bz5/LyKludw0Tz3r+xr4DMRdMSz/nRzjs7Q66z1PrTU=";
  };

  cargoHash = "sha256-alzrgiOx9zTR9mgmtvcqpj9SxSz7Zz3mmZOX6vfAFeE=";

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    description = "Protocol Buffers compiler plugin powered by Prost";
    mainProgram = "protoc-gen-prost";
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

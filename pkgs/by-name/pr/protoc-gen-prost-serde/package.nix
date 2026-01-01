{
  fetchCrate,
  lib,
  rustPlatform,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "protoc-gen-prost-serde";
<<<<<<< HEAD
  version = "0.4.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-tgsGyUVoQZQcOqh56KGVwS3VcxwbKzBL3P2VpYs72Ok=";
  };

  cargoHash = "sha256-otsovgqCC+IdxbdGBaPfjK61bZsHtWwY0QqZBPQxnvw=";

  passthru.updateScript = nix-update-script { };

  meta = {
=======
  version = "0.3.1";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-RQlNVGa6BRIqIGodqNN3eGl//hkUWrq7GpTGpRBCDgE=";
  };

  cargoHash = "sha256-OWSXA3S3o5eqM3pg2MPxx3HrCma778YJaPFOJq7S5zY=";

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    description = "Protoc plugin that generates serde serialization implementations for `protoc-gen-prost`";
    mainProgram = "protoc-gen-prost-serde";
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

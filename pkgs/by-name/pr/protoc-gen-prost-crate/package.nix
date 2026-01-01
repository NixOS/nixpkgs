{
  fetchCrate,
  lib,
  rustPlatform,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "protoc-gen-prost-crate";
<<<<<<< HEAD
  version = "0.5.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-FBgvDhlyVAegF5n9U6Tunn+MpXdek4f1xWIS3sJ4soI=";
  };

  cargoHash = "sha256-29sM+d6+yaIsZKyxieHP4Q7mB2HAyWEwuBIgFCF281U=";

  passthru.updateScript = nix-update-script { };

  meta = {
=======
  version = "0.4.1";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-9rIFDZbI6XGDsNzFMnMYY4loJxojdz6vnQKAz9eDAyQ=";
  };

  cargoHash = "sha256-DjxoORk/DNXQ7ht7L4lxzMfst1i3m/cT7sqn2HoRN9U=";

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    description = "Protoc plugin that generates Cargo crates and include files for `protoc-gen-prost`";
    mainProgram = "protoc-gen-prost-crate";
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

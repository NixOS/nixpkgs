{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "leptosfmt";
  version = "0.1.33";

  src = fetchFromGitHub {
    owner = "bram209";
    repo = "leptosfmt";
    tag = version;
    hash = "sha256-+trLQFU8oP45xHQ3DsEESQzQX2WpvQcfpgGC9o5ITcY=";
    fetchSubmodules = true;
  };

  cargoHash = "sha256-m9426zuxp9GfbYoljW49BVgetLTqqcqGHCb7I+Yw+bc=";

<<<<<<< HEAD
  meta = {
=======
  meta = with lib; {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    description = "Formatter for the leptos view! macro";
    mainProgram = "leptosfmt";
    homepage = "https://github.com/bram209/leptosfmt";
    changelog = "https://github.com/bram209/leptosfmt/blob/${src.rev}/CHANGELOG.md";
<<<<<<< HEAD
    license = with lib.licenses; [
=======
    license = with licenses; [
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      asl20
      mit
    ];
    maintainers = [ ];
  };
}

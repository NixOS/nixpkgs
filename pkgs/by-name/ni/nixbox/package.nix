{
  lib,
  rustPlatform,
  fetchCrate,
}:

rustPlatform.buildRustPackage rec {
  pname = "nixbox";
  version = "0.1.8";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-+BYx8GecYy6Kc4zLlqskrF/5ZH/YzIIpTEe7SAhWhqM=";
  };

  cargoHash = "sha256-n2+1fXZhOy6CwRKNuEcZiQvS6BE1CKSgITDl/IhyTGc=";

  __structuredAttrs = true;

  meta = with lib; {
    description = "TUI package manager for NixOS that wires selections into your flake + home-manager config";
    homepage = "https://github.com/SINGH-RAJVEER/nix-box";
    license = licenses.asl20;
    maintainers = with maintainers; [ rajveer ];
    mainProgram = "nixbox";
    platforms = platforms.linux;
  };
}

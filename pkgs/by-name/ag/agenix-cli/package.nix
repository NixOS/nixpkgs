{
  lib,
  fetchFromGitHub,
  rustPlatform,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "agenix-cli";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "cole-h";
    repo = "agenix-cli";
    rev = "v${version}";
    sha256 = "sha256-0+QVY1sDhGF4hAN6m2FdKZgm9V1cuGGjY4aitRBnvKg=";
  };

  cargoHash = "sha256-TLCSLxrKLBge/DgyzvBSshssIiFOuc/4Dq0wY7u2hxI=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Companion tool to https://github.com/ryantm/agenix";
    homepage = "https://github.com/cole-h/agenix-cli";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = with lib.maintainers; [ misuzu ];
    mainProgram = "agenix";
  };
}

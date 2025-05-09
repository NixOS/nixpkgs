{
  lib,
  fetchFromGitHub,
  rustPlatform,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "agenix-cli";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "cole-h";
    repo = "agenix-cli";
    rev = "v${version}";
    sha256 = "sha256-hMJZducLOSLiHSQK3sGTQagx1ZfzoH+L5qYv9LMeDek=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-hUtnbxpR2e7hZFFpp8kQ09uNF7UCgf6cIxd7sloj4Yg=";

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

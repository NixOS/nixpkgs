{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix,
  nixfmt,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "nil";
  version = "2025-06-13";

  src = fetchFromGitHub {
    owner = "oxalica";
    repo = "nil";
    rev = version;
    hash = "sha256-oxvVAFUO9husnRk6XZcLFLjLWL9z0pW25Fk6kVKwt1c=";
  };

  cargoHash = "sha256-OZIajxv8xNfCGalVw/FUAwWdQzPqfGuDoeRg2E2RR7s=";

  nativeBuildInputs = [ nix ];

  env = {
    CFG_RELEASE = version;
    CFG_DEFAULT_FORMATTER = lib.getExe nixfmt;
  };

  # might be related to https://github.com/NixOS/nix/issues/5884
  preBuild = ''
    export NIX_STATE_DIR=$(mktemp -d)
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Yet another language server for Nix";
    homepage = "https://github.com/oxalica/nil";
    changelog = "https://github.com/oxalica/nil/releases/tag/${version}";
    license = with lib.licenses; [
      mit
      asl20
    ];
    maintainers = with lib.maintainers; [
      figsoda
      oxalica
    ];
    mainProgram = "nil";
  };
}

{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "nil";
  version = "2024-08-06";

  src = fetchFromGitHub {
    owner = "oxalica";
    repo = "nil";
    rev = version;
    hash = "sha256-DqsN/VkYVr4M0PVRQKXPPOTaind5miYZURIYqM4MxYM=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-7TR/xTc66WpPszJDrpisVvHXl2+FGrUOskZAkGyY04Q=";

  nativeBuildInputs = [ nix ];

  env.CFG_RELEASE = version;

  # might be related to https://github.com/NixOS/nix/issues/5884
  preBuild = ''
    export NIX_STATE_DIR=$(mktemp -d)
  '';

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Yet another language server for Nix";
    homepage = "https://github.com/oxalica/nil";
    changelog = "https://github.com/oxalica/nil/releases/tag/${version}";
    license = with licenses; [
      mit
      asl20
    ];
    maintainers = with maintainers; [
      figsoda
      oxalica
    ];
    mainProgram = "nil";
  };
}

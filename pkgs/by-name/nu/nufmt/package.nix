{
  lib,
  fetchFromGitHub,
  rustPlatform,
  nix-update-script,
}:

rustPlatform.buildRustPackage {
  pname = "nufmt";
  version = "0-unstable-2025-05-08";

  src = fetchFromGitHub {
    owner = "nushell";
    repo = "nufmt";
    rev = "e6b253167d5136be5ae765efb7ebe56300bd09fc";
    hash = "sha256-mMCWfdWVA/MidMlzhYoIYa21WIzq4QAEjCcH+t+Dmv0=";
  };

  nativeBuildInputs = [
    rustPlatform.bindgenHook
  ];

  useFetchCargoVendor = true;
  cargoHash = "sha256-KDXC2/1GcJL6qH+L/FzzQCA7kJigtKOfxVDLv5qXYao=";

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    description = "Nushell formatter";
    homepage = "https://github.com/nushell/nufmt";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      iogamaster
      khaneliman
    ];
    mainProgram = "nufmt";
  };
}

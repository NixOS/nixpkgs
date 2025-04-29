{
  lib,
  fetchFromGitHub,
  rustPlatform,
  nix-update-script,
}:

rustPlatform.buildRustPackage {
  pname = "nufmt";
  version = "0-unstable-2025-04-09";

  src = fetchFromGitHub {
    owner = "nushell";
    repo = "nufmt";
    rev = "8a29b3a1e3b8009c0c2430d5158ac3ddb7f9e023";
    hash = "sha256-aUaM/haZZOagG8/e4eUFsZJ1bhwAaS7fwNoCFUFYEAg=";
  };

  nativeBuildInputs = [
    rustPlatform.bindgenHook
  ];

  useFetchCargoVendor = true;
  cargoHash = "sha256-zS4g/uMh1eOoPo/RZfanL6afCEU5cnyzHrIqkvuQVrg=";

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

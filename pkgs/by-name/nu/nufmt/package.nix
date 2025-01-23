{
  lib,
  fetchFromGitHub,
  rustPlatform,
  nix-update-script,
}:

rustPlatform.buildRustPackage {
  pname = "nufmt";
  version = "0-unstable-2024-11-21";

  src = fetchFromGitHub {
    owner = "nushell";
    repo = "nufmt";
    rev = "628a3b73ea637c96f2c191ae066cf1cecadeafa3";
    hash = "sha256-ideILLOawU6BNawmr4lqt2LGkf29wvlwQe9gqgdYRiI=";
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

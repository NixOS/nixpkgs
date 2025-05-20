{
  lib,
  fetchFromGitHub,
  rustPlatform,
  nix-update-script,
}:

rustPlatform.buildRustPackage {
  pname = "nufmt";
  version = "0-unstable-2025-04-28";

  src = fetchFromGitHub {
    owner = "nushell";
    repo = "nufmt";
    rev = "feafe695659c4d5153018a78fad949d088d8a480";
    hash = "sha256-4FnZIlZWuvSAXMQbdyONNrgIuMxH5Vq3MFbb8J2CnHM=";
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

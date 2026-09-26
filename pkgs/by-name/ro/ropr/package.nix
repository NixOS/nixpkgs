{
  lib,
  fetchFromGitHub,
  rustPlatform,
  versionCheckHook,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "ropr";
  version = "0.2.26-unstable-2025-07-20";

  src = fetchFromGitHub {
    owner = "Ben-Lichtman";
    repo = "ropr";
    rev = "ec3eb2d91d9b4a940a8013a079ead47d7eab6dac";
    hash = "sha256-iN6CSivyBe6Ibbl+oQ2wThbSyHTKne14XsilkMntnfE=";
  };

  cargoHash = "sha256-4YEriANTAt1dx9bXhlHFN+kNLde+8BLocuhXdFG24xo=";

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;
  preVersionCheck = ''
    version=${builtins.head (lib.splitString "-" finalAttrs.version)}
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Multithreaded ROP gadget finder for x86(_64)";
    homepage = "https://github.com/Ben-Lichtman/ropr";
    license = with lib.licenses; [
      mit
      asl20
    ];
    mainProgram = "ropr";
    maintainers = with lib.maintainers; [ feyorsh ];
  };
})

{
  lib,
  fetchFromGitHub,
  rustPlatform,
  fetchpatch,
  nix-update-script,
  fetchCrate,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "bpflinter";
  version = "0.1.5";
  src = fetchCrate {
    inherit (finalAttrs) pname version;
    hash = "sha256-oX4fgUKOASiI/NMFSjr6afmyg1VBK44lqni+xBXlZLo=";
  };

  cargoHash = "sha256-3TIWrqgePnBMEJFB5fkch5ycU4NXE6JlbUpq9/8DbHc=";

  passthru.updateScript = nix-update-script { };
  meta = {
    mainProgram = "bpflinter";
    description = "Linting functionality for BPF C programs";
    homepage = "https://github.com/d-e-s-o/bpflint";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ fzakaria ];
  };
})

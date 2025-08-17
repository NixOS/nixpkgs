{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "lelwel";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "0x2a-42";
    repo = "lelwel";
    tag = "v${finalAttrs.version}";
    hash = "sha256-l1817wl0x7mkgHRKxFhoPUUW1gPzfwpvP+4eEjEZrz8=";
  };

  cargoHash = "sha256-KRQCO7rmqM4mEm+qtTXar2vTcaYiHFI5hekT6Oq/xEE=";

  buildFeatures = [
    "cli"
    "lsp"
  ];

  passthru.updateScript = nix-update-script { };

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  meta = {
    description = "Resilient LL(1) parser generator for Rust";
    longDescription = ''
      Lelwel (Language for Extended LL(1) parsing With Error
      resilience and Lossless syntax trees) generates recursive
      descent parsers for Rust using LL(1) grammars with extensions
      for direct left recursion, operator precedence, semantic
      predicates, semantic actions, and a restricted ordered choice.
    '';
    homepage = "https://github.com/0x2a-42/lelwel";
    changelog = "https://github.com/0x2a-42/lelwel/releases/tag/v${finalAttrs.version}";
    mainProgram = "llw";
    maintainers = with lib.maintainers; [ kpbaks ];
    license = with lib.licenses; [
      asl20 # OR
      mit
    ];
  };
})

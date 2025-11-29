{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "lelwel";
  version = "0.9.1";

  src = fetchFromGitHub {
    owner = "0x2a-42";
    repo = "lelwel";
    tag = "v${finalAttrs.version}";
    hash = "sha256-mgGRVu7S6fD9kQSlkMPjcHZ0faRsoPvCzrXmKc2dMmo=";
  };

  cargoHash = "sha256-n7WiCRhDo6/O6Gx6N81Tg2ScspmI3ivfKAroB7REyPA=";

  buildFeatures = [
    "cli"
    "lsp"
  ];

  passthru.updateScript = nix-update-script { };

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";

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
    mainProgram = "llw";
    maintainers = with lib.maintainers; [ kpbaks ];
    license = with lib.licenses; [
      asl20 # OR
      mit
    ];
  };
})

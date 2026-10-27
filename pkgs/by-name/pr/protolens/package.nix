{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  versionCheckHook,

  # passthru
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "protolens";
  version = "0.3.4";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "douzebis";
    repo = "prototools";
    tag = "v${finalAttrs.version}";
    hash = "sha256-kM86xUE4yVaDTROjwwXAWh9J4lPVBTAbUfv1lHy+e+k=";
  };

  cargoHash = "sha256-XVwjHZGEEm5uCuXX9MPGuKmUg2zf5AdubQR0hz5fxwM=";

  # The crate is prototext-lens on crates.io; its program, protolens.
  cargoBuildFlags = [
    "-p"
    "prototext-lens"
  ];
  cargoTestFlags = [
    "-p"
    "prototext-lens"
  ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd protolens \
      --bash <(PROTOLENS_COMPLETE=bash $out/bin/protolens) \
      --zsh <(PROTOLENS_COMPLETE=zsh $out/bin/protolens) \
      --fish <(PROTOLENS_COMPLETE=fish $out/bin/protolens)
    PROTOLENS_GEN_MAN=$out/share/man/man1 $out/bin/protolens
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  # Only v-prefixed release tags
  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "^v(\\d+\\.\\d+\\.\\d+)$"
    ];
  };

  meta = {
    description = "Terminal viewer to decode, navigate and extract binary protobuf messages";
    longDescription = ''
      protolens shows a binary protobuf message as a tree, decoded with or
      without its schema, and lets you navigate it, inspect each field's
      bytes, and extract them. Given a set of schemas, it infers the
      message's type: it ranks every candidate type by how well it fits the
      bytes, and decodes with the best.
    '';
    homepage = "https://github.com/douzebis/prototools";
    changelog = "https://github.com/douzebis/prototools/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ douzebis ];
    mainProgram = "protolens";
    platforms = lib.platforms.unix;
  };
})

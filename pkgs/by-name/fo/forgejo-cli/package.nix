{
  lib,
  stdenv,
  rustPlatform,
  fetchFromCodeberg,
  pkg-config,
  installShellFiles,
  writableTmpDirAsHomeHook,
  libgit2,
  oniguruma,
  openssl,
  zlib,
  versionCheckHook,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "forgejo-cli";
  version = "0.6.0";

  __structuredAttrs = true;

  src = fetchFromCodeberg {
    owner = "forgejo-contrib";
    repo = "forgejo-cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-XG7IPfl5yLToDQ+P0JkMxhfqsGd3cGWYCNrmlFf9j2Y=";
  };

  cargoHash = "sha256-+7WiOmYBjTMEsIGaqnMVTIHhzTpm8ObnljNXFnDazhI=";

  nativeBuildInputs = [
    pkg-config
    installShellFiles
    writableTmpDirAsHomeHook # Needed for shell completions
  ];

  buildInputs = [
    libgit2
    oniguruma
    openssl
    zlib
  ];

  env = {
    RUSTONIG_SYSTEM_LIBONIG = true;
    BUILD_TYPE = "nixpkgs";
  };

  # The `grep -v ...` in the completion commands below mitigate a forgejo-cli issue
  # that, as of forgejo-cli 0.6.0, causes the `completion` command to output extra text.
  # see: https://codeberg.org/forgejo-contrib/forgejo-cli/issues/629
  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd fj \
      --bash <($out/bin/fj completion bash | grep -v '^Could not find keys file. Creating a new file.$') \
      --fish <($out/bin/fj completion fish | grep -v '^Could not find keys file. Creating a new file.$') \
      --zsh  <($out/bin/fj completion zsh  | grep -v '^Could not find keys file. Creating a new file.$')
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "version";
  doInstallCheck = true;

  meta = {
    description = "CLI application for interacting with Forgejo";
    homepage = "https://codeberg.org/forgejo-contrib/forgejo-cli";
    changelog = "https://codeberg.org/forgejo-contrib/forgejo-cli/releases/tag/v${finalAttrs.version}";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = with lib.maintainers; [
      da157
      isabelroses
    ];
    mainProgram = "fj";
  };
})

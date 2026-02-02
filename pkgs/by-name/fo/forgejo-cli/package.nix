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
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "forgejo-cli";
  version = "0.4.0";

  src = fetchFromCodeberg {
    owner = "forgejo-contrib";
    repo = "forgejo-cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-EJr/7me2wiOBSFw0VFSxyqnQKy3kpOMGJmxD7wxmWPc=";
  };

  cargoHash = "sha256-DpQt76o3ZnIJwHR1DQ/mn9f8XiWHKVB4h3NNbvCIMZ8=";

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

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd fj \
      --bash <($out/bin/fj completion bash) \
      --fish <($out/bin/fj completion fish) \
      --zsh <($out/bin/fj completion zsh)
  '';

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

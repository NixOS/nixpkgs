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
  version = "0.4.1";

  src = fetchFromCodeberg {
    owner = "forgejo-contrib";
    repo = "forgejo-cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-tWb5h0i3Z8qSHqFL7FofwljMdXgV1Z6x8ojut9pm6Yg=";
  };

  cargoHash = "sha256-7gCzU7U8kIxWnwLksXIUkgfFWWjZ/0QiaHnCD+H8sGQ=";

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

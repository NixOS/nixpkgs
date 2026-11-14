{
  lib,
  rustPlatform,
  fetchFromGitHub,
  stdenv,
  pkg-config,
  installShellFiles,
  installShellCompletions ? stdenv.buildPlatform.canExecute stdenv.hostPlatform,
  installManPages ? stdenv.buildPlatform.canExecute stdenv.hostPlatform,
  notmuch,
  buildNoDefaultFeatures ? false,
  buildFeatures ? [ ],
}:

rustPlatform.buildRustPackage (finalAttrs: {
  # Learn more about available cargo features at:
  #  - <https://pimalaya.org/neverest/cli/latest/installation.html#cargo>
  #  - <https://git.sr.ht/~soywod/neverest-cli/tree/master/item/Cargo.toml#L18>
  inherit buildNoDefaultFeatures buildFeatures;

  pname = "neverest";
  version = "1.0.0-beta";

  src = fetchFromGitHub {
    owner = "pimalaya";
    repo = "neverest";
    rev = "v${finalAttrs.version}";
    hash = "sha256-3PSJyhxrOCiuHUeVHO77+NecnI5fN5EZfPhYizuYvtE=";
  };

  cargoHash = "sha256-K+LKRokfE8i4Huti0aQm4UrpConTcxVwJ2DyeOLjNKA=";

  # TODO: Remove this once email-lib is moved to 0.27.
  # Rust 1.89 added inherent
  #  `File::try_lock and File::unlock`, which take
  # precedence over the `advisory_lock` trait methods # that email-lib calls.
  postPatch = ''
    patch -p1 -d "$cargoDepsCopy"/source-registry-0/email-lib-0.24.0 < ${./email-lib-file-lock.patch}
  '';

  nativeBuildInputs = [
    pkg-config
  ]
  ++ lib.optional (installManPages || installShellCompletions) installShellFiles;

  buildInputs = lib.optional (builtins.elem "notmuch" buildFeatures) notmuch;

  # TODO: unit tests temporarily broken, remove this line for the next
  # beta.2 release
  doCheck = false;

  postInstall =
    lib.optionalString installManPages ''
      mkdir -p $out/man
      $out/bin/neverest man $out/man
      installManPage $out/man/*
    ''
    + lib.optionalString installShellCompletions ''
      installShellCompletion --cmd neverest \
        --bash <($out/bin/neverest completion bash) \
        --fish <($out/bin/neverest completion fish) \
        --zsh <($out/bin/neverest completion zsh)
    '';

  meta = {
    description = "CLI to synchronize, backup and restore emails";
    mainProgram = "neverest";
    homepage = "https://pimalaya.org/neverest/cli/v${finalAttrs.version}/";
    changelog = "https://git.sr.ht/~soywod/neverest-cli/tree/v${finalAttrs.version}/item/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ soywod ];
    # last successful hydra build on darwin was in 2025
    broken = stdenv.hostPlatform.isDarwin;
  };
})

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

rustPlatform.buildRustPackage rec {
  # Learn more about available cargo features at:
  #  - <https://pimalaya.org/neverest/cli/latest/installation.html#cargo>
  #  - <https://git.sr.ht/~soywod/neverest-cli/tree/master/item/Cargo.toml#L18>
  inherit buildNoDefaultFeatures buildFeatures;

  pname = "neverest";
  version = "1.0.0-beta";

  src = fetchFromGitHub {
    owner = "pimalaya";
    repo = "neverest";
    rev = "v${version}";
    hash = "sha256-3PSJyhxrOCiuHUeVHO77+NecnI5fN5EZfPhYizuYvtE=";
  };

  cargoHash = "sha256-K+LKRokfE8i4Huti0aQm4UrpConTcxVwJ2DyeOLjNKA=";

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
    homepage = "https://pimalaya.org/neverest/cli/v${version}/";
    changelog = "https://git.sr.ht/~soywod/neverest-cli/tree/v${version}/item/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ soywod ];
  };
}

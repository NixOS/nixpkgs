{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix,
  installShellFiles,
}:
rustPlatform.buildRustPackage {
  pname = "ragenix";
  version = "0-unstable-2024-09-19";

  src = fetchFromGitHub {
    owner = "yaxitech";
    repo = "ragenix";
    rev = "687ee92114bce9c4724376cf6b21235abe880bfa";
    hash = "sha256-03XIEjHeZEjHXctsXYUB+ZLQmM0WuhR6qWQjwekFk/M=";
  };

  cargoHash = "sha256-NO0VpLZTGjddh1aESulAx4pP4k1vdDm1+oCmf/ybuO4=";
  useFetchCargoVendor = true;

  RAGENIX_NIX_BIN_PATH = lib.getExe nix;

  checkNoDefaultFeatures = true;

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    set -euo pipefail

    # Provide a symlink from `agenix` to `ragenix` for compat
    ln -sr "$out/bin/ragenix" "$out/bin/agenix"

    # Stdout of build.rs
    buildOut=$(grep -m 1 -Rl 'RAGENIX_COMPLETIONS_BASH=/' target/ | head -n 1)
    printf "found build script output at %s\n" "$buildOut"

    set +u # required due to `installShellCompletion`'s implementation
    installShellCompletion --bash "$(grep -oP 'RAGENIX_COMPLETIONS_BASH=\K.+' "$buildOut")"
    installShellCompletion --zsh  "$(grep -oP 'RAGENIX_COMPLETIONS_ZSH=\K.+'  "$buildOut")"
    installShellCompletion --fish "$(grep -oP 'RAGENIX_COMPLETIONS_FISH=\K.+' "$buildOut")"
    set -x

    installManPage docs/ragenix.1
  '';

  meta = {
    description = "Age-encrypted secrets for NixOS, drop-in replacement for agenix";
    homepage = "https://github.com/yaxitech/ragenix";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      aciceri
    ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    mainProgram = "ragenix";
  };
}

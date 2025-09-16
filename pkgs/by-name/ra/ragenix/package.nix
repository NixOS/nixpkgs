{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix,
  installShellFiles,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "ragenix";
  version = "2025.03.09";

  src = fetchFromGitHub {
    owner = "yaxitech";
    repo = "ragenix";
    tag = finalAttrs.version;
    hash = "sha256-iQf1WdNxaApOFHIx4RLMRZ4f8g+8Xp0Z1/E/Mz2rLxY=";
  };

  cargoHash = "sha256-aM7kjyJJ8h4Yd1k2FTE8Vk/ezAXcCbfdAPxuNewptNQ=";

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
})

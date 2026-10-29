# Toolchain Rust fixada pelo `rust-toolchain.toml` do snapshot.
#
# `rust-bin` vem do rust-overlay (fixado no flake.lock); cada versão aponta
# para os tarballs oficiais de static.rust-lang.org com hash SHA-256 fixo.
# Uma versão ausente do rust-overlay é erro de avaliação, nunca uma troca
# silenciosa de compilador.
{
  lib,
  rust-bin,
  makeRustPlatform,
  toolchainFile,
}:

let
  spec = (lib.importTOML toolchainFile).toolchain;

  channel =
    if builtins.match "[0-9]+\\.[0-9]+\\.[0-9]+" spec.channel != null then
      spec.channel
    else
      throw "nixpkgs-arkhe: rust-toolchain.toml precisa fixar uma versão exata (achado: ${spec.channel})";

  minimal = rust-bin.stable.${channel}.minimal;

  # Builds nativos: só rustc, cargo e rust-std do host.
  native = minimal;
  # Mesmo compilador com rust-std de wasm32.
  wasm = minimal.override { targets = [ "wasm32-unknown-unknown" ]; };
  # Componentes do rust-toolchain.toml (clippy, rustfmt) para checks e devShell.
  dev = minimal.override { extensions = spec.components or [ ]; };

  platformFor =
    toolchain:
    makeRustPlatform {
      cargo = toolchain;
      rustc = toolchain;
    };
in
{
  inherit
    channel
    native
    wasm
    dev
    ;

  rustPlatform = platformFor native;
  rustPlatformWasm = platformFor wasm;
  rustPlatformDev = platformFor dev;
}

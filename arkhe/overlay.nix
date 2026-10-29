# Overlay Nix.
#
#   nixpkgs.overlays = [ inputs.nixpkgs-arkhe.overlays.default ];
#   environment.systemPackages = [ pkgs.arkhe.arkhe-verify ];
#
# Pelo flake, `overlays.default` já usa a toolchain Rust fixada
# (rust-toolchain.toml via rust-overlay). Importado direto, sem
# `toolchain`, cai no rustPlatform do nixpkgs consumidor.
#
# Para derivar com endereçamento por conteúdo: `overlays.contentAddressed`.
{
  src ? ./source,
  contentAddressed ? false,
  # pkgs -> { rustPlatform, rustPlatformWasm, rustPlatformDev }
  toolchain ? null,
}:
final: prev:
let
  platforms =
    if toolchain == null then
      { rustPlatform = final.rustPlatform; }
    else
      {
        inherit (toolchain final) rustPlatform rustPlatformWasm rustPlatformDev;
      };

  arkhe = import ./default.nix (
    {
      pkgs = final;
      inherit src contentAddressed;
    }
    // platforms
  );
in
{
  inherit arkhe;
  arkhePackages = arkhe;
}

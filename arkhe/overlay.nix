# Overlay Nix.
#
#   nixpkgs.overlays = [ inputs.nixpkgs-arkhe.overlays.default ];
#   environment.systemPackages = [ pkgs.arkhe.arkhe-verify ];
#
# Para derivar com endereçamento por conteúdo:
#
#   nixpkgs.overlays = [
#     (import inputs.nixpkgs-arkhe { contentAddressed = true; })
#   ];
{
  src ? ./source,
  contentAddressed ? false,
  rustPlatform ? null,
}:
final: prev:
let
  arkhe = import ./default.nix {
    pkgs = final;
    inherit src contentAddressed;
    rustPlatform = if rustPlatform == null then final.rustPlatform else rustPlatform;
  };
in
{
  inherit arkhe;
  arkhePackages = arkhe;
}

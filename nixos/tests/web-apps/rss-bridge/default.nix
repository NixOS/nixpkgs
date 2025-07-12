{ system, pkgs, ... }:
{
  nginx = import ./nginx.nix { inherit system pkgs; };
  caddy = import ./caddy.nix { inherit system pkgs; };
}

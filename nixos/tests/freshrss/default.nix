{ system, pkgs, ... }:

{
  extensions = import ./extensions.nix { inherit system pkgs; };
  http-auth = import ./http-auth.nix { inherit system pkgs; };
  none-auth = import ./none-auth.nix { inherit system pkgs; };
  pgsql = import ./pgsql.nix { inherit system pkgs; };
  nginx-sqlite = import ./nginx-sqlite.nix { inherit system pkgs; };
  caddy-sqlite = import ./caddy-sqlite.nix { inherit system pkgs; };
}

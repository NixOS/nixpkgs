{ system, pkgs, ... }:

{
  extensions = import ./extensions.nix { inherit system pkgs; };
  http-auth = import ./http-auth.nix { inherit system pkgs; };
  none-auth = import ./none-auth.nix { inherit system pkgs; };
  pgsql = import ./pgsql.nix { inherit system pkgs; };
  sqlite = import ./sqlite.nix { inherit system pkgs; };
}

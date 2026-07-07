let
  sources = import ./npins;
  nikpkgs = import sources.nixpkgs { };
in
{
  pkgs ? nikpkgs,
}:
pkgs.mkShell {
  packages = [
    pkgs.python314
    pkgs.bubblewrap
    pkgs.ruff # Formatter
  ];
}

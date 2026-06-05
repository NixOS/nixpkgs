let
  sources = import ./npins;
  nikpkgs = import sources.nixpkgs { };
in
{
  pkgs ? nikpkgs,
}:
pkgs.mkShell {
  packages = [
    pkgs.python3
    pkgs.ruff # Formatter
  ];
}

let
  nixpkgs = import ../../../.. { };
in
{
  pkgs ? nixpkgs,
}:
pkgs.mkShell {
  packages = [
    pkgs.python314
    pkgs.bubblewrap
    pkgs.ruff # Formatter
    pkgs.age # Here to ease playing with the age backend
  ];
}

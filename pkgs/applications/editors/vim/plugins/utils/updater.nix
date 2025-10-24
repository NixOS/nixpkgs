{
  writers,
  python3Packages,
}:
writers.writePython3Bin "vim-plugins-updater" {
  libraries = [ python3Packages.nixpkgs-updaters-library ];
  doCheck = false;
} (builtins.readFile ./update.py)

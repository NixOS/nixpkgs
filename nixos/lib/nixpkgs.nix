/* Terrible backward compatibility hack to get the path to Nixpkgs
   from here.  Usually, that's the relative path ‘../..’.  However,
   when using the NixOS channel, <nixos> resolves to a symlink to
   nixpkgs/nixos, so ‘../..’ doesn't resolve to the top-level Nixpkgs
   directory but one above it.  So check for that situation. */
if builtins.pathExists ../../.version then import ../..
else if builtins.pathExists ../../nixpkgs then import ../../nixpkgs
else abort "Can't find Nixpkgs, please set ‘NIX_PATH=nixpkgs=/path/to/nixpkgs’."

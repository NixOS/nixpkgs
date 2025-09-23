{
  lib,
  pkgs,
  config,
  ...
}:

{
  imports = [
    ./nixos/maintainers/scripts/cygwin/system.nix
    ./nixos/maintainers/scripts/cygwin/tarball.nix
  ];

  nix = {
    settings.experimental-features = [
      "nix-command"
      "flakes"
    ];
  };

  nixpkgs.buildPlatform = lib.mkDefault builtins.currentSystem;
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-cygwin";
}

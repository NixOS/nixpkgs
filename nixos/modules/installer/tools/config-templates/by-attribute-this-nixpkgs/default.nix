# Don't forget to use --file argument to specify to use this file
let
  nixpkgs = "@thisNixpkgs@";
  nixosSystem = import "${nixpkgs}/nixos/lib/eval-config.nix";
in
nixosSystem {
  modules = [
    ./configuration.nix
    {
      nix = {
        channel.enable = false;
        settings.nix-path = "nixpkgs=${nixpkgs}";
      };
    }
  ];
}

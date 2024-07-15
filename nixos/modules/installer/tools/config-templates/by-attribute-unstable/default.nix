# Don't forget to use --file argument to specify to use this file
let
  version = "nixos-unstable";
  nixpkgs = builtins.fetchTarball "https://github.com/NixOS/nixpkgs/archive/${version}.tar.gz";
  nixosSystem = import "${nixpkgs}/nixos/lib/eval-config.nix";
  lib = import "${nixpkgs}/lib";
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
  # Provide useful values for `lib.trivial.version`.
  lib = lib.extend (import "${nixpkgs}/lib/version-info-fixup.nix" {
    versionSuffix = lib:
      # check if version is commit hash
      if lib.isList (lib.match "^[0-9A-Fa-f]{40}$" version) then ".git.${lib.substring 0 8 version}"
      else ".git.${version}";
  });
}

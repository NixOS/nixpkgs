import nixos/lib/eval-config.nix {

  baseModules = [
    ./nixos/modules/misc/nixpkgs.nix
    ./nixos/modules/security/ca.nix
    ./nixos/modules/system/etc/etc.nix

    ./cygwin-tarball.nix
  ];

  modules = [
    {
      nixpkgs.crossSystem.system = "x86_64-cygwin";
    }
  ];
}

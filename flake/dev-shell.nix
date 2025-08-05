{
  lib,
  mkPerSystemOption,
  config,
  ...
}:
{
  imports = [
    (mkPerSystemOption {
      name = "devShells";
      type = lib.types.lazyAttrsOf lib.types.package;
    })
  ];

  perSystem.module =
    { system, ... }:
    lib.mkIf
      (
        # Because "Package ‘ghc-9.6.6’ in .../pkgs/development/compilers/ghc/common-hadrian.nix:579 is not available on the requested hostPlatform"
        !lib.elem system [
          "armv6l-linux"
          "riscv64-linux"
          "x86_64-freebsd"
        ]
      )
      {
        devShells.default = import ../shell.nix { inherit system; };
      };

  outputs = { inherit (config.perSystem.applied) devShells; };
}

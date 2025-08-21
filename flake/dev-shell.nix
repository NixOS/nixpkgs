{ lib, ... }:
{
  outputs.devShells =
    lib.genAttrs
      (lib.filter (
        system:
        # Because "Package ‘ghc-9.6.6’ in .../pkgs/development/compilers/ghc/common-hadrian.nix:579 is not available on the requested hostPlatform"
        !lib.elem system [
          "armv6l-linux"
          "riscv64-linux"
          "x86_64-freebsd"
        ]
      ) lib.systems.flakeExposed)
      (system: {
        default = import ../shell.nix { inherit system; };
      });
}

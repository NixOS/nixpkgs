{
  config,
  lib,
  mkPerSystemOption,
  ...
}:
{
  imports = [
    (mkPerSystemOption {
      name = "formatter";
      type = lib.types.package;
    })
  ];

  perSystem.module =
    { system, ... }:
    lib.mkIf
      (
        !lib.elem system [
          # Because "cannot bootstrap GHC on this platform ('armv6l-linux' with libc 'defaultLibc')"
          "armv6l-linux"
          # Because "cannot bootstrap GHC on this platform ('riscv64-linux' with libc 'defaultLibc')"
          "riscv64-linux"
          # Because "Package ‘go-1.22.12-freebsd-amd64-bootstrap’ in /nix/store/0yw40qnrar3lvc5hax5n49abl57apjbn-source/pkgs/development/compilers/go/binary.nix:50 is not available on the requested hostPlatform"
          "x86_64-freebsd"
        ]
      )
      {
        formatter = (import ../ci { inherit system; }).fmt.pkg;
      };

  outputs = { inherit (config.perSystem.applied) formatter; };
}

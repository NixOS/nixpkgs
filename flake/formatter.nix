{ lib, ... }:
{
  outputs.formatter = lib.genAttrs (lib.filter (
    system:
    !lib.elem system [
      # Because "cannot bootstrap GHC on this platform ('armv6l-linux' with libc 'defaultLibc')"
      "armv6l-linux"
      # Exclude armv7l-linux because "cannot bootstrap GHC on this platform ('armv7l-linux' with libc 'defaultLibc')"
      "armv7l-linux"
      # Exclude powerpc64le-linux because "cannot bootstrap GHC on this platform ('powerpc64le-linux' with libc 'defaultLibc')"
      "powerpc64le-linux"
      # Because "cannot bootstrap GHC on this platform ('riscv64-linux' with libc 'defaultLibc')"
      "riscv64-linux"
      # Because "Package ‘go-1.22.12-freebsd-amd64-bootstrap’ in /nix/store/0yw40qnrar3lvc5hax5n49abl57apjbn-source/pkgs/development/compilers/go/binary.nix:50 is not available on the requested hostPlatform"
      "x86_64-freebsd"
    ]
  ) lib.systems.flakeExposed) (system: (import ../ci { inherit system; }).fmt.pkg);
}

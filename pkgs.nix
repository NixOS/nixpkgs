rec {
  inherit (import pkgs/system/i686-linux.nix)
    stdenv bash coreutils findutils utillinux sysvinit e2fsprogs
    nettools nix;

  boot = (import ./boot) {inherit stdenv bash coreutils findutils
    utillinux sysvinit e2fsprogs nettools nix;};

  everything = [boot sysvinit];
}

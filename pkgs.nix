rec {
  inherit (import pkgs/system/i686-linux.nix)
    stdenv bash coreutils findutils utillinux sysvinit e2fsprogs nix;

  boot = (import ./boot)
    {inherit stdenv bash coreutils findutils utillinux sysvinit e2fsprogs nix;};

  everything = [boot sysvinit];
}

rec {
  inherit (import pkgs/system/i686-linux.nix)
    stdenv bash coreutils findutils utillinux sysvinit e2fsprogs nix;

  init = (import ./init)
    {inherit stdenv bash coreutils findutils utillinux sysvinit e2fsprogs nix;};

  everything = [init sysvinit];
}

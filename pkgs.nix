rec {
  inherit (import /usr/home/nix/nixpkgs-0.6pre1121/pkgs/system/i686-linux.nix)
    stdenv bash coreutils findutils utillinux sysvinit e2fsprogs
    nettools nix subversion gcc wget which vim less screen openssh binutils
    strace shadowutils iputils gnumake curl gnused gnutar gnugrep gzip;

  boot = (import ./boot) {inherit stdenv bash coreutils findutils
    utillinux sysvinit e2fsprogs nettools nix subversion gcc wget which vim
    less screen openssh binutils strace shadowutils iputils gnumake curl
    gnused gnutar gnugrep gzip;};

  everything = [boot sysvinit];
}

{ python3Packages, systemd }:

python3Packages.callPackage ./package.nix {
  # We want `pkgs.systemd`, *not* `python3Packages.system`.
  inherit systemd;
}

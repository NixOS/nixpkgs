{ python3Packages, systemd }:

python3Packages.callPackage ./package.nix {
  # We want `pkgs.systemd`, *not* `python3Packages.systemd`.
  inherit systemd;
}

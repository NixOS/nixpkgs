{ nixpkgs ? { outPath = ./..; revCount = 5678; shortRev = "gfedcba"; }
, officialRelease ? false
}:

let

  nixpkgsSrc = nixpkgs; # urgh

  pkgs = import ./.. {};

  removeMaintainers = set: if builtins.isAttrs set
    then if (set.type or "") == "derivation"
      then set // { meta = builtins.removeAttrs (set.meta or {}) [ "maintainers" ]; }
      else pkgs.lib.mapAttrs (n: v: removeMaintainers v) set
    else set;

in rec {

  nixos = removeMaintainers (import ./release.nix {
    inherit officialRelease;
    nixpkgs = nixpkgsSrc;
  });

  nixpkgs = builtins.removeAttrs (removeMaintainers (import ../pkgs/top-level/release.nix {
    inherit officialRelease;
    nixpkgs = nixpkgsSrc;
    # Only do Linux builds.
    supportedSystems = [ "x86_64-linux" "i686-linux" ];
  })) [ "unstable" ];

  tested = pkgs.releaseTools.aggregate {
    name = "nixos-${nixos.channel.version}";
    meta = {
      description = "Release-critical builds for the NixOS unstable channel";
      maintainers = [ pkgs.lib.maintainers.eelco pkgs.lib.maintainers.shlevy ];
    };
    constituents =
      let all = x: [ x.x86_64-linux x.i686-linux ]; in
      [ nixos.channel
        (all nixos.manual)

        (all nixos.iso_minimal)
        (all nixos.iso_graphical)
        (all nixos.ova)

        #(all nixos.tests.efi-installer.simple)
        (all nixos.tests.firefox)
        (all nixos.tests.firewall)
        (all nixos.tests.installer.grub1)
        (all nixos.tests.installer.lvm)
        (all nixos.tests.installer.separateBoot)
        (all nixos.tests.installer.simple)
        (all nixos.tests.ipv6)
        (all nixos.tests.kde4)
        (all nixos.tests.login)
        (all nixos.tests.misc)
        (all nixos.tests.nat)
        (all nixos.tests.nfs3)
        (all nixos.tests.openssh)
        (all nixos.tests.printing)
        (all nixos.tests.proxy)
        (all nixos.tests.xfce)

        nixpkgs.tarball
        (all nixpkgs.emacs)
      ];
  };

}

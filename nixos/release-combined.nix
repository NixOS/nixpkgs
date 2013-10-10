{ nixosSrc ? { outPath = ./.; revCount = 1234; shortRev = "abcdefg"; }
, nixpkgs ? { outPath = <nixpkgs>; revCount = 5678; shortRev = "gfedcba"; }
, officialRelease ? false
}:

let

  nixpkgs' = nixpkgs; # urgh

  pkgs = import <nixpkgs> {};

  removeMaintainers = set: if builtins.isAttrs set
    then if (set.type or "") == "derivation"
      then set // { meta = builtins.removeAttrs (set.meta or {}) [ "maintainers" ]; }
      else pkgs.lib.mapAttrs (n: v: removeMaintainers v) set
    else set;

in rec {

  nixos = removeMaintainers (import ./release.nix {
    inherit nixosSrc officialRelease;
    nixpkgs = nixpkgs';
  });

  nixpkgs = builtins.removeAttrs (removeMaintainers (import <nixpkgs/pkgs/top-level/release.nix> {
    inherit officialRelease;
    nixpkgs = nixpkgs';
    # Only do Linux builds.
    supportedSystems = [ "x86_64-linux" "i686-linux" ];
  })) [ "unstable" ];

  tested = pkgs.releaseTools.aggregate {
    name = "nixos-${nixos.tarball.version}";
    meta = {
      description = "Release-critical builds for the NixOS unstable channel";
      maintainers = [ pkgs.lib.maintainers.eelco pkgs.lib.maintainers.shlevy ];
    };
    constituents =
      let all = x: [ x.x86_64-linux x.i686-linux ]; in
      [ nixos.channel
        nixos.manual

        (all nixos.iso_minimal)
        (all nixos.iso_graphical)
        (all nixos.ova)

        (all nixos.tests.firefox)
        (all nixos.tests.firewall)
        (all nixos.tests.installer.lvm)
        (all nixos.tests.installer.separateBoot)
        (all nixos.tests.installer.simple)
        (all nixos.tests.kde4)
        (all nixos.tests.login)
        (all nixos.tests.misc)
        (all nixos.tests.openssh)
        (all nixos.tests.printing)
        (all nixos.tests.xfce)

        nixpkgs.tarball
        (all nixpkgs.emacs)
      ];
  };

}

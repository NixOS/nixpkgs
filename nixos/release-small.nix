# This jobset is used to generate a NixOS channel that contains a
# small subset of Nixpkgs, mostly useful for servers that need fast
# security updates.

{ nixpkgs ? { outPath = ./..; revCount = 56789; shortRev = "gfedcba"; }
, stableBranch ? false
, supportedSystems ? [ "x86_64-linux" ] # no i686-linux
}:

let

  nixpkgsSrc = nixpkgs; # urgh

  pkgs = import ./.. {};

  lib = pkgs.lib;

  nixos' = import ./release.nix {
    inherit stableBranch supportedSystems;
    nixpkgs = nixpkgsSrc;
  };

  nixpkgs' = builtins.removeAttrs (import ../pkgs/top-level/release.nix {
    inherit supportedSystems;
    nixpkgs = nixpkgsSrc;
  }) [ "unstable" ];

  forAllSystems = lib.genAttrs supportedSystems;

  versionModule =
    { system.nixosVersionSuffix = versionSuffix;
      system.nixosRevision = nixpkgs.rev or nixpkgs.shortRev;
    };

  version = builtins.readFile ../.version;
  versionSuffix =
    (if stableBranch then "." else "pre") + "${toString (nixpkgs.revCount - 67824)}.${nixpkgs.shortRev}";

in rec {

  # A bootable Flying Circus disk image (raw) that can be extracted onto
  # Ceph RBD volume.
  # A bootable VirtualBox virtual appliance as an OVA file (i.e. packaged OVF).
  ova =
    with import <nixpkgs> { system = "x86_64-linux"; };
    with lib;
    let
      config = (import lib/eval-config.nix {
        inherit system;
        modules =
          [ versionModule
            ./modules/installer/flyingcircus.nix
          ];
      }).config;
    in
      # Declare the OVA as a build product so that it shows up in Hydra.
      hydraJob (runCommand "nixos-ova-${config.system.nixosVersion}-${system}"
        { meta = {
            description = "NixOS VirtualBox appliance (${system})";
            maintainers = maintainers.eelco;
          };
          ova = config.system.build.virtualBoxOVA;
        }
        ''
          mkdir -p $out/nix-support
          fn=$(echo $ova/*.ova)
          echo "file ova $fn" >> $out/nix-support/hydra-build-products
        '');

  nixos = {
    inherit (nixos') channel manual iso_minimal dummy;
    tests = {
      inherit (nixos'.tests)
        containers
        firewall
        ipv6
        login
        misc
        nat
        nfs3
        openssh
        proxy
        simple;
      installer = {
        inherit (nixos'.tests.installer)
          lvm
          separateBoot
          simple;
      };
    };
  };

  nixpkgs = {
    inherit (nixpkgs')
      apacheHttpd_2_2
      apacheHttpd_2_4
      cmake
      cryptsetup
      emacs
      gettext
      git
      imagemagick
      jdk
      linux
      mysql51
      mysql55
      nginx
      nodejs
      openssh
      php
      postgresql92
      postgresql93
      python
      rsyslog
      stdenv
      subversion
      tarball
      vim;
  };

  tested = lib.hydraJob (pkgs.releaseTools.aggregate {
    name = "nixos-${nixos.channel.version}";
    meta = {
      description = "Release-critical builds for the NixOS channel";
      maintainers = [ lib.maintainers.eelco ];
    };
    constituents =
      let all = x: map (system: x.${system}) supportedSystems; in
      [ nixpkgs.tarball
        (all nixpkgs.jdk)
      ]
      ++ lib.collect lib.isDerivation nixos;
  });

}

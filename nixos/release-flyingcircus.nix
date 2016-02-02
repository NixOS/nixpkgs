# This jobset is used to generate a NixOS channel that contains a
# small subset of Nixpkgs, mostly useful for servers that need fast
# security updates.

{ nixpkgs ? { outPath = ./..; revCount = 56789; shortRev = "gfedcba"; }
, stableBranch ? false
, supportedSystems ? [ "x86_64-linux" ] # no i686-linux
}:

with import ../lib;

let

  nixpkgsSrc = nixpkgs; # urgh

  pkgs = import ./.. {};

  system = "x86_64-linux";

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

  # Disable for now as this does what we expect it to do, but we don't really
  # care at the moment.
  #
  #  backy =
  #    let
  #        backy_build = pkgs.fetchhg {
  #		url = https://bitbucket.org/flyingcircus/backy;
  #		# master as of 2015-10-13
  #		rev = "2789e170a93ab2479e3a3cd833e79ba1bf866c1f";
  #		sha256 = "1kz9hgv7ih34d2rzaz1r2i0jiwvxf3qr9xgxww98nghv67c069lh";
  #	    };
  #        backy_release = import "${backy_build}/release.nix";
  #    in backy_release;

  # A bootable Flying Circus disk image (raw) that can be extracted onto
  # Ceph RBD volume.
  flyingcircus_vm_image =
    with import <nixpkgs> { inherit system; };
    with lib;
    let
      config = (import lib/eval-config.nix {
        inherit system;
        modules = [ versionModule
                   ./modules/flyingcircus/fcio.nix
                   ./modules/flyingcircus/vm-base-profile.nix
                   ./modules/flyingcircus/vm-image.nix ];
      }).config;
    in
      # Declare the image as a build product so that it shows up in Hydra.
      hydraJob (runCommand "nixos-flyingcircus-vm-${config.system.nixosVersion}-${system}"
        { meta = {
            description = "NixOS Flying Circus VM bootstrap image (${system})";
            maintainers = maintainers.theuni;
          };
          image = config.system.build.flyingcircusVMImage;
        }
        ''
          mkdir -p $out/nix-support
          echo "file raw $image/image.qcow2.bz2" >> $out/nix-support/hydra-build-products
          ln -s $image/image.qcow2.bz2 $out/
        '');

  nixos = {
    inherit (nixos')
      channel
      manual
      iso_minimal
      dummy;
    tests = {
      inherit (nixos'.tests)
        containers
        firewall
        ipv6
        login
        misc
        nat
        nfs3
        nfs4
        mysql
        networking
        postgresql
        openssh
        proxy
        simple;

# Our custom tests dont work, yet. Our environment specifies too much
# configuration that collides with the testing infrastructure. Need to
# think about that.
#
#      flyingcircus = {
#            users = hydraJob
#              (import tests/fc-users.nix { inherit system; });
#      };
      installer = {
        inherit (nixos'.tests.installer)
          lvm
          separateBoot
          simple;
      };
      latestKernel = {
        inherit (nixos'.tests.latestKernel)
          login;
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
 	      flyingcircus_vm_image
      ]
      ++ lib.collect lib.isDerivation nixos;
  });

}

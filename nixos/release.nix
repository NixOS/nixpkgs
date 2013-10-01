{ nixosSrc ? { outPath = ./.; revCount = 1234; shortRev = "abcdefg"; }
, nixpkgs ? { outPath = <nixpkgs>; revCount = 5678; shortRev = "gfedcba"; }
, officialRelease ? false
}:

let

  version = builtins.readFile ../.version;
  versionSuffix = "pre${toString nixpkgs.revCount}_${nixpkgs.shortRev}";

  systems = [ "x86_64-linux" "i686-linux" ];

  pkgs = import <nixpkgs> { system = "x86_64-linux"; };


  versionModule =
    { system.nixosVersionSuffix = pkgs.lib.optionalString (!officialRelease) versionSuffix;  };


  makeIso =
    { module, type, description ? type, maintainers ? ["eelco"], system }:

    with import <nixpkgs> { inherit system; };

    let

      config = (import lib/eval-config.nix {
        inherit system;
        modules = [ module versionModule { isoImage.isoBaseName = "nixos-${type}"; } ];
      }).config;

      iso = config.system.build.isoImage;

    in
      # Declare the ISO as a build product so that it shows up in Hydra.
      runCommand "nixos-iso-${config.system.nixosVersion}"
        { meta = {
            description = "NixOS installation CD (${description}) - ISO image for ${system}";
            maintainers = map (x: lib.getAttr x lib.maintainers) maintainers;
          };
          inherit iso;
          passthru = { inherit config; };
        }
        ''
          mkdir -p $out/nix-support
          echo "file iso" $iso/iso/*.iso* >> $out/nix-support/hydra-build-products
        ''; # */


  makeSystemTarball =
    { module, maintainers ? ["viric"], system }:

    with import <nixpkgs> { inherit system; };

    let

      config = (import lib/eval-config.nix {
        inherit system;
        modules = [ module versionModule ];
      }).config;

      tarball = config.system.build.tarball;

    in
      tarball //
        { meta = {
            description = "NixOS system tarball for ${system} - ${stdenv.platform.name}";
            maintainers = map (x: lib.getAttr x lib.maintainers) maintainers;
          };
          inherit config;
        };


in {

  tarball =
    pkgs.releaseTools.makeSourceTarball {
      name = "nixos-tarball";

      src = nixosSrc;

      inherit officialRelease version;
      versionSuffix = pkgs.lib.optionalString (!officialRelease) versionSuffix;

      distPhase = ''
        echo -n $VERSION_SUFFIX > .version-suffix
        releaseName=nixos-$VERSION$VERSION_SUFFIX
        mkdir -p $out/tarballs
        mkdir ../$releaseName
        cp -prd . ../$releaseName
        cd ..
        chmod -R u+w $releaseName
        tar cfvj $out/tarballs/$releaseName.tar.bz2 $releaseName
      ''; # */
    };


  channel =
    pkgs.releaseTools.makeSourceTarball {
      name = "nixos-channel";

      src = nixosSrc;

      inherit officialRelease version;
      versionSuffix = pkgs.lib.optionalString (!officialRelease) versionSuffix;

      buildInputs = [ pkgs.nixUnstable ];

      expr = builtins.readFile lib/channel-expr.nix;

      distPhase = ''
        echo -n $VERSION_SUFFIX > .version-suffix
        releaseName=nixos-$VERSION$VERSION_SUFFIX
        mkdir -p $out/tarballs
        mkdir ../$releaseName
        cp -prd . ../$releaseName/nixos
        cp -prd ${nixpkgs} ../$releaseName/nixpkgs
        echo "$expr" > ../$releaseName/default.nix
        NIX_STATE_DIR=$TMPDIR nix-env -f ../$releaseName/default.nix -qaP --meta --xml \* > /dev/null
        cd ..
        chmod -R u+w $releaseName
        tar cfJ $out/tarballs/$releaseName.tar.xz $releaseName
      ''; # */
    };


  manual =
    (import "${nixosSrc}/doc/manual" {
      inherit pkgs;
      options =
        (import lib/eval-config.nix {
          modules = [
            { fileSystems = [];
              boot.loader.grub.device = "/dev/sda";
            } ];
        }).options;
      revision = toString (nixosSrc.rev or nixosSrc.shortRev);
    }).manual;


  iso_minimal = pkgs.lib.genAttrs systems (system: makeIso {
    module = ./modules/installer/cd-dvd/installation-cd-minimal.nix;
    type = "minimal";
    inherit system;
  });

  iso_minimal_new_kernel = pkgs.lib.genAttrs systems (system: makeIso {
    module = ./modules/installer/cd-dvd/installation-cd-minimal-new-kernel.nix;
    type = "minimal-new-kernel";
    inherit system;
  });

  iso_graphical = pkgs.lib.genAttrs systems (system: makeIso {
    module = ./modules/installer/cd-dvd/installation-cd-graphical.nix;
    type = "graphical";
    inherit system;
  });

  # A variant with a more recent (but possibly less stable) kernel
  # that might support more hardware.
  iso_new_kernel = pkgs.lib.genAttrs systems (system: makeIso {
    module = ./modules/installer/cd-dvd/installation-cd-new-kernel.nix;
    type = "new-kernel";
    inherit system;
  });

  # A variant with efi booting support. Once cd-minimal has a newer kernel,
  # this should be enabled by default.
  iso_efi = pkgs.lib.genAttrs systems (system: makeIso {
    module = ./modules/installer/cd-dvd/installation-cd-efi.nix;
    type = "efi";
    maintainers = [ "shlevy" ];
    inherit system;
  });


  # A bootable VirtualBox virtual appliance as an OVA file (i.e. packaged OVF).
  ova = pkgs.lib.genAttrs systems (system:

    with import <nixpkgs> { inherit system; };

    let

      config = (import lib/eval-config.nix {
        inherit system;
        modules =
          [ versionModule
            ./modules/installer/virtualbox-demo.nix
          ];
      }).config;

    in
      # Declare the OVA as a build product so that it shows up in Hydra.
      runCommand "nixos-ova-${config.system.nixosVersion}-${system}"
        { meta = {
            description = "NixOS VirtualBox appliance (${system})";
            maintainers = lib.maintainers.eelco;
          };
          ova = config.system.build.virtualBoxOVA;
        }
        ''
          mkdir -p $out/nix-support
          fn=$(echo $ova/*.ova)
          echo "file ova $fn" >> $out/nix-support/hydra-build-products
        '' # */

  );


  # Provide a tarball that can be unpacked into an SD card, and easily
  # boot that system from uboot (like for the sheevaplug).
  # The pc variant helps preparing the expression for the system tarball
  # in a machine faster than the sheevpalug
  system_tarball_pc = pkgs.lib.genAttrs systems (system: makeSystemTarball {
    module = ./modules/installer/cd-dvd/system-tarball-pc.nix;
    inherit system;
  });

  /*
  system_tarball_fuloong2f =
    assert builtins.currentSystem == "mips64-linux";
    makeSystemTarball {
      module = ./modules/installer/cd-dvd/system-tarball-fuloong2f.nix;
      system = "mips64-linux";
    };

  system_tarball_sheevaplug =
    assert builtins.currentSystem == "armv5tel-linux";
    makeSystemTarball {
      module = ./modules/installer/cd-dvd/system-tarball-sheevaplug.nix;
      system = "armv5tel-linux";
    };
  */


  # Run the tests in ./tests/default.nix for each platform.  You can
  # run a test by doing e.g. "nix-build -A tests.login.x86_64-linux".
  tests =
    with pkgs.lib;
    let
      testsFor = system:
        mapAttrsRecursiveCond (x: !x ? test) (n: v: listToAttrs [(nameValuePair system v.test)])
          (import ./tests { inherit nixpkgs system; });
    in fold recursiveUpdate {} (map testsFor systems);
    
    
  run-in-machine-tests = pkgs.lib.genAttrs systems (system: import ./tests/run-in-machine.nix { inherit nixpkgs system; });
}

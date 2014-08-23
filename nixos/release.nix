{ nixpkgs ? { outPath = ./..; revCount = 56789; shortRev = "gfedcba"; }
, stableBranch ? false
, supportedSystems ? [ "x86_64-linux" "i686-linux" ]
}:

let

  version = builtins.readFile ../.version;
  versionSuffix =
    (if stableBranch then "." else "pre") + "${toString nixpkgs.revCount}.${nixpkgs.shortRev}";

  forAllSystems = pkgs.lib.genAttrs supportedSystems;

  callTest = fn: args: forAllSystems (system: import fn ({ inherit system; } // args));

  pkgs = import nixpkgs { system = "x86_64-linux"; };

  lib = pkgs.lib;


  versionModule =
    { system.nixosVersionSuffix = versionSuffix;
      system.nixosRevision = nixpkgs.rev or nixpkgs.shortRev;
    };


  makeIso =
    { module, type, description ? type, maintainers ? ["eelco"], system }:

    with import nixpkgs { inherit system; };

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

    with import nixpkgs { inherit system; };

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


in rec {

  channel =
    pkgs.releaseTools.makeSourceTarball {
      name = "nixos-channel";

      src = nixpkgs;

      officialRelease = false; # FIXME: fix this in makeSourceTarball
      inherit version versionSuffix;

      buildInputs = [ pkgs.nixUnstable ];

      expr = builtins.readFile lib/channel-expr.nix;

      distPhase = ''
        rm -rf .git
        echo -n $VERSION_SUFFIX > .version-suffix
        echo -n ${nixpkgs.rev or nixpkgs.shortRev} > .git-revision
        releaseName=nixos-$VERSION$VERSION_SUFFIX
        mkdir -p $out/tarballs
        mkdir ../$releaseName
        cp -prd . ../$releaseName/nixpkgs
        chmod -R u+w ../$releaseName
        ln -s nixpkgs/nixos ../$releaseName/nixos
        echo "$expr" > ../$releaseName/default.nix
        NIX_STATE_DIR=$TMPDIR nix-env -f ../$releaseName/default.nix -qaP --meta --xml \* > /dev/null
        cd ..
        chmod -R u+w $releaseName
        tar cfJ $out/tarballs/$releaseName.tar.xz $releaseName
      ''; # */
    };


  manual = forAllSystems (system: (builtins.getAttr system iso_minimal).config.system.build.manual.manual);
  manualPDF = iso_minimal.x86_64-linux.config.system.build.manual.manualPDF;
  manpages = forAllSystems (system: (builtins.getAttr system iso_minimal).config.system.build.manual.manpages);


  iso_minimal = forAllSystems (system: makeIso {
    module = ./modules/installer/cd-dvd/installation-cd-minimal.nix;
    type = "minimal";
    inherit system;
  });

  iso_graphical = forAllSystems (system: makeIso {
    module = ./modules/installer/cd-dvd/installation-cd-graphical.nix;
    type = "graphical";
    inherit system;
  });

  # A variant with a more recent (but possibly less stable) kernel
  # that might support more hardware.
  iso_minimal_new_kernel = forAllSystems (system: makeIso {
    module = ./modules/installer/cd-dvd/installation-cd-minimal-new-kernel.nix;
    type = "minimal-new-kernel";
    inherit system;
  });

  iso_graphical_new_kernel = forAllSystems (system: makeIso {
    module = ./modules/installer/cd-dvd/installation-cd-graphical-new-kernel.nix;
    type = "graphical-new-kernel";
    inherit system;
  });


  # A bootable VirtualBox virtual appliance as an OVA file (i.e. packaged OVF).
  ova = forAllSystems (system:

    with import nixpkgs { inherit system; };

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
  system_tarball_pc = forAllSystems (system: makeSystemTarball {
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


  # Run the tests for each platform.  You can run a test by doing
  # e.g. ‘nix-build -A tests.login.x86_64-linux’, or equivalently,
  # ‘nix-build tests/login.nix -A result’.
  tests.avahi = callTest tests/avahi.nix {};
  tests.bittorrent = callTest tests/bittorrent.nix {};
  tests.containers = callTest tests/containers.nix {};
  tests.firefox = callTest tests/firefox.nix {};
  tests.firewall = callTest tests/firewall.nix {};
  tests.gnome3 = callTest tests/gnome3.nix {};
  tests.installer.efi = forAllSystems (system: (import tests/installer.nix { inherit system; }).efi.test);
  tests.installer.grub1 = forAllSystems (system: (import tests/installer.nix { inherit system; }).grub1.test);
  tests.installer.lvm = forAllSystems (system: (import tests/installer.nix { inherit system; }).lvm.test);
  tests.installer.rebuildCD = forAllSystems (system: (import tests/installer.nix { inherit system; }).rebuildCD.test);
  tests.installer.separateBoot = forAllSystems (system: (import tests/installer.nix { inherit system; }).separateBoot.test);
  tests.installer.simple = forAllSystems (system: (import tests/installer.nix { inherit system; }).simple.test);
  tests.influxdb = callTest tests/influxdb.nix {};
  tests.ipv6 = callTest tests/ipv6.nix {};
  tests.jenkins = callTest tests/jenkins.nix {};
  tests.kde4 = callTest tests/kde4.nix {};
  tests.latestKernel.login = callTest tests/login.nix { latestKernel = true; };
  tests.login = callTest tests/login.nix {};
  tests.logstash = callTest tests/logstash.nix {};
  tests.misc = callTest tests/misc.nix {};
  tests.mumble = callTest tests/mumble.nix {};
  tests.munin = callTest tests/munin.nix {};
  tests.mysql = callTest tests/mysql.nix {};
  tests.mysqlReplication = callTest tests/mysql-replication.nix {};
  tests.nat = callTest tests/nat.nix {};
  tests.nfs3 = callTest tests/nfs.nix { version = 3; };
  tests.openssh = callTest tests/openssh.nix {};
  tests.printing = callTest tests/printing.nix {};
  tests.proxy = callTest tests/proxy.nix {};
  tests.quake3 = callTest tests/quake3.nix {};
  tests.runInMachine = callTest tests/run-in-machine.nix {};
  tests.simple = callTest tests/simple.nix {};
  tests.tomcat = callTest tests/tomcat.nix {};
  tests.udisks2 = callTest tests/udisks2.nix {};
  tests.xfce = callTest tests/xfce.nix {};

}

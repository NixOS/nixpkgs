{ nixpkgs ? { outPath = ./..; revCount = 56789; shortRev = "gfedcba"; }
, stableBranch ? false
, supportedSystems ? [ "x86_64-linux" "i686-linux" ]
}:

let

  version = builtins.readFile ../.version;
  versionSuffix =
    (if stableBranch then "." else "pre") + "${toString nixpkgs.revCount}.${nixpkgs.shortRev}";

  forAllSystems = pkgs.lib.genAttrs supportedSystems;

  scrubDrv = drv: let res = { inherit (drv) drvPath outPath type name system meta; outputName = "out"; out = res; }; in res;

  callTest = fn: args: forAllSystems (system: scrubDrv (import fn ({ inherit system; } // args)));

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
      scrubDrv (runCommand "nixos-iso-${config.system.nixosVersion}"
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
        ''); # */


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


  makeClosure = module: buildFromConfig module (config: config.system.build.toplevel);


  buildFromConfig = module: sel: forAllSystems (system: scrubDrv (sel (import ./lib/eval-config.nix {
    inherit system;
    modules = [ module versionModule ] ++ lib.singleton
      ({ config, lib, ... }:
      { fileSystems."/".device  = lib.mkDefault "/dev/sda1";
        boot.loader.grub.device = lib.mkDefault "/dev/sda";
      });
  }).config));


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


  manual = buildFromConfig ({ pkgs, ... }: { }) (config: config.system.build.manual.manual);
  manualPDF = (buildFromConfig ({ pkgs, ... }: { }) (config: config.system.build.manual.manualPDF)).x86_64-linux;
  manpages = buildFromConfig ({ pkgs, ... }: { }) (config: config.system.build.manual.manpages);


  # Build the initial ramdisk so Hydra can keep track of its size over time.
  initialRamdisk = buildFromConfig ({ pkgs, ... }: { }) (config: config.system.build.initialRamdisk);


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
      scrubDrv (runCommand "nixos-ova-${config.system.nixosVersion}-${system}"
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
        '') # */

  );


  # Ensure that all packages used by the minimal NixOS config end up in the channel.
  dummy = forAllSystems (system: pkgs.runCommand "dummy"
    { toplevel = (import lib/eval-config.nix {
        inherit system;
        modules = lib.singleton ({ config, pkgs, ... }:
          { fileSystems."/".device  = lib.mkDefault "/dev/sda1";
            boot.loader.grub.device = lib.mkDefault "/dev/sda";
          });
      }).config.system.build.toplevel;
    }
    "mkdir $out; ln -s $toplevel $out/dummy");


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
  tests.blivet = callTest tests/blivet.nix {};
  tests.containers = callTest tests/containers.nix {};
  tests.firefox = callTest tests/firefox.nix {};
  tests.firewall = callTest tests/firewall.nix {};
  tests.gnome3 = callTest tests/gnome3.nix {};
  tests.installer.grub1 = forAllSystems (system: scrubDrv (import tests/installer.nix { inherit system; }).grub1.test);
  tests.installer.lvm = forAllSystems (system: scrubDrv (import tests/installer.nix { inherit system; }).lvm.test);
  tests.installer.rebuildCD = forAllSystems (system: scrubDrv (import tests/installer.nix { inherit system; }).rebuildCD.test);
  tests.installer.separateBoot = forAllSystems (system: scrubDrv (import tests/installer.nix { inherit system; }).separateBoot.test);
  tests.installer.simple = forAllSystems (system: scrubDrv (import tests/installer.nix { inherit system; }).simple.test);
  tests.installer.simpleLabels = forAllSystems (system: scrubDrv (import tests/installer.nix { inherit system; }).simpleLabels.test);
  tests.installer.simpleProvided = forAllSystems (system: scrubDrv (import tests/installer.nix { inherit system; }).simpleProvided.test);
  tests.installer.btrfsSimple = forAllSystems (system: scrubDrv (import tests/installer.nix { inherit system; }).btrfsSimple.test);
  tests.installer.btrfsSubvols = forAllSystems (system: scrubDrv (import tests/installer.nix { inherit system; }).btrfsSubvols.test);
  tests.installer.btrfsSubvolDefault = forAllSystems (system: scrubDrv (import tests/installer.nix { inherit system; }).btrfsSubvolDefault.test);
  tests.influxdb = callTest tests/influxdb.nix {};
  tests.ipv6 = callTest tests/ipv6.nix {};
  tests.jenkins = callTest tests/jenkins.nix {};
  tests.kde4 = callTest tests/kde4.nix {};
  tests.latestKernel.login = callTest tests/login.nix { latestKernel = true; };
  tests.login = callTest tests/login.nix {};
  #tests.logstash = callTest tests/logstash.nix {};
  tests.misc = callTest tests/misc.nix {};
  tests.mumble = callTest tests/mumble.nix {};
  tests.munin = callTest tests/munin.nix {};
  tests.mysql = callTest tests/mysql.nix {};
  tests.mysqlReplication = callTest tests/mysql-replication.nix {};
  tests.nat.firewall = callTest tests/nat.nix { withFirewall = true; };
  tests.nat.standalone = callTest tests/nat.nix { withFirewall = false; };
  tests.nfs3 = callTest tests/nfs.nix { version = 3; };
  tests.nsd = callTest tests/nsd.nix {};
  tests.openssh = callTest tests/openssh.nix {};
  tests.printing = callTest tests/printing.nix {};
  tests.proxy = callTest tests/proxy.nix {};
  tests.quake3 = callTest tests/quake3.nix {};
  tests.runInMachine = callTest tests/run-in-machine.nix {};
  tests.simple = callTest tests/simple.nix {};
  tests.tomcat = callTest tests/tomcat.nix {};
  tests.udisks2 = callTest tests/udisks2.nix {};
  tests.xfce = callTest tests/xfce.nix {};


  /* Build a bunch of typical closures so that Hydra can keep track of
     the evolution of closure sizes. */

  closures = {

    smallContainer = makeClosure ({ pkgs, ... }:
      { boot.isContainer = true;
        services.openssh.enable = true;
      });

    tinyContainer = makeClosure ({ pkgs, ... }:
      { boot.isContainer = true;
        imports = [ modules/profiles/minimal.nix ];
      });

    ec2 = makeClosure ({ pkgs, ... }:
      { imports = [ modules/virtualisation/amazon-image.nix ];
      });

    kde = makeClosure ({ pkgs, ... }:
      { services.xserver.enable = true;
        services.xserver.displayManager.kdm.enable = true;
        services.xserver.desktopManager.kde4.enable = true;
      });

    xfce = makeClosure ({ pkgs, ... }:
      { services.xserver.enable = true;
        services.xserver.desktopManager.xfce.enable = true;
      });

    # Linux/Apache/PostgreSQL/PHP stack.
    lapp = makeClosure ({ pkgs, ... }:
      { services.httpd.enable = true;
        services.httpd.adminAddr = "foo@example.org";
        services.postgresql.enable = true;
        services.postgresql.package = pkgs.postgresql93;
        environment.systemPackages = [ pkgs.php ];
      });

  };

}

{ nixpkgs ? { outPath = ./..; revCount = 56789; shortRev = "gfedcba"; }
, stableBranch ? false
, supportedSystems ? [ "x86_64-linux" "i686-linux" ]
}:

with import ../lib;

let

  version = builtins.readFile ../.version;
  versionSuffix =
    (if stableBranch then "." else "pre") + "${toString nixpkgs.revCount}.${nixpkgs.shortRev}";

  forAllSystems = genAttrs supportedSystems;

  importTest = fn: args: system: import fn ({
    inherit system;
  } // args);

  callTest = fn: args: forAllSystems (system: hydraJob (importTest fn args system));

  callSubTests = fn: args: let
    discover = attrs: let
      subTests = filterAttrs (const (hasAttr "test")) attrs;
    in mapAttrs (const (t: hydraJob t.test)) subTests;

    discoverForSystem = system: mapAttrs (_: test: {
      ${system} = test;
    }) (discover (importTest fn args system));

  # If the test is only for a particular system, use only the specified
  # system instead of generating attributes for all available systems.
  in if args ? system then discover (import fn args)
     else foldAttrs mergeAttrs {} (map discoverForSystem supportedSystems);

  pkgs = import nixpkgs { system = "x86_64-linux"; };


  versionModule =
    { system.nixosVersionSuffix = versionSuffix;
      system.nixosRevision = nixpkgs.rev or nixpkgs.shortRev;
    };


  makeIso =
    { module, type, maintainers ? ["eelco"], system }:

    with import nixpkgs { inherit system; };

    hydraJob ((import lib/eval-config.nix {
      inherit system;
      modules = [ module versionModule { isoImage.isoBaseName = "nixos-${type}"; } ];
    }).config.system.build.isoImage);


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
            maintainers = map (x: lib.maintainers.${x}) maintainers;
          };
          inherit config;
        };


  makeClosure = module: buildFromConfig module (config: config.system.build.toplevel);


  buildFromConfig = module: sel: forAllSystems (system: hydraJob (sel (import ./lib/eval-config.nix {
    inherit system;
    modules = [ module versionModule ] ++ singleton
      ({ config, lib, ... }:
      { fileSystems."/".device  = mkDefault "/dev/sda1";
        boot.loader.grub.device = mkDefault "/dev/sda";
      });
  }).config));


in rec {

  channel = import lib/make-channel.nix { inherit pkgs nixpkgs version versionSuffix; };

  manual = buildFromConfig ({ pkgs, ... }: { }) (config: config.system.build.manual.manual);
  manualPDF = (buildFromConfig ({ pkgs, ... }: { }) (config: config.system.build.manual.manualPDF)).x86_64-linux;
  manpages = buildFromConfig ({ pkgs, ... }: { }) (config: config.system.build.manual.manpages);
  options = (buildFromConfig ({ pkgs, ... }: { }) (config: config.system.build.manual.optionsJSON)).x86_64-linux;


  # Build the initial ramdisk so Hydra can keep track of its size over time.
  initialRamdisk = buildFromConfig ({ pkgs, ... }: { }) (config: config.system.build.initialRamdisk);


  netboot = let build = (import lib/eval-config.nix {
      system = "x86_64-linux";
      modules = [
        ./modules/installer/netboot/netboot-minimal.nix
        versionModule
      ];
    }).config.system.build;
  in
    pkgs.symlinkJoin "netboot" [
      build.netbootRamdisk
      build.kernel
      build.netbootIpxeScript
    ];

  iso_minimal = forAllSystems (system: makeIso {
    module = ./modules/installer/cd-dvd/installation-cd-minimal.nix;
    type = "minimal";
    inherit system;
  });

  iso_graphical = genAttrs [ "x86_64-linux" ] (system: makeIso {
    module = ./modules/installer/cd-dvd/installation-cd-graphical-kde.nix;
    type = "graphical";
    inherit system;
  });

  # A variant with a more recent (but possibly less stable) kernel
  # that might support more hardware.
  iso_minimal_new_kernel = genAttrs [ "x86_64-linux" ] (system: makeIso {
    module = ./modules/installer/cd-dvd/installation-cd-minimal-new-kernel.nix;
    type = "minimal-new-kernel";
    inherit system;
  });


  # A bootable VirtualBox virtual appliance as an OVA file (i.e. packaged OVF).
  ova = genAttrs [ "x86_64-linux" ] (system:

    with import nixpkgs { inherit system; };

    hydraJob ((import lib/eval-config.nix {
      inherit system;
      modules =
        [ versionModule
          ./modules/installer/virtualbox-demo.nix
        ];
    }).config.system.build.virtualBoxOVA)

  );


  # Ensure that all packages used by the minimal NixOS config end up in the channel.
  dummy = forAllSystems (system: pkgs.runCommand "dummy"
    { toplevel = (import lib/eval-config.nix {
        inherit system;
        modules = singleton ({ config, pkgs, ... }:
          { fileSystems."/".device  = mkDefault "/dev/sda1";
            boot.loader.grub.device = mkDefault "/dev/sda";
          });
      }).config.system.build.toplevel;
      preferLocalBuild = true;
    }
    "mkdir $out; ln -s $toplevel $out/dummy");


  # Provide a tarball that can be unpacked into an SD card, and easily
  # boot that system from uboot (like for the sheevaplug).
  # The pc variant helps preparing the expression for the system tarball
  # in a machine faster than the sheevpalug
  /*
  system_tarball_pc = forAllSystems (system: makeSystemTarball {
    module = ./modules/installer/cd-dvd/system-tarball-pc.nix;
    inherit system;
  });
  */

  # Provide container tarball for lxc, libvirt-lxc, docker-lxc, ...
  containerTarball = forAllSystems (system: makeSystemTarball {
    module = ./modules/virtualisation/lxc-container.nix;
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
  tests.boot = callSubTests tests/boot.nix {};
  tests.cadvisor = hydraJob (import tests/cadvisor.nix { system = "x86_64-linux"; });
  tests.chromium = callSubTests tests/chromium.nix {};
  tests.cjdns = callTest tests/cjdns.nix {};
  tests.containers-ipv4 = callTest tests/containers-ipv4.nix {};
  tests.containers-ipv6 = callTest tests/containers-ipv6.nix {};
  tests.containers-bridge = callTest tests/containers-bridge.nix {};
  tests.containers-imperative = callTest tests/containers-imperative.nix {};
  tests.docker = hydraJob (import tests/docker.nix { system = "x86_64-linux"; });
  tests.dockerRegistry = hydraJob (import tests/docker-registry.nix { system = "x86_64-linux"; });
  tests.dnscrypt-proxy = callTest tests/dnscrypt-proxy.nix { system = "x86_64-linux"; };
  tests.etcd = hydraJob (import tests/etcd.nix { system = "x86_64-linux"; });
  tests.ec2-nixops = hydraJob (import tests/ec2.nix { system = "x86_64-linux"; }).boot-ec2-nixops;
  tests.ec2-config = hydraJob (import tests/ec2.nix { system = "x86_64-linux"; }).boot-ec2-config;
  tests.firefox = callTest tests/firefox.nix {};
  tests.firewall = callTest tests/firewall.nix {};
  tests.fleet = hydraJob (import tests/fleet.nix { system = "x86_64-linux"; });
  #tests.gitlab = callTest tests/gitlab.nix {};
  tests.gnome3 = callTest tests/gnome3.nix {};
  tests.gnome3-gdm = callTest tests/gnome3-gdm.nix {};
  tests.grsecurity = callTest tests/grsecurity.nix {};
  tests.i3wm = callTest tests/i3wm.nix {};
  tests.installer = callSubTests tests/installer.nix {};
  tests.influxdb = callTest tests/influxdb.nix {};
  tests.ipv6 = callTest tests/ipv6.nix {};
  tests.jenkins = callTest tests/jenkins.nix {};
  tests.kde4 = callTest tests/kde4.nix {};
  tests.keymap = callSubTests tests/keymap.nix {};
  tests.initrdNetwork = callTest tests/initrd-network.nix {};
  tests.kubernetes = hydraJob (import tests/kubernetes.nix { system = "x86_64-linux"; });
  tests.latestKernel.login = callTest tests/login.nix { latestKernel = true; };
  #tests.lightdm = callTest tests/lightdm.nix {};
  tests.login = callTest tests/login.nix {};
  #tests.logstash = callTest tests/logstash.nix {};
  tests.mathics = callTest tests/mathics.nix {};
  tests.misc = callTest tests/misc.nix {};
  tests.mumble = callTest tests/mumble.nix {};
  tests.munin = callTest tests/munin.nix {};
  tests.mysql = callTest tests/mysql.nix {};
  tests.mysqlReplication = callTest tests/mysql-replication.nix {};
  tests.nat.firewall = callTest tests/nat.nix { withFirewall = true; };
  tests.nat.standalone = callTest tests/nat.nix { withFirewall = false; };
  tests.networking.networkd = callSubTests tests/networking.nix { networkd = true; };
  tests.networking.scripted = callSubTests tests/networking.nix { networkd = false; };
  # TODO: put in networking.nix after the test becomes more complete
  tests.networkingProxy = callTest tests/networking-proxy.nix {};
  tests.nfs3 = callTest tests/nfs.nix { version = 3; };
  tests.nfs4 = callTest tests/nfs.nix { version = 4; };
  tests.nsd = callTest tests/nsd.nix {};
  tests.openssh = callTest tests/openssh.nix {};
  tests.panamax = hydraJob (import tests/panamax.nix { system = "x86_64-linux"; });
  tests.peerflix = callTest tests/peerflix.nix {};
  tests.postgresql = callTest tests/postgresql.nix {};
  tests.printing = callTest tests/printing.nix {};
  tests.proxy = callTest tests/proxy.nix {};
  tests.pumpio = callTest tests/pump.io.nix {};
  tests.quake3 = callTest tests/quake3.nix {};
  tests.runInMachine = callTest tests/run-in-machine.nix {};
  tests.sddm = callTest tests/sddm.nix {};
  tests.sddm-kde5 = callTest tests/sddm-kde5.nix {};
  tests.simple = callTest tests/simple.nix {};
  tests.taskserver = callTest tests/taskserver.nix {};
  tests.tomcat = callTest tests/tomcat.nix {};
  tests.udisks2 = callTest tests/udisks2.nix {};
  tests.virtualbox = callSubTests tests/virtualbox.nix { system = "x86_64-linux"; };
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

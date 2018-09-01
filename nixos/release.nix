{ nixpkgs ? { outPath = (import ../lib).cleanSource ./..; revCount = 130979; shortRev = "gfedcba"; }
, stableBranch ? false
, supportedSystems ? [ "x86_64-linux" "aarch64-linux" ]
}:

with import ../pkgs/top-level/release-lib.nix { inherit supportedSystems; };
with import ../lib;

let

  version = fileContents ../.version;
  versionSuffix =
    (if stableBranch then "." else "pre") + "${toString nixpkgs.revCount}.${nixpkgs.shortRev}";

  importTest = fn: args: system: import fn ({
    inherit system;
  } // args);

  # Note: only supportedSystems are considered.
  callTestOnMatchingSystems = systems: fn: args:
    forMatchingSystems
      (intersectLists supportedSystems systems)
      (system: hydraJob (importTest fn args system));
  callTest = callTestOnMatchingSystems supportedSystems;

  callSubTests = callSubTestsOnMatchingSystems supportedSystems;
  callSubTestsOnMatchingSystems = systems: fn: args: let
    discover = attrs: let
      subTests = filterAttrs (const (hasAttr "test")) attrs;
    in mapAttrs (const (t: hydraJob t.test)) subTests;

    discoverForSystem = system: mapAttrs (_: test: {
      ${system} = test;
    }) (discover (importTest fn args system));

  in foldAttrs mergeAttrs {} (map discoverForSystem (intersectLists systems supportedSystems));

  pkgs = import nixpkgs { system = "x86_64-linux"; };


  versionModule =
    { system.nixos.versionSuffix = versionSuffix;
      system.nixos.revision = nixpkgs.rev or nixpkgs.shortRev;
    };


  makeIso =
    { module, type, system, ... }:

    with import nixpkgs { inherit system; };

    hydraJob ((import lib/eval-config.nix {
      inherit system;
      modules = [ module versionModule { isoImage.isoBaseName = "nixos-${type}"; } ];
    }).config.system.build.isoImage);


  makeSdImage =
    { module, system, ... }:

    with import nixpkgs { inherit system; };

    hydraJob ((import lib/eval-config.nix {
      inherit system;
      modules = [ module versionModule ];
    }).config.system.build.sdImage);


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
            description = "NixOS system tarball for ${system} - ${stdenv.hostPlatform.platform.name}";
            maintainers = map (x: lib.maintainers.${x}) maintainers;
          };
          inherit config;
        };


  makeClosure = module: buildFromConfig module (config: config.system.build.toplevel);


  buildFromConfig = module: sel: forAllSystems (system: hydraJob (sel (import ./lib/eval-config.nix {
    inherit system;
    modules = [ module versionModule ] ++ singleton
      ({ ... }:
      { fileSystems."/".device  = mkDefault "/dev/sda1";
        boot.loader.grub.device = mkDefault "/dev/sda";
      });
  }).config));

  makeNetboot = config:
    let
      configEvaled = import lib/eval-config.nix config;
      build = configEvaled.config.system.build;
      kernelTarget = configEvaled.pkgs.stdenv.hostPlatform.platform.kernelTarget;
    in
      pkgs.symlinkJoin {
        name = "netboot";
        paths = [
          build.netbootRamdisk
          build.kernel
          build.netbootIpxeScript
        ];
        postBuild = ''
          mkdir -p $out/nix-support
          echo "file ${kernelTarget} ${build.kernel}/${kernelTarget}" >> $out/nix-support/hydra-build-products
          echo "file initrd ${build.netbootRamdisk}/initrd" >> $out/nix-support/hydra-build-products
          echo "file ipxe ${build.netbootIpxeScript}/netboot.ipxe" >> $out/nix-support/hydra-build-products
        '';
        preferLocalBuild = true;
      };

in rec {

  channel = import lib/make-channel.nix { inherit pkgs nixpkgs version versionSuffix; };

  manual = buildFromConfig ({ ... }: { }) (config: config.system.build.manual.manual);
  manualEpub = (buildFromConfig ({ ... }: { }) (config: config.system.build.manual.manualEpub));
  manpages = buildFromConfig ({ ... }: { }) (config: config.system.build.manual.manpages);
  manualGeneratedSources = buildFromConfig ({ ... }: { }) (config: config.system.build.manual.generatedSources);
  options = (buildFromConfig ({ ... }: { }) (config: config.system.build.manual.optionsJSON)).x86_64-linux;


  # Build the initial ramdisk so Hydra can keep track of its size over time.
  initialRamdisk = buildFromConfig ({ ... }: { }) (config: config.system.build.initialRamdisk);

  netboot = forMatchingSystems [ "x86_64-linux" "aarch64-linux" ] (system: makeNetboot {
    inherit system;
    modules = [
      ./modules/installer/netboot/netboot-minimal.nix
      versionModule
    ];
  });

  iso_minimal = forAllSystems (system: makeIso {
    module = ./modules/installer/cd-dvd/installation-cd-minimal.nix;
    type = "minimal";
    inherit system;
  });

  iso_graphical = forMatchingSystems [ "x86_64-linux" ] (system: makeIso {
    module = ./modules/installer/cd-dvd/installation-cd-graphical-kde.nix;
    type = "graphical";
    inherit system;
  });

  # A variant with a more recent (but possibly less stable) kernel
  # that might support more hardware.
  iso_minimal_new_kernel = forMatchingSystems [ "x86_64-linux" ] (system: makeIso {
    module = ./modules/installer/cd-dvd/installation-cd-minimal-new-kernel.nix;
    type = "minimal-new-kernel";
    inherit system;
  });

  sd_image = forMatchingSystems [ "armv6l-linux" "armv7l-linux" "aarch64-linux" ] (system: makeSdImage {
    module = {
        armv6l-linux = ./modules/installer/cd-dvd/sd-image-raspberrypi.nix;
        armv7l-linux = ./modules/installer/cd-dvd/sd-image-armv7l-multiplatform.nix;
        aarch64-linux = ./modules/installer/cd-dvd/sd-image-aarch64.nix;
      }.${system};
    inherit system;
  });

  # A bootable VirtualBox virtual appliance as an OVA file (i.e. packaged OVF).
  ova = forMatchingSystems [ "x86_64-linux" ] (system:

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
        modules = singleton ({ ... }:
          { fileSystems."/".device  = mkDefault "/dev/sda1";
            boot.loader.grub.device = mkDefault "/dev/sda";
            system.stateVersion = mkDefault "18.03";
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
  tests.atd = callTest tests/atd.nix {};
  tests.acme = callTest tests/acme.nix {};
  tests.avahi = callTest tests/avahi.nix {};
  tests.beegfs = callTest tests/beegfs.nix {};
  tests.bittorrent = callTest tests/bittorrent.nix {};
  tests.bind = callTest tests/bind.nix {};
  tests.blivet = callTest tests/blivet.nix {};
  tests.boot = callSubTests tests/boot.nix {};
  tests.boot-stage1 = callTest tests/boot-stage1.nix {};
  tests.borgbackup = callTest tests/borgbackup.nix {};
  tests.buildbot = callTest tests/buildbot.nix {};
  tests.cadvisor = callTestOnMatchingSystems ["x86_64-linux"] tests/cadvisor.nix {};
  tests.ceph = callTestOnMatchingSystems ["x86_64-linux"] tests/ceph.nix {};
  tests.certmgr = callSubTests tests/certmgr.nix {};
  tests.cfssl = callTestOnMatchingSystems ["x86_64-linux"] tests/cfssl.nix {};
  tests.chromium = (callSubTestsOnMatchingSystems ["x86_64-linux"] tests/chromium.nix {}).stable or {};
  tests.cjdns = callTest tests/cjdns.nix {};
  tests.cloud-init = callTest tests/cloud-init.nix {};
  tests.containers-ipv4 = callTest tests/containers-ipv4.nix {};
  tests.containers-ipv6 = callTest tests/containers-ipv6.nix {};
  tests.containers-bridge = callTest tests/containers-bridge.nix {};
  tests.containers-imperative = callTest tests/containers-imperative.nix {};
  tests.containers-extra_veth = callTest tests/containers-extra_veth.nix {};
  tests.containers-physical_interfaces = callTest tests/containers-physical_interfaces.nix {};
  tests.containers-restart_networking = callTest tests/containers-restart_networking.nix {};
  tests.containers-tmpfs = callTest tests/containers-tmpfs.nix {};
  tests.containers-hosts = callTest tests/containers-hosts.nix {};
  tests.containers-macvlans = callTest tests/containers-macvlans.nix {};
  tests.couchdb = callTest tests/couchdb.nix {};
  tests.deluge = callTest tests/deluge.nix {};
  tests.dhparams = callTest tests/dhparams.nix {};
  tests.docker = callTestOnMatchingSystems ["x86_64-linux"] tests/docker.nix {};
  tests.docker-tools = callTestOnMatchingSystems ["x86_64-linux"] tests/docker-tools.nix {};
  tests.docker-tools-overlay = callTestOnMatchingSystems ["x86_64-linux"] tests/docker-tools-overlay.nix {};
  tests.docker-edge = callTestOnMatchingSystems ["x86_64-linux"] tests/docker-edge.nix {};
  tests.docker-registry = callTest tests/docker-registry.nix {};
  tests.dovecot = callTest tests/dovecot.nix {};
  tests.dnscrypt-proxy = callTestOnMatchingSystems ["x86_64-linux"] tests/dnscrypt-proxy.nix {};
  tests.ecryptfs = callTest tests/ecryptfs.nix {};
  tests.etcd = callTestOnMatchingSystems ["x86_64-linux"] tests/etcd.nix {};
  tests.ec2-nixops = (callSubTestsOnMatchingSystems ["x86_64-linux"] tests/ec2.nix {}).boot-ec2-nixops or {};
  tests.ec2-config = (callSubTestsOnMatchingSystems ["x86_64-linux"] tests/ec2.nix {}).boot-ec2-config or {};
  tests.elk = callSubTestsOnMatchingSystems ["x86_64-linux"] tests/elk.nix {};
  tests.env = callTest tests/env.nix {};
  tests.ferm = callTest tests/ferm.nix {};
  tests.firefox = callTest tests/firefox.nix {};
  tests.flatpak = callTest tests/flatpak.nix {};
  tests.firewall = callTest tests/firewall.nix {};
  tests.fsck = callTest tests/fsck.nix {};
  tests.fwupd = callTest tests/fwupd.nix {};
  tests.gdk-pixbuf = callTest tests/gdk-pixbuf.nix {};
  #tests.gitlab = callTest tests/gitlab.nix {};
  tests.gitolite = callTest tests/gitolite.nix {};
  tests.gjs = callTest tests/gjs.nix {};
  tests.gocd-agent = callTest tests/gocd-agent.nix {};
  tests.gocd-server = callTest tests/gocd-server.nix {};
  tests.gnome3 = callTest tests/gnome3.nix {};
  tests.gnome3-gdm = callTest tests/gnome3-gdm.nix {};
  tests.grafana = callTest tests/grafana.nix {};
  tests.graphite = callTest tests/graphite.nix {};
  tests.hadoop.hdfs = callTestOnMatchingSystems [ "x86_64-linux" ] tests/hadoop/hdfs.nix {};
  tests.hadoop.yarn = callTestOnMatchingSystems [ "x86_64-linux" ] tests/hadoop/yarn.nix {};
  tests.hardened = callTest tests/hardened.nix { };
  tests.haproxy = callTest tests/haproxy.nix {};
  tests.hibernate = callTest tests/hibernate.nix {};
  tests.hitch = callTest tests/hitch {};
  tests.home-assistant = callTest tests/home-assistant.nix { };
  tests.hound = callTest tests/hound.nix {};
  tests.hocker-fetchdocker = callTest tests/hocker-fetchdocker {};
  tests.hydra = callTest tests/hydra {};
  tests.i3wm = callTest tests/i3wm.nix {};
  tests.iftop = callTest tests/iftop.nix {};
  tests.initrd-network-ssh = callTest tests/initrd-network-ssh {};
  tests.installer = callSubTests tests/installer.nix {};
  tests.influxdb = callTest tests/influxdb.nix {};
  tests.ipv6 = callTest tests/ipv6.nix {};
  tests.jenkins = callTest tests/jenkins.nix {};
  tests.ostree = callTest tests/ostree.nix {};
  tests.osquery = callTest tests/osquery.nix {};
  tests.plasma5 = callTest tests/plasma5.nix {};
  tests.plotinus = callTest tests/plotinus.nix {};
  tests.keymap = callSubTests tests/keymap.nix {};
  tests.initrdNetwork = callTest tests/initrd-network.nix {};
  tests.kafka = callSubTests tests/kafka.nix {};
  tests.kernel-copperhead = callTest tests/kernel-copperhead.nix {};
  tests.kernel-latest = callTest tests/kernel-latest.nix {};
  tests.kernel-lts = callTest tests/kernel-lts.nix {};
  tests.kubernetes.dns = callSubTestsOnMatchingSystems ["x86_64-linux"] tests/kubernetes/dns.nix {};
  ## kubernetes.e2e should eventually replace kubernetes.rbac when it works
  #tests.kubernetes.e2e = callSubTestsOnMatchingSystems ["x86_64-linux"] tests/kubernetes/e2e.nix {};
  tests.kubernetes.rbac = callSubTestsOnMatchingSystems ["x86_64-linux"] tests/kubernetes/rbac.nix {};
  tests.latestKernel.login = callTest tests/login.nix { latestKernel = true; };
  tests.ldap = callTest tests/ldap.nix {};
  #tests.lightdm = callTest tests/lightdm.nix {};
  tests.login = callTest tests/login.nix {};
  #tests.logstash = callTest tests/logstash.nix {};
  tests.mathics = callTest tests/mathics.nix {};
  tests.matrix-synapse = callTest tests/matrix-synapse.nix {};
  tests.memcached = callTest tests/memcached.nix {};
  tests.mesos = callTest tests/mesos.nix {};
  tests.misc = callTest tests/misc.nix {};
  tests.mongodb = callTest tests/mongodb.nix {};
  tests.mpd = callTest tests/mpd.nix {};
  tests.mumble = callTest tests/mumble.nix {};
  tests.munin = callTest tests/munin.nix {};
  tests.mutableUsers = callTest tests/mutable-users.nix {};
  tests.mysql = callTest tests/mysql.nix {};
  tests.mysqlBackup = callTest tests/mysql-backup.nix {};
  tests.mysqlReplication = callTest tests/mysql-replication.nix {};
  tests.nat.firewall = callTest tests/nat.nix { withFirewall = true; };
  tests.nat.firewall-conntrack = callTest tests/nat.nix { withFirewall = true; withConntrackHelpers = true; };
  tests.nat.standalone = callTest tests/nat.nix { withFirewall = false; };
  tests.netdata = callTest tests/netdata.nix { };
  tests.networking.networkd = callSubTests tests/networking.nix { networkd = true; };
  tests.networking.scripted = callSubTests tests/networking.nix { networkd = false; };
  # TODO: put in networking.nix after the test becomes more complete
  tests.networkingProxy = callTest tests/networking-proxy.nix {};
  tests.nexus = callTest tests/nexus.nix { };
  tests.nfs3 = callTest tests/nfs.nix { version = 3; };
  tests.nfs4 = callTest tests/nfs.nix { version = 4; };
  tests.nginx = callTest tests/nginx.nix { };
  tests.nghttpx = callTest tests/nghttpx.nix { };
  tests.nix-ssh-serve = callTest tests/nix-ssh-serve.nix { };
  tests.novacomd = callTestOnMatchingSystems ["x86_64-linux"] tests/novacomd.nix { };
  tests.leaps = callTest tests/leaps.nix { };
  tests.nsd = callTest tests/nsd.nix {};
  tests.openssh = callTest tests/openssh.nix {};
  tests.openldap = callTest tests/openldap.nix {};
  tests.opensmtpd = callTest tests/opensmtpd.nix {};
  tests.owncloud = callTest tests/owncloud.nix {};
  tests.pam-oath-login = callTest tests/pam-oath-login.nix {};
  tests.peerflix = callTest tests/peerflix.nix {};
  tests.php-pcre = callTest tests/php-pcre.nix {};
  tests.postgresql = callSubTests tests/postgresql.nix {};
  tests.pgmanage = callTest tests/pgmanage.nix {};
  tests.postgis = callTest tests/postgis.nix {};
  tests.powerdns = callTest tests/powerdns.nix {};
  #tests.pgjwt = callTest tests/pgjwt.nix {};
  tests.predictable-interface-names = callSubTests tests/predictable-interface-names.nix {};
  tests.printing = callTest tests/printing.nix {};
  tests.prometheus = callTest tests/prometheus.nix {};
  tests.prosody = callTest tests/prosody.nix {};
  tests.proxy = callTest tests/proxy.nix {};
  tests.quagga = callTest tests/quagga.nix {};
  tests.quake3 = callTest tests/quake3.nix {};
  tests.rabbitmq = callTest tests/rabbitmq.nix {};
  tests.radicale = callTest tests/radicale.nix {};
  tests.rspamd = callSubTests tests/rspamd.nix {};
  tests.runInMachine = callTest tests/run-in-machine.nix {};
  tests.rxe = callTest tests/rxe.nix {};
  tests.samba = callTest tests/samba.nix {};
  tests.sddm = callSubTests tests/sddm.nix {};
  tests.simple = callTest tests/simple.nix {};
  tests.slim = callTest tests/slim.nix {};
  tests.slurm = callTest tests/slurm.nix {};
  tests.smokeping = callTest tests/smokeping.nix {};
  tests.snapper = callTest tests/snapper.nix {};
  tests.statsd = callTest tests/statsd.nix {};
  tests.strongswan-swanctl = callTest tests/strongswan-swanctl.nix {};
  tests.sudo = callTest tests/sudo.nix {};
  tests.systemd = callTest tests/systemd.nix {};
  tests.switchTest = callTest tests/switch-test.nix {};
  tests.taskserver = callTest tests/taskserver.nix {};
  tests.tomcat = callTest tests/tomcat.nix {};
  tests.tor = callTest tests/tor.nix {};
  tests.transmission = callTest tests/transmission.nix {};
  tests.udisks2 = callTest tests/udisks2.nix {};
  tests.vault = callTest tests/vault.nix {};
  tests.virtualbox = callSubTestsOnMatchingSystems ["x86_64-linux"] tests/virtualbox.nix {};
  tests.wordpress = callTest tests/wordpress.nix {};
  tests.xautolock = callTest tests/xautolock.nix {};
  tests.xdg-desktop-portal = callTest tests/xdg-desktop-portal.nix {};
  tests.xfce = callTest tests/xfce.nix {};
  tests.xmonad = callTest tests/xmonad.nix {};
  tests.xrdp = callTest tests/xrdp.nix {};
  tests.xss-lock = callTest tests/xss-lock.nix {};
  tests.yabar = callTest tests/yabar.nix {};
  tests.zookeeper = callTest tests/zookeeper.nix {};
  tests.morty = callTest tests/morty.nix { };
  tests.bcachefs = callTest tests/bcachefs.nix { };

  /* Build a bunch of typical closures so that Hydra can keep track of
     the evolution of closure sizes. */

  closures = {

    smallContainer = makeClosure ({ ... }:
      { boot.isContainer = true;
        services.openssh.enable = true;
      });

    tinyContainer = makeClosure ({ ... }:
      { boot.isContainer = true;
        imports = [ modules/profiles/minimal.nix ];
      });

    ec2 = makeClosure ({ ... }:
      { imports = [ modules/virtualisation/amazon-image.nix ];
      });

    kde = makeClosure ({ ... }:
      { services.xserver.enable = true;
        services.xserver.displayManager.sddm.enable = true;
        services.xserver.desktopManager.plasma5.enable = true;
      });

    xfce = makeClosure ({ ... }:
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

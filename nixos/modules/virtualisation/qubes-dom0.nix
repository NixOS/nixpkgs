{
  lib,
  pkgs,
  config,
  ...
}: let
  inherit (lib) mkEnableOption mkIf optional mkOption stringAfter optionalAttrs optionals;
  inherit (lib.types) listOf path str enum;
  inherit (pkgs) qubes-linux-utils qubes-core-qubesdb qubes-core-libvirt qubes-gui-daemon qubes-vmm-xen qubes-artwork qubes-desktop-linux-kde qemu_qubes qubes-manager runCommand symlinkJoin qubes-core-admin-linux;
  inherit (pkgs.python3Packages) qubes-core-admin qubes-core-qrexec qubes-desktop-linux-common qubes-core-admin-client qubes-app-linux-usb-proxy;

  cfg = config.virtualisation.qubes;

  anyEnabled = cfg.dom0.enable || cfg.sys-net.enable || cfg.sys-usb.enable || cfg.sys-gui.enable;
  isDom0 = cfg.dom0.enable;
  isDomU = anyEnabled && !isDom0;

  optOutFlags = [
    # Configure networkmanager to use random MAC
    "randomise-mac"
    # It is possible to run qubes securely with SMT enabled, however
    # neither qubes nixos module nor QubesOS itself is not configured
    # out of the box for that.
    "disable-smt"
    # qubes expects adminvm to have hostname dom0.
    "hostname-dom0"
    # sys-gui is considered advanced.
    "dom0-is-gui"
    # Qubes disables most of USB in dom0 by default.
    # This might be problematic for PC
    "dom0-restricted-usb"
    # when disabled - dom0 has ability to be sys-net/sys-usb
    "dedicated-sys-net"
    "dedicated-sys-usb"
  ];

  # Is recommended option enabled?
  recommended = flag:
    assert (builtins.elem flag optOutFlags);
      !(builtins.elem flag cfg.optOutRecommendedConfiguration);
in {
  # Bug:
  #   Loopback vchan connection not supported
  #   FATAL: vchan initialization failed
  # Solution: Xenstore has no set domid
  #   It can be set manually using
  #   `run0 xenstore-write "/domid" 0`
  #   However it should always be set by default by something,
  #   and I am not sure how/where.
  # FIXME: Is this still relevant? I don't remember where I have encountered this error,
  # but I no longer have this problem.

  # Bug:
  #   Not enough memory during start of VM
  # Solution:
  #   Qubes memory manager overrides max memory of dom0 with
  #   total memory available, you need to set memory limit for it.
  #   I have no idea what writes this memory limit in QubesOS, but
  #   it can be set manually:
  #   `run0 xenstore-write /local/domain/0/memory/static-max 100000000`
  #   Note that the standard `xl mem-set` doesn't work for that, as it
  #   uses /vm/uuid/memory field instead.
  # FIXME: Permanent solution needed.

  # Current security policy.
  # QubesOS assumes there is only one user of the machine, and he is trusted
  # to do anything. QubesOS disables sudo password/grants everything via polkit

  options.virtualisation.qubes = {
    dom0.enable = mkEnableOption "Qubes";
    secure =
      (mkEnableOption ''
        Follow QubesOS security model as close as possible.

        Do not disable unles you absolutely know what're you doing.
      '')
      // {
        default = true;
        visible = false;
      };
    optOutRecommendedConfiguration = mkOption {
      description = ''
        Opt-out of recommended QubesOS configuration options.

        Do not use unless you know what're you doing.
      '';
      type = listOf (enum optOutFlags);
      default = [];
    };
    user = mkOption {
      description = ''
        Which user will have to QubesOS

        QubesOS is fundamentally bound to single user. It is possible to
        have multiple users on machine and give access to qubes only to one,
        but it probably won't work well, many Qubes services assume there
        is one and only one user in "qubes" group.
      '';
      type = str;
    };
    # Shared with domU
    sys-net.enable = mkEnableOption "Install sys-net components into dom0";
    sys-usb.enable = mkEnableOption "Install sys-usb components into dom0";
    sys-gui.enable = mkEnableOption "Install sys-gui components into dom0";
    # Can be shared with domU, I think?
    packages = mkOption {
      description = ''
        Packages providing qubes configuration files.

        They might contain:
        - /etc/qubes-rpc
        - /etc/qubes/policy.d
        - /etc/qubes/suspend-pre.d - TODO
        - /etc/qubes/rpc-config - TODO
      '';
      type = listOf path;
      default = [];
    };
    # policy.mutablePolicy = mkEnableOption?
  };
  config = mkIf cfg.dom0.enable {
    assertions = [
      {
        assertion = isDom0 -> !(recommended "dedicated-sys-net") && !(recommended "dedicated-sys-usb");
        message = "Do not rely exclusively dedicated sys-net/sys-usb, they're not ready yet";
      }
      {
        # Is there not recommended options which don't conflict with Qubes security model?
        # For now assume there is not, secure is not possible to enable anyway.
        assertion = cfg.secure -> (cfg.optOutRecommendedConfiguration == []);
        message = "QubesOS security model depends on some of recommended configuration options.";
      }
      {
        # Require user to explicitly opt-out of QubesOS security model, which is not implemented
        # and partially not applicable for NixOS-Qubes module deployment right now.
        assertion = !cfg.secure;
        message = "QubesOS security model is not implemented yet.";
      }
    ];

    virtualisation.qubes = {
      sys-gui.enable = mkIf (isDom0 && recommended "dom0-is-gui") true;
      sys-net.enable = mkIf (isDom0 && !(recommended "dedicated-sys-net")) true;
      sys-usb.enable = mkIf (isDom0 && !(recommended "dedicated-sys-usb")) true;
    };

    # Some of Qubes apps require host name to match domain name.
    # There is a bypass implemented in qubesd-dom0 service, but it might
    # not work for everyone.
    networking.hostName = mkIf (isDom0 && recommended "hostname-dom0") "dom0";

    users.groups.qubes.gid = config.ids.gids.qubes;
    users.users.${cfg.user}.extraGroups = ["qubes"];
    # xl create needs to allocate and mlock all VM memory
    security.pam.loginLimits = [
      {
        domain = "@qubes";
        type = "soft";
        item = "memlock";
        value = "unlimited";
      }
      {
        domain = "@qubes";
        type = "hard";
        item = "memlock";
        value = "unlimited";
      }
    ];

    systemd.tmpfiles.packages = [
      qubes-core-admin
      qubes-linux-utils
    ];
    systemd.tmpfiles.settings."10-qubes" =
      {
        # Qubes daemons are configured to install qube autostart units here
        "/etc/systemd-mutable/system/multi-user.target.wants".d = {};
        # Idk what is supposed to make this directory
        "/var/log/qubes".d = {
          user = "root";
          group = "qubes";
          mode = "770";
        };
      }
      // optionalAttrs cfg.dom0.enable {
        # Used to recognize if current system is qubes dom0.
        # https://github.com/QubesOS/qubes-core-admin-client/blob/d9db37fdae9aaf91dec993b5dd111e02e66f782d/qubesadmin/__init__.py#L31
        "/etc/qubes-release".f = {};
        # Created by qubes-core-admin during installation
        "/var/log/qubes".d = {
          user = "root";
          group = "qubes";
          mode = "770";
        };
        "/var/lib/qubes/appvms".d = {
          user = "root";
          group = "qubes";
          mode = "700";
        };
        "/var/lib/qubes/backup".d = {
          user = "root";
          group = "qubes";
          mode = "700";
        };
        "/var/lib/qubes/vm-kernels".d = {
          user = "root";
          group = "qubes";
          mode = "700";
        };
        "/var/lib/qubes/vm-templates".d = {
          user = "root";
          group = "qubes";
          mode = "700";
        };
      };

    # Conflicting with libxl according to qubes
    systemd.services.xend.enable = false;
    systemd.services.xendomains.enable = false;

    systemd.services.qubes-db = {
      enable = isDomU;
      wantedBy = ["multi-user.target"];
      after = ["systemd-tmpfiles-setup.service"];
    };
    systemd.services.qubes-db-dom0 = {
      enable = isDom0;
      wantedBy = ["multi-user.target"];
      after = ["systemd-tmpfiles-setup.service"];
      # Some of Qubes utilities have two ways of receiving hostname: reading uname, and reading qubesdb /name key.
      #
      # They also assume hostname matches domain name, and dom0 name can't be changed.
      # Either networking.hostName needs to be forced in this module, or there be added a workaround for domain name.
      # This is an implementation of second fix, it might not work somewhere.
      # Works for me, though.
      serviceConfig.ExecStartPost = "${qubes-core-qubesdb}/bin/qubesdb-write /name dom0";
    };
    systemd.services.qubesd = {
      enable = isDom0;
      wantedBy = ["multi-user.target"];
      before = ["systemd-user-sessions.service"];
    };
    systemd.services.qubes-qmemman = {
      enable = isDom0;
      wantedBy = ["multi-user.target"];
    };
    systemd.services.qubes-meminfo-writer = {
      enable = isDomU;
      wantedBy = ["multi-user.target"];
      before = ["systemd-user-sessions.service"];
    };
    systemd.services.qubes-meminfo-writer-dom0 = {
      enable = isDom0;
      wantedBy = ["multi-user.target"];
      before = ["systemd-user-sessions.service"];
      after = ["qubes-core.service" "qubes-qmemman.service"];
    };
    systemd.services.qubes-core = {
      enable = isDom0;
      wantedBy = ["multi-user.target"];
      aliases = ["qubes_core.service"];
    };
    systemd.services."qubes-vm@" = {
      enable = isDom0;
      after = ["qubesd.service" "qubes-meminfo-writer-dom0.service"];
    };
    systemd.services."qubes-reload-firewall@" = {
      # FIXME: I don't fully understand how it is supposed to work in NixOS
    };

    systemd.services.qubes-qrexec-agent = {
      enable = isDomU;
      wantedBy = ["multi-user.target"];
      aliases = ["qubes-core-agent.service"];
      after = ["xendriverdomain.service" "systemd-user-sessions.service"];
    };
    systemd.services.qubes-qrexec-policy-daemon = {
      enable = isDom0;
      wantedBy = ["multi-user.target"];
      after = ["qubesd.service"];
    };

    virtualisation.libvirtd = mkIf isDom0 {
      enable = true;
      package = qubes-core-libvirt;
    };
    environment.etc = {
      # "/*" at the end to make qubes-rpc directory writable.
      # Unfortunately, services like policy.Eval{Gui,Simple} are creating rpc socket
      # only when they actually started. TODO: Patch patckages to work with immutable qubes-rpc directory
      "qubes-rpc".source = "${symlinkJoin {
        name = "etc-qubes-rpc";
        paths = cfg.packages;
        stripPrefix = "/etc/qubes-rpc";
        postBuild = "mv $out/policy $out/policy.static";
      }}/*";
      # We might want to drop policy.d/include directory from
      # every package, and then declare it using NixOS config?
      "qubes/policy.d".source = symlinkJoin {
        name = "etc-qubes-policy-d";
        paths = cfg.packages;
        stripPrefix = "/etc/qubes/policy.d";
      };
      "xen/scripts-qubes" = {
        source = "${qubes-linux-utils}/etc/xen/scripts/*";
        target = "xen/scripts";
      };
      # This file describes itself as "not used", and "only here for reference", but guid is actually
      # using it...
      "qubes/guid.conf" = mkIf isDom0 {
        source = "${qubes-gui-daemon}/etc/qubes/guid.conf";
      };
    };

    # Some qubes daemons write to legacy policy directory at runtime.
    system.etc.overlay.mutable = true;
    # FIXME: When package is removed, its old policy will remain in etc.
    # TODO: Test with etc overlays. setup-etc preserves old files, but with overlays
    # it might require to evacuate runtime policy - install etc - move runtime policy back.
    system.activationScripts.etc-qubes-rpc = stringAfter ["etc"] ''
      echo "setting up qubes rpc..."
      mkdir -p /etc/qubes-rpc/policy
      cp -rf /etc/qubes-rpc/policy.static/* /etc/qubes-rpc/policy
    '';

    systemd.packages =
      [
        qubes-core-qubesdb.daemon # both domU and dom0
        qubes-linux-utils
      ]
      ++ optional isDomU [
        qubes-core-qrexec.domU
      ]
      ++ optionals isDom0 [
        qubes-core-admin
        qubes-core-qrexec.dom0
      ];

    virtualisation.qubes.packages =
      [
        qubes-core-qrexec
        qubes-desktop-linux-common
        # Legacy policy directory, wanted by qrexec.
        (runCommand "legacy-policy-stub" {} ''
          mkdir -p $out/etc/qubes-rpc/policy
        '')
      ]
      ++ optionals isDom0 [
        qubes-core-admin
        qubes-app-linux-usb-proxy
        qubes-core-qrexec.dom0
      ]
      ++ optionals isDomU [
        qubes-core-qrexec.domU
      ]
      # clipboard/window icons access;
      ++ optional cfg.sys-gui.enable qubes-gui-daemon
      # FIXME: also has qubes/suspend-pre.d
      ++ optional cfg.sys-usb.enable qubes-app-linux-usb-proxy.sys-usb;

    services.udev.packages =
      [
        qubes-linux-utils
      ]
      ++ optional isDom0 qubes-core-admin-linux
      ++ optional cfg.sys-usb.enable qubes-app-linux-usb-proxy.sys-usb;

    virtualisation.xen = mkIf isDom0 {
      enable = true;
      package = qubes-vmm-xen;
      store.path = "${qubes-vmm-xen}/bin/xenstored";
      qemu.package = qemu_qubes;

      bootParams =
        [
          "gnttab_max_frames=2048"
          "gnttab_max_maptrack_frames=4096"
        ]
        ++ optional (recommended "disable-smt") "smt=off";

      # TODO: Add declarative xl.conf
      # settings = {
      #   autoballoon = "0";
      #   lockfile = "/var/run/qubes/xl-lock";
      # };
    };

    # FIXME: Similar wrapping wanted for xserver
    # I don't use xorg, and have no easy way to test that.
    # FIXME: Some of desktop-managers don't use xwayland.package option,
    # instead adding xwayland directly to systemPackages, they need to be fixed.
    programs.xwayland.package = mkIf cfg.sys-gui.enable qubes-gui-daemon.xwayland;

    # TODO: qrexec-domU pam.d

    environment.systemPackages =
      [
        qubes-core-qubesdb # qubesdb-read, qubesdb-write, ...
        qubes-core-qrexec

        # Those are not technically optional, but might be disabled for non-gui nixos?
        # qvm-appmenus - expected in $PATH by some tools, TODO: patch/wrap packages instead?
        qubes-desktop-linux-common
        qubes-linux-utils # contains icons
        qubes-core-admin-client # qvm-* CLI tools, xdg-autostart
      ]
      ++ optionals isDom0 [
        qubes-manager # qubes-qube-manager
        qubes-core-admin # qvm-console-dispvm
        qubes-artwork # qubes icons/wallpapers
        qubes-gui-daemon # xdg-autostart
        qubes-core-qrexec.dom0
        qubes-core-admin-linux # qvm-copy
      ]
      ++ optionals isDomU [
        qubes-core-qrexec.domU
      ]
      # I'm too lazy to do plasma support, but not enough lazy to not write this message.
      ++ optionals (isDom0 && config.services.desktopManager.plasma6.enable) [
        qubes-desktop-linux-kde
        pkgs.kdePackages.kdialog
      ]
      # qrexec-base contains both xdg-autostart gui agent and utilities for dom0.
      ++ optional (isDom0 || cfg.sys-gui.enable) qubes-core-qrexec;

    # qubes-core-agent-linux also configures NM to use rc-manager=file,
    # but it should work with rc-manager=resolvconf too, if resolvconf will call hooks,
    # which are originally called by dhclient. Oh boy
    # TODO: share with domU, make optional for non-networked vm
    networking.networkmanager.settings = mkIf (cfg.sys-net.enable && recommended "randomise-mac") {
      device."wifi.scan-rand-mac-address" = "yes";
      connection = {
        "wifi.cloned-mac-address" = "stable";
        "connection.stable-id" = "\${CONNECTION}/\${BOOT}";
        "ipv6.ipv6-privacy" = "2";
      };
    };

    services.usbguard = mkIf (isDom0 && recommended "dom0-restricted-usb") {
      enable = true;
      IPCAllowedGroups = ["qubes"];
      AuditBackend = "LinuxAudit";
      # HidePII?

      # Use the port number in generated rules.  The port number is unstable,
      # but this is due to a bug in Qubes OS, and everything else is spoofable :(
      # https://github.com/QubesOS/qubes-core-admin-linux/blob/fc9e5a13b123d90e43ffeaf274484df2394d7554/system-config/qubes-usbguard.conf#L26-L28
      deviceRulesWithPort = true;
      implicitPolicyTarget = "block";
      presentDevicePolicy = "apply-policy";
      presentControllerPolicy = "apply-policy";
      insertedDevicePolicy = "apply-policy";
      restoreControllerDeviceState = false;

      packages = [
        qubes-core-admin-linux # allows usb hubs/hid devices
      ];
    };

    services.pipewire.extraConfig.pipewire."10-qubes" = {
      # In dom0, PipeWire doesn't realize it is running in a VM.
      # Therefore, it chooses low quantum values and xruns due
      # to Xen descheduling dom0.
      "context.properties" = {
        "default.clock.min-quantum" = 1024;
      };
    };

    # Qubes uses mutable services for some tasks, e.g vm autostart,
    # packages are patched to use this directory for it.
    boot.extraSystemdUnitPaths = ["/etc/systemd-mutable/system"];

    # TODO: Some modules might be moved around depending on role.
    boot.kernelModules =
      [
        "xen-evtchn"
        "xen-gntalloc"
        "xen-gntdev"
        "xen-privcmd"

        "cpufreq-xen"
        "xen-acpi-processor"
      ]
      ++ optionals isDom0 [
        "xen-pciback"
      ]
      ++ optional cfg.sys-usb.enable "xen-blkback";

    # It is possible to have VMs backed by filesystem, but lets assume configuration preferred by
    # QubesOS - VM thin pool.
    # I haven't figured out why it is required, but manual vgchange -a y qubes-pool is required if only dm-thin-pool module is present.
    services.lvm.boot.thin.enable = mkIf isDom0 true;
  };
}

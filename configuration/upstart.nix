{config, pkgs, nix, splashThemes}:

let 

  makeJob = import ../upstart-jobs/make-job.nix {
    inherit (pkgs) runCommand;
  };

  optional = option: service:
    if config.get option then [(makeJob service)] else [];

in

import ../upstart-jobs/gather.nix {
  inherit (pkgs) runCommand;

  jobs = map makeJob [
    # Syslogd.
    (import ../upstart-jobs/syslogd.nix {
      inherit (pkgs) sysklogd;
    })

    # The udev daemon creates devices nodes and runs programs when
    # hardware events occur.
    (import ../upstart-jobs/udev.nix {
      inherit (pkgs) writeText cleanSource udev procps;
    })
      
    # Hardware scan; loads modules for PCI devices.
    (import ../upstart-jobs/hardware-scan.nix {
      inherit (pkgs) kernel module_init_tools;
    })
      
    # Mount file systems.
    (import ../upstart-jobs/filesystems.nix {
      inherit (pkgs) utillinux e2fsprogs;
      fileSystems = config.get ["fileSystems"];
    })

    # Swapping.
    (import ../upstart-jobs/swap.nix {
      inherit (pkgs) utillinux;
      swapDevices = config.get ["swapDevices"];
    })

    # Network interfaces.
    (import ../upstart-jobs/network-interfaces.nix {
      inherit (pkgs) nettools kernel module_init_tools;
    })
      
    # DHCP client.
    (import ../upstart-jobs/dhclient.nix {
      inherit (pkgs) nettools;
      dhcp = pkgs.dhcpWrapper;
    })

    # Nix daemon - required for multi-user Nix.
    (import ../upstart-jobs/nix-daemon.nix {
      inherit nix;
    })

    # Transparent TTY backgrounds.
    (import ../upstart-jobs/tty-backgrounds.nix {
      inherit (pkgs) stdenv splashutils;
      backgrounds = splashThemes.ttyBackgrounds;
    })

    # Handles the maintenance/stalled event (single-user shell).
    (import ../upstart-jobs/maintenance-shell.nix {
      inherit (pkgs) bash;
    })

    # Ctrl-alt-delete action.
    (import ../upstart-jobs/ctrl-alt-delete.nix)

  ]

  # SSH daemon.
  ++ optional ["services" "sshd" "enable"]
    (import ../upstart-jobs/sshd.nix {
      inherit (pkgs) openssh glibc pwdutils;
    })

  # NTP daemon.
  ++ optional ["services" "ntp" "enable"]
    (import ../upstart-jobs/ntpd.nix {
      inherit (pkgs) ntp kernel module_init_tools glibc pwdutils writeText;
      servers = config.get ["services" "ntp" "servers"];
    })

  # X server.
  ++ optional ["services" "xserver" "enable"]
    (import ../upstart-jobs/xserver.nix {
      inherit (pkgs) substituteAll;
      inherit (pkgs.xorg) xorgserver xf86inputkeyboard xf86inputmouse xf86videovesa;
    })

  # Apache httpd.
  ++ optional ["services" "httpd" "enable"]
    (import ../upstart-jobs/httpd.nix {
      inherit config pkgs;
      inherit (pkgs) glibc pwdutils;
    })

  # Handles the reboot/halt events.
  ++ (map
    (event: makeJob (import ../upstart-jobs/halt.nix {
      inherit (pkgs) bash utillinux;
      inherit event;
    }))
    ["reboot" "halt" "system-halt" "power-off"]
  )
    
  # The terminals on ttyX.
  ++ (map 
    (ttyNumber: makeJob (import ../upstart-jobs/mingetty.nix {
      inherit (pkgs) mingetty pam_login;
      inherit ttyNumber;
    }))
    (config.get ["services" "mingetty" "ttys"])
  )

  # User-defined events.
  ++ (map makeJob (config.get ["services" "extraJobs"]))

  # For the built-in logd job.
  ++ [pkgs.upstart];
  
}

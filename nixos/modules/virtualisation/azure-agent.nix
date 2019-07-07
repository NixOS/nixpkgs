{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.virtualisation.azure.agent;

  waagent = with pkgs; stdenv.mkDerivation rec {
    name = "waagent-2.0";
    src = pkgs.fetchFromGitHub {
      owner = "Azure";
      repo = "WALinuxAgent";
      rev = "1b3a8407a95344d9d12a2a377f64140975f1e8e4";
      sha256 = "10byzvmpgrmr4d5mdn2kq04aapqb3sgr1admk13wjmy5cd6bwd2x";
    };

    patches = [ ./azure-agent-entropy.patch ];

    buildInputs = [ makeWrapper python pythonPackages.wrapPython ];
    runtimeDeps = [ findutils gnugrep gawk coreutils openssl openssh
                    nettools # for hostname
                    procps # for pidof
                    shadow # for useradd, usermod
                    utillinux # for (u)mount, fdisk, sfdisk, mkswap
                    parted
                  ];
    pythonPath = [ pythonPackages.pyasn1 ];

    configurePhase = false;
    buildPhase = false;

    installPhase = ''
      substituteInPlace config/99-azure-product-uuid.rules \
          --replace /bin/chmod "${coreutils}/bin/chmod"
      mkdir -p $out/lib/udev/rules.d
      cp config/*.rules $out/lib/udev/rules.d

      mkdir -p $out/bin
      cp waagent $out/bin/
      chmod +x $out/bin/waagent

      wrapProgram "$out/bin/waagent" \
          --prefix PYTHONPATH : $PYTHONPATH \
          --prefix PATH : "${makeBinPath runtimeDeps}"
    '';
  };

  provisionedHook = pkgs.writeScript "provisioned-hook" ''
    #!${pkgs.runtimeShell}
    ${config.systemd.package}/bin/systemctl start provisioned.target
  '';

in

{

  ###### interface

  options.virtualisation.azure.agent = {
    enable = mkOption {
      default = false;
      description = "Whether to enable the Windows Azure Linux Agent.";
    };
    verboseLogging = mkOption {
      default = false;
      description = "Whether to enable verbose logging.";
    };
    mountResourceDisk = mkOption {
      default = true;
      description = "Whether the agent should format (ext4) and mount the resource disk to /mnt/resource.";
    };
  };

  ###### implementation

  config = mkIf cfg.enable {
    assertions = [ {
      assertion = pkgs.stdenv.isi686 || pkgs.stdenv.isx86_64;
      message = "Azure not currently supported on ${pkgs.stdenv.hostPlatform.system}";
    } {
      assertion = config.networking.networkmanager.enable == false;
      message = "Windows Azure Linux Agent is not compatible with NetworkManager";
    } ];

    boot.initrd.kernelModules = [ "ata_piix" ];
    networking.firewall.allowedUDPPorts = [ 68 ];


    environment.etc."waagent.conf".text = ''
        #
        # Windows Azure Linux Agent Configuration
        #

        Role.StateConsumer=${provisionedHook}

        # Enable instance creation
        Provisioning.Enabled=y

        # Password authentication for root account will be unavailable.
        Provisioning.DeleteRootPassword=n

        # Generate fresh host key pair.
        Provisioning.RegenerateSshHostKeyPair=n

        # Supported values are "rsa", "dsa" and "ecdsa".
        Provisioning.SshHostKeyPairType=ed25519

        # Monitor host name changes and publish changes via DHCP requests.
        Provisioning.MonitorHostName=y

        # Decode CustomData from Base64.
        Provisioning.DecodeCustomData=n

        # Execute CustomData after provisioning.
        Provisioning.ExecuteCustomData=n

        # Format if unformatted. If 'n', resource disk will not be mounted.
        ResourceDisk.Format=${if cfg.mountResourceDisk then "y" else "n"}

        # File system on the resource disk
        # Typically ext3 or ext4. FreeBSD images should use 'ufs2' here.
        ResourceDisk.Filesystem=ext4

        # Mount point for the resource disk
        ResourceDisk.MountPoint=/mnt/resource

        # Respond to load balancer probes if requested by Windows Azure.
        LBProbeResponder=y

        # Enable logging to serial console (y|n)
        # When stdout is not enough...
        # 'y' if not set
        Logs.Console=y

        # Enable verbose logging (y|n)
        Logs.Verbose=${if cfg.verboseLogging then "y" else "n"}

        # Root device timeout in seconds.
        OS.RootDeviceScsiTimeout=300
    '';

    services.udev.packages = [ waagent ];

    networking.dhcpcd.persistent = true;

    services.logrotate = {
      enable = true;
      config = ''
        /var/log/waagent.log {
            compress
            monthly
            rotate 6
            notifempty
            missingok
        }
      '';
    };

    systemd.targets.provisioned = {
      description = "Services Requiring Azure VM provisioning to have finished";
    };

  systemd.services.consume-hypervisor-entropy =
    { description = "Consume entropy in ACPI table provided by Hyper-V";

      wantedBy = [ "sshd.service" "waagent.service" ];
      before = [ "sshd.service" "waagent.service" ];
      after = [ "local-fs.target" ];

      path  = [ pkgs.coreutils ];
      script =
        ''
          echo "Fetching entropy..."
          cat /sys/firmware/acpi/tables/OEM0 > /dev/random
        '';
      serviceConfig.Type = "oneshot";
      serviceConfig.RemainAfterExit = true;
      serviceConfig.StandardError = "journal+console";
      serviceConfig.StandardOutput = "journal+console";
     };

    systemd.services.waagent = {
      wantedBy = [ "multi-user.target" ];
      after = [ "network-online.target" "sshd.service" ];
      wants = [ "network-online.target" ];

      path = [ pkgs.e2fsprogs pkgs.bash ];
      description = "Windows Azure Agent Service";
      unitConfig.ConditionPathExists = "/etc/waagent.conf";
      serviceConfig = {
        ExecStart = "${waagent}/bin/waagent -daemon";
        Type = "simple";
      };
    };

  };

}

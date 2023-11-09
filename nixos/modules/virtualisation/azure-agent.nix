{ config, lib, pkgs, ... }:

with lib;
let

  cfg = config.virtualisation.azure.agent;

  provisionedHook = pkgs.writeScript "provisioned-hook" ''
    #!${pkgs.runtimeShell}
    /run/current-system/systemd/bin/systemctl start provisioned.target
  '';

in

{

  ###### interface

  options.virtualisation.azure.agent = {
    enable = mkOption {
      default = false;
      description = lib.mdDoc "Whether to enable the Windows Azure Linux Agent.";
    };
    verboseLogging = mkOption {
      default = false;
      description = lib.mdDoc "Whether to enable verbose logging.";
    };
    mountResourceDisk = mkOption {
      default = true;
      description = lib.mdDoc "Whether the agent should format (ext4) and mount the resource disk to /mnt/resource.";
    };
  };

  ###### implementation

  config = lib.mkIf cfg.enable {
    assertions = [{
      assertion = pkgs.stdenv.hostPlatform.isx86;
      message = "Azure not currently supported on ${pkgs.stdenv.hostPlatform.system}";
    }
      {
        assertion = config.networking.networkmanager.enable == false;
        message = "Windows Azure Linux Agent is not compatible with NetworkManager";
      }];

    boot.initrd.kernelModules = [ "ata_piix" ];
    networking.firewall.allowedUDPPorts = [ 68 ];


    environment.etc."waagent.conf".text = ''
        #
        # Microsoft Azure Linux Agent Configuration
        #

        # Enable extension handling. Do not disable this unless you do not need password reset,
        # backup, monitoring, or any extension handling whatsoever.
        Extensions.Enabled=y

        # How often (in seconds) to poll for new goal states
        Extensions.GoalStatePeriod=6

        # Which provisioning agent to use. Supported values are "auto" (default), "waagent",
        # "cloud-init", or "disabled".
        Provisioning.Agent=disabled

        # Password authentication for root account will be unavailable.
        Provisioning.DeleteRootPassword=n

        # Generate fresh host key pair.
        Provisioning.RegenerateSshHostKeyPair=n

        # Supported values are "rsa", "dsa", "ecdsa", "ed25519", and "auto".
        # The "auto" option is supported on OpenSSH 5.9 (2011) and later.
        Provisioning.SshHostKeyPairType=ed25519

        # Monitor host name changes and publish changes via DHCP requests.
        Provisioning.MonitorHostName=y

        # How often (in seconds) to monitor host name changes.
        Provisioning.MonitorHostNamePeriod=30

        # Decode CustomData from Base64.
        Provisioning.DecodeCustomData=n

        # Execute CustomData after provisioning.
        Provisioning.ExecuteCustomData=n

        # Algorithm used by crypt when generating password hash.
        #Provisioning.PasswordCryptId=6

        # Length of random salt used when generating password hash.
        #Provisioning.PasswordCryptSaltLength=10

        # Allow reset password of sys user
        Provisioning.AllowResetSysUser=n

        # Format if unformatted. If 'n', resource disk will not be mounted.
        ResourceDisk.Format=${if cfg.mountResourceDisk then "y" else "n"}

        # File system on the resource disk
        # Typically ext3 or ext4. FreeBSD images should use 'ufs2' here.
        ResourceDisk.Filesystem=ext4

        # Mount point for the resource disk
        ResourceDisk.MountPoint=/mnt/resource

        # Create and use swapfile on resource disk.
        ResourceDisk.EnableSwap=n

        # Size of the swapfile.
        ResourceDisk.SwapSizeMB=0

        # Comma-separated list of mount options. See mount(8) for valid options.
        ResourceDisk.MountOptions=None

        # Enable verbose logging (y|n)
        Logs.Verbose=${if cfg.verboseLogging then "y" else "n"}

        # Enable Console logging, default is y
        # Logs.Console=y

        # Enable periodic log collection, default is n
        Logs.Collect=n

        # How frequently to collect logs, default is each hour
        Logs.CollectPeriod=3600

        # Is FIPS enabled
        OS.EnableFIPS=n

        # Root device timeout in seconds.
        OS.RootDeviceScsiTimeout=300

        # How often (in seconds) to set the root device timeout.
        OS.RootDeviceScsiTimeoutPeriod=30

        # If "None", the system default version is used.
        OS.OpensslPath=${pkgs.openssl_3.bin}/bin/openssl

        # Set the SSH ClientAliveInterval
        # OS.SshClientAliveInterval=180

        # Set the path to SSH keys and configuration files
        OS.SshDir=/etc/ssh

        # If set, agent will use proxy server to access internet
        #HttpProxy.Host=None
        #HttpProxy.Port=None

        # Detect Scvmm environment, default is n
        # DetectScvmmEnv=n

        #
        # Lib.Dir=/var/lib/waagent

        #
        # DVD.MountPoint=/mnt/cdrom/secure

        #
        # Pid.File=/var/run/waagent.pid

        #
        # Extension.LogDir=/var/log/azure

        #
        # Home.Dir=/home

        # Enable RDMA management and set up, should only be used in HPC images
        OS.EnableRDMA=n

        # Enable checking RDMA driver version and update
        # OS.CheckRdmaDriver=y

        # Enable or disable goal state processing auto-update, default is enabled
        AutoUpdate.Enabled=n

        # Determine the update family, this should not be changed
        # AutoUpdate.GAFamily=Prod

        # Determine if the overprovisioning feature is enabled. If yes, hold extension
        # handling until inVMArtifactsProfile.OnHold is false.
        # Default is enabled
        EnableOverProvisioning=n

        # Allow fallback to HTTP if HTTPS is unavailable
        # Note: Allowing HTTP (vs. HTTPS) may cause security risks
        # OS.AllowHTTP=n

        # Add firewall rules to protect access to Azure host node services
        OS.EnableFirewall=n

        # How often (in seconds) to check the firewall rules
        OS.EnableFirewallPeriod=30

        # How often (in seconds) to remove the udev rules for persistent network interface
        # names (75-persistent-net-generator.rules and /etc/udev/rules.d/70-persistent-net.rules)
        OS.RemovePersistentNetRulesPeriod=30

        # How often (in seconds) to monitor for DHCP client restarts
        OS.MonitorDhcpClientRestartPeriod=30
    '';

    services.udev.packages = [ pkgs.waagent ];

    networking.dhcpcd.persistent = true;

    services.logrotate = {
      enable = true;
      settings."/var/log/waagent.log" = {
        compress = true;
        frequency = "monthly";
        rotate = 6;
      };
    };

    systemd.targets.provisioned = {
      description = "Services Requiring Azure VM provisioning to have finished";
    };

    systemd.services.consume-hypervisor-entropy =
      {
        description = "Consume entropy in ACPI table provided by Hyper-V";

        wantedBy = [ "sshd.service" "waagent.service" ];
        before = [ "sshd.service" "waagent.service" ];

        path = [ pkgs.coreutils ];
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

      path = [
        pkgs.e2fsprogs
        pkgs.bash

        # waagent's Microsoft.OSTCExtensions.VMAccessForLinux needs Python 3
        pkgs.python3

        # waagent's Microsoft.CPlat.Core.RunCommandLinux needs lsof
        pkgs.lsof
      ];
      description = "Windows Azure Agent Service";
      unitConfig.ConditionPathExists = "/etc/waagent.conf";
      serviceConfig = {
        ExecStart = "${pkgs.waagent}/bin/waagent -daemon";
        Type = "simple";
      };
    };

  };
}

{
  config,
  lib,
  pkgs,
  ...
}:

with lib;
let
  cfg = config.services.waagent;

  # Format for waagent.conf
  settingsFormat = {
    type =
      with types;
      let
        singleAtom =
          (nullOr (oneOf [
            bool
            str
            int
            float
          ]))
          // {
            description = "atom (bool, string, int or float) or null";
          };
        atom = either singleAtom (listOf singleAtom) // {
          description = singleAtom.description + " or a list of them";
        };
      in
      attrsOf (
        either atom (attrsOf atom)
        // {
          description = atom.description + " or an attribute set of them";
        }
      );
    generate =
      name: value:
      let
        # Transform non-attribute values
        transform =
          x:
          # Transform bool to "y" or "n"
          if (isBool x) then
            (if x then "y" else "n")
          # Concatenate list items with comma
          else if (isList x) then
            concatStringsSep "," (map transform x)
          else
            toString x;

        # Convert to format of waagent.conf
        recurse =
          path: value:
          if builtins.isAttrs value then
            pipe value [
              (mapAttrsToList (k: v: recurse (path ++ [ k ]) v))
              concatLists
            ]
          else
            [
              {
                name = concatStringsSep "." path;
                inherit value;
              }
            ];
        convert =
          attrs:
          pipe (recurse [ ] attrs) [
            # Filter out null values and empty lists
            (filter (kv: kv.value != null && kv.value != [ ]))
            # Transform to Key=Value form, then concatenate
            (map (kv: "${kv.name}=${transform kv.value}"))
            (concatStringsSep "\n")
          ];
      in
      pkgs.writeText name (convert value);
  };

  settingsType = types.submodule {
    freeformType = settingsFormat.type;
    options = {
      Provisioning = {
        Enable = mkOption {
          type = types.bool;
          default = !config.services.cloud-init.enable;
          defaultText = literalExpression "!config.services.cloud-init.enable";
          description = ''
            Whether to enable provisioning functionality in the agent.

            If provisioning is disabled, SSH host and user keys in the image are preserved
            and configuration in the Azure provisioning API is ignored.

            Set to `false` if cloud-init is used for provisioning tasks.
          '';
        };

        Agent = mkOption {
          type = types.enum [
            "auto"
            "waagent"
            "cloud-init"
            "disabled"
          ];
          default = "auto";
          description = ''
            Which provisioning agent to use.
          '';
        };
      };

      ResourceDisk = {
        Format = mkOption {
          type = types.bool;
          default = false;
          description = ''
            If set to `true`, waagent formats and mounts the resource disk that the platform provides,
            unless the file system type in `ResourceDisk.FileSystem` is set to `ntfs`.
            The agent makes a single Linux partition (ID 83) available on the disk.
            This partition isn't formatted if it can be successfully mounted.

            This configuration has no effect if resource disk is managed by cloud-init.
          '';
        };

        FileSystem = mkOption {
          type = types.str;
          default = "ext4";
          description = ''
            The file system type for the resource disk.
            If the string is `X`, then `mkfs.X` should be present in the environment.
            You can add additional filesystem packages using `services.waagent.extraPackages`.

            This configuration has no effect if resource disk is managed by cloud-init.
          '';
        };

        MountPoint = mkOption {
          type = types.str;
          default = "/mnt/resource";
          description = ''
            This option specifies the path at which the resource disk is mounted.
            The resource disk is a temporary disk and might be emptied when the VM is deprovisioned.

            This configuration has no effect if resource disk is managed by cloud-init.
          '';
        };

        MountOptions = mkOption {
          type = with types; listOf str;
          default = [ ];
          example = [
            "nodev"
            "nosuid"
          ];
          description = ''
            This option specifies disk mount options to be passed to the `mount -o` command.
            For more information, see the {manpage}`mount(8)` manual page.
          '';
        };

        EnableSwap = mkOption {
          type = types.bool;
          default = false;
          description = ''
            If enabled, the agent creates a swap file (`/swapfile`) on the resource disk
            and adds it to the system swap space.

            This configuration has no effect if resource disk is managed by cloud-init.
          '';
        };

        SwapSizeMB = mkOption {
          type = types.int;
          default = 0;
          description = ''
            Specifies the size of the swap file in MiB (1024×1024 bytes).

            This configuration has no effect if resource disk is managed by cloud-init.
          '';
        };
      };

      Logs.Verbose = lib.mkOption {
        type = types.bool;
        default = false;
        description = ''
          If you set this option, log verbosity is boosted.
          Waagent logs to `/var/log/waagent.log` and uses the system logrotate functionality to rotate logs.
        '';
      };

      OS = {
        EnableRDMA = lib.mkOption {
          type = types.bool;
          default = false;
          description = ''
            If enabled, the agent attempts to install and then load an RDMA kernel driver
            that matches the version of the firmware on the underlying hardware.
          '';
        };

        RootDeviceScsiTimeout = lib.mkOption {
          type = types.nullOr types.int;
          default = 300;
          description = ''
            Configures the SCSI timeout in seconds on the OS disk and data drives.
            If set to `null`, the system defaults are used.
          '';
        };
      };

      HttpProxy = {
        Host = lib.mkOption {
          type = types.nullOr types.str;
          default = null;
          description = ''
            If you set http proxy, waagent will use is proxy to access the Internet.
          '';
        };

        Port = lib.mkOption {
          type = types.nullOr types.port;
          default = null;
          description = ''
            If you set http proxy, waagent will use this proxy to access the Internet.
          '';
        };
      };

      AutoUpdate.UpdateToLatestVersion = lib.mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether or not to enable auto-update of the Extension Handler.
        '';
      };
    };
  };
in
{
  options.services.waagent = {
    enable = lib.mkEnableOption "Windows Azure Linux Agent";

    package = lib.mkPackageOption pkgs "waagent" { };

    extraPackages = lib.mkOption {
      default = [ ];
      description = ''
        Additional packages to add to the waagent {env}`PATH`.
      '';
      example = lib.literalExpression "[ pkgs.powershell ]";
      type = lib.types.listOf lib.types.package;
    };

    settings = lib.mkOption {
      type = settingsType;
      default = { };
      description = ''
        The waagent.conf configuration, see <https://learn.microsoft.com/en-us/azure/virtual-machines/extensions/agent-linux> for documentation.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = (cfg.settings.HttpProxy.Host != null) -> (cfg.settings.HttpProxy.Port != null);
        message = "Option services.waagent.settings.HttpProxy.Port must be set if services.waagent.settings.HttpProxy.Host is set.";
      }
    ];

    boot.initrd.kernelModules = [ "ata_piix" ];
    networking.firewall.allowedUDPPorts = [ 68 ];

    services.udev.packages = with pkgs; [ waagent ];

    boot.initrd.services.udev = with pkgs; {
      # Provide waagent-shipped udev rules in initrd too.
      packages = [ waagent ];
      # udev rules shell out to chmod, cut and readlink, which are all
      # provided by pkgs.coreutils, which is in services.udev.path, but not
      # boot.initrd.services.udev.binPackages.
      binPackages = [ coreutils ];
    };

    networking.dhcpcd.persistent = true;

    services.logrotate = {
      enable = true;
      settings."/var/log/waagent.log" = {
        compress = true;
        frequency = "monthly";
        rotate = 6;
      };
    };

    # Write settings to /etc/waagent.conf
    environment.etc."waagent.conf".source = settingsFormat.generate "waagent.conf" cfg.settings;

    systemd.targets.provisioned = {
      description = "Services Requiring Azure VM provisioning to have finished";
    };

    systemd.services.consume-hypervisor-entropy = {
      description = "Consume entropy in ACPI table provided by Hyper-V";

      wantedBy = [
        "sshd.service"
        "waagent.service"
      ];
      before = [
        "sshd.service"
        "waagent.service"
      ];

      path = [ pkgs.coreutils ];
      script = ''
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
      after = [
        "network-online.target"
      ]
      ++ lib.optionals config.services.cloud-init.enable [ "cloud-init.service" ];
      wants = [
        "network-online.target"
        "sshd.service"
        "sshd-keygen.service"
      ];

      path =
        with pkgs;
        [
          e2fsprogs
          bash
          findutils
          gnugrep
          gnused
          iproute2
          iptables
          openssh
          openssl
          parted

          # for hostname
          net-tools
          # for pidof
          procps
          # for useradd, usermod
          shadow

          util-linux # for (u)mount, fdisk, sfdisk, mkswap
          # waagent's Microsoft.CPlat.Core.RunCommandLinux needs lsof
          lsof
        ]
        ++ cfg.extraPackages;
      description = "Windows Azure Agent Service";
      unitConfig.ConditionPathExists = "/etc/waagent.conf";
      serviceConfig = {
        ExecStart = "${lib.getExe cfg.package} -daemon";
        Type = "simple";
        Restart = "always";
        Slice = "azure.slice";
        MemoryAccounting = true;
      };
    };

    # waagent will generate files under /etc/sudoers.d during provisioning
    security.sudo.extraConfig = ''
      #includedir /etc/sudoers.d
    '';
  };
}

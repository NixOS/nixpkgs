{ config, lib, pkgs, ... }:
let
  cfg = config.services.terraform-cloud-agent;

  packageWithMain = lib.types.addCheck lib.types.package (x: x ? meta.mainProgram);
in
{
  options.services.terraform-cloud-agent = {
    enable = lib.mkEnableOption "terraform-cloud-agent";

    tokenPath = lib.mkOption {
      type = lib.types.str;
      default = "$CONFIGURATION_DIRECTORY/token";
      description = lib.mdDoc "Path to the Terraform Cloud token this agent should use.";
      example = "/etc/terraform-cloud-agent/token";
    };

    hooks = lib.mkOption {
      description = lib.mdDoc "Set of hooks the TFC agent should run (if any).";
      default = {};
      type = lib.types.submodule {
        options = {
          pre-plan = lib.mkOption {
            type = lib.types.nullOr packageWithMain;
            default = null;
            description = lib.mdDoc "Terraform pre-plan hook script.";
            example = lib.literalExpression ''
              pkgs.writeShellApplication {
                name = "pre-plan";
                text = "echo 'TESTING 123'";
              };
            '';
          };

          post-plan = lib.mkOption {
            type = lib.types.nullOr packageWithMain;
            default = null;
            description = lib.mdDoc "Terraform post-plan hook script.";
          };

          pre-apply = lib.mkOption {
            type = lib.types.nullOr packageWithMain;
            default = null;
            description = lib.mdDoc "Terraform pre-apply hook script.";
          };

          post-apply = lib.mkOption {
            type = lib.types.nullOr packageWithMain;
            default = null;
            description = lib.mdDoc "Terraform post-apply hook script.";
          };
        };
      };
    };

    user = lib.mkOption {
      type = lib.types.str;
      default = "tfc-agent";
      description = lib.mdDoc "User account under which terraform-cloud-agent runs.";
    };

    group = lib.mkOption {
      type = lib.types.str;
      default = "tfc-agent";
      description = lib.mdDoc "Group account under which terraform-cloud-agent runs.";
    };

    flags = lib.mkOption {
      description = lib.mdDoc "Set of NixOS options that are used as flags to the tfc-agent executable.";
      type = lib.types.submodule {
        freeformType = lib.types.attrsOf lib.types.str;

        options = {
          name = lib.mkOption {
            type = lib.types.str;
            description = lib.mdDoc "Name of the tfc-agent process.";
            example = "silly-rhino-balderdash";
          };

          log-level = lib.mkOption {
            type = lib.types.nullOr (lib.types.enum [ "trace" "debug" "info" "warn" "error" ]);
            default = null;
            description = lib.mdDoc "Level at which log messages should be emitted.";
            example = "warn";
          };

          address = lib.mkOption {
            type = lib.types.nullOr lib.types.str;
            default = null;
            description = lib.mdDoc "HTTP or HTTPS address of the Terraform Cloud API.";
            example = "https://app.terraform.io";
          };

          accept = lib.mkOption {
            type = lib.types.commas;
            default = "plan,apply,policy,assessment";
            description = lib.mdDoc "Optional string of comma-separated job types that this agent may run. Acceptable job types are 'plan', 'apply', 'policy', and 'assessment'. Do not put whitespace in between entries.";
            example = "plan,apply";
          };

          auto-update = lib.mkOption {
            type = lib.types.str;
            readOnly = true;
            default = "disabled";
            description = lib.mdDoc "Controls automatic core updates behavior. Not acceptable in NixOS, so disabled.";
          };
        };
      };
    };
  };

  config = {
    systemd.services.terraform-cloud-agent = lib.mkIf cfg.enable {
      description = "Agent that executes plans from Terraform Cloud";
      wantedBy = [ "multi-user.target" ];
      after = [ "network-online.target" ];

      preStart =
        let
          linkHook = name: pkg: if (pkg != null) then ''
            ln -f -s ${lib.getExe pkg} $STATE_DIRECTORY/hooks/terraform-${name}
          '' else ''
            rm -f $STATE_DIRECTORY/hooks/terraform-${name}
          '';
        in ''
          mkdir -p $STATE_DIRECTORY/hooks

          ${lib.concatStringsSep "\n" (lib.mapAttrsToList linkHook cfg.hooks)}
        '';

      script = ''
        export TFC_AGENT_TOKEN=$(${pkgs.coreutils}/bin/cat ${cfg.tokenPath})
        export TFC_AGENT_DATA_DIR=$STATE_DIRECTORY
        export TFC_AGENT_CACHE_DIR=$CACHE_DIRECTORY
    
        ${lib.getExe pkgs.terraform-cloud-agent} ${lib.cli.toGNUCommandLineShell { mkOptionName = k: "-${k}"; } cfg.flags}
      '';

      serviceConfig = {
        StateDirectory = "terraform-cloud-agent";
        CacheDirectory = "terraform-cloud-agent";

        ConfigurationDirectory = "terraform-cloud-agent";

        # User and group
        User = cfg.user;
        Group = cfg.group;

        # Below shamelessly cribbed from the nginx module: https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/services/web-servers/nginx/default.nix

        # Security
        NoNewPrivileges = true;

        # Sandboxing (sorted by occurrence in https://www.freedesktop.org/software/systemd/man/systemd.exec.html)
        ProtectSystem = "strict";
        ProtectHome = lib.mkDefault true;
        PrivateTmp = true;
        PrivateDevices = true;
        ProtectHostname = true;
        ProtectClock = true;
        ProtectKernelTunables = true;
        ProtectKernelModules = true;
        ProtectKernelLogs = true;
        ProtectControlGroups = true;
        RestrictAddressFamilies = [ "AF_UNIX" "AF_INET" "AF_INET6" ];
        RestrictNamespaces = true;
        LockPersonality = true;
        MemoryDenyWriteExecute = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        RemoveIPC = true;
        PrivateMounts = true;
      };
    };

    users.users = lib.mkIf (cfg.user == "tfc-agent") {
      "tfc-agent" = {
        group = cfg.group;
        isSystemUser = true;
      };
    };

    users.groups = lib.mkIf (cfg.group == "tfc-agent") {
      "tfc-agent" = { };
    };
  };
}

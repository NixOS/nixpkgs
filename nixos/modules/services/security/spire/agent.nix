{
  lib,
  pkgs,
  config,
  ...
}:
let
  format = pkgs.formats.hcl1 { };
  cfg = config.services.spire.agent;
in
{
  meta.maintainers = [ lib.maintainers.arianvp ];

  options.services.spire.agent = {
    enable = lib.mkEnableOption "SPIRE agent";

    package = lib.mkPackageOption pkgs "spire" { };

    settings = lib.mkOption {
      description = ''
        SPIRE Agent configuration file options. See [the documentation](https://spiffe.io/docs/latest/deploying/spire_agent/) for all available options.
      '';
      type = lib.types.submodule {
        freeformType = format.type;
        options = {
          agent = {
            trust_domain = lib.mkOption {
              type = lib.types.str;
              description = "The trust domain that this agent belongs to";
              example = "example.com";
            };
            data_dir = lib.mkOption {
              type = lib.types.str;
              default = "$STATE_DIRECTORY";
              description = "The directory where the SPIRE agent stores its data";
            };
            server_address = lib.mkOption {
              type = lib.types.str;
              description = "The address of the SPIRE server";
              example = "server.example.com";
            };
            server_port = lib.mkOption {
              type = lib.types.port;
              default = 8081;
              description = "The port on which the SPIRE server is listening";
            };
            socket_path = lib.mkOption {
              type = lib.types.path;
              default = "/run/spire/agent/public/api.sock";
              description = "The path to the SPIRE agent socket";
            };
          };
          plugins = lib.mkOption {
            description = ''
              Built-in plugin types can be found at [the plugin types documentation](https://spiffe.io/docs/latest/deploying/spire_agent/#plugin-types).
              See [plugin configuration](https://spiffe.io/docs/latest/deploying/spire_agent/#plugin-configuration) for options and how to configure external plugins.
            '';
            # TODO: We can probably enforce some of these constraints with a submodule
            type = format.type;
            example = {
              KeyManager.memory.plugin_data = { };
              NodeAttestor.join_token.plugin_data = { };
              WorkloadAttestor.systemd.plugin_data = { };
              WorkloadAttestor.unix.plugin_data = { };
            };
          };
        };
      };
    };

    configFile = lib.mkOption {
      type = lib.types.path;
      defaultText = "Config file generated from services.spire.agent.settings";
      default = format.generate "agent.conf" cfg.settings;
      description = ''
        Path to the SPIRE agent configuration file. See [the documentation](https://spiffe.io/docs/latest/deploying/spire_agent/) for more information.
      '';
    };

    expandEnv = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Expand environment variables in SPIRE config file";
    };

  };
  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    # TODO: Switch to DynamicUser once https://github.com/NixOS/nixpkgs/issues/299476 lands
    users.users.spire-agent = {
      isSystemUser = true;
      group = "spire-agent";
    };
    users.groups.spire-agent = { };

    systemd.services.spire-agent = {
      wantedBy = [ "multi-user.target" ];
      description = "SPIRE agent";
      serviceConfig = {
        ExecStart =
          "${lib.getExe' cfg.package "spire-agent"} run "
          + lib.cli.toCommandLineShellGNU { } {
            inherit (cfg) expandEnv;
            config = cfg.configFile;
          };
        Restart = "on-failure";
        StateDirectory = "spire/agent";
        StateDirectoryMode = "0700";
        RuntimeDirectory = "spire/agent";

        # TODO: Switch to DynamicUser once https://github.com/NixOS/nixpkgs/issues/299476 lands
        # Without it, the systemd plugin can not talk to dbus
        # DynamicUser = true;
        User = "spire-agent";
        Group = "spire-agent";
        UMask = "0027";

        # TODO: Hardening
      };
    };
  };
}

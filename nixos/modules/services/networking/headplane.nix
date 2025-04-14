{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit
    (lib)
    attrsToList
    listToAttrs
    map
    mkEnableOption
    mkIf
    mkOption
    mkPackageOption
    typeOf
    types
    ;
  cfg = config.services.headplane;
  settingsFormat = pkgs.formats.yaml {};
  settingsFile = settingsFormat.generate "headplane-config.yaml" cfg.settings;
  agentEnv = listToAttrs (map (n: {
    name = n.name;
    value =
      if ((typeOf n.value) == "bool")
      then
        (
          if (n.value)
          then "true"
          else "false"
        )
      else n.value;
  }) (attrsToList cfg.agent.settings));
in {
  options.services.headplane = {
    enable = mkEnableOption "headplane";
    package = mkPackageOption pkgs "headplane" {};

    settings = mkOption {
      type = types.submodule {
        freeformType = settingsFormat.type;
      };
      default = {};
      description = "Headplane config, generates a YAML config. See: https://github.com/tale/headplane/blob/main/config.example.yaml.";
    };

    agent = mkOption {
      type = types.submodule {
        options = {
          enable = mkEnableOption "headplane-agent";
          package = mkPackageOption pkgs "headplane-agent" {};
          settings = mkOption {
            type = types.attrsOf [types.str types.bool];
            description = "Headplane agent env vars config. See: https://github.com/tale/headplane/blob/main/docs/Headplane-Agent.md";
            default = {};
          };
        };
      };
    };
  };

  config = mkIf cfg.enable {
    environment = {
      systemPackages = [cfg.package];
      etc."headplane/config.yaml".source = "${settingsFile}";
    };

    systemd.services.headplane-agent =
      mkIf cfg.agent.enable
      {
        description = "Headplane side-running agent";

        wantedBy = ["multi-user.target"];
        after = ["headplane.service"];
        requires = ["headplane.service"];

        environment = agentEnv;

        serviceConfig = {
          User = config.services.headscale.user;
          Group = config.services.headscale.group;

          ExecStart = "${pkgs.headplane-agent}/bin/hp_agent";
          Restart = "always";
          RestartSec = 5;

          # TODO: Harden `systemd` security according to the "The Principle of Least Power".
          # See: `$ systemd-analyze security headplane-agent`.
        };
      };

    systemd.services.headplane = {
      description = "Headscale Web UI";

      wantedBy = ["multi-user.target"];
      after = ["headscale.service"];
      requires = ["headscale.service"];

      serviceConfig = {
        User = config.services.headscale.user;
        Group = config.services.headscale.group;

        ExecStart = "${pkgs.headplane}/bin/headplane";
        Restart = "always";
        RestartSec = 5;

        # TODO: Harden `systemd` security according to the "The Principle of Least Power".
        # See: `$ systemd-analyze security headplane`.
      };
    };
  };
}

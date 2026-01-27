{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.robloxapid;
in
{
  options.services.robloxapid = {
    enable = lib.mkEnableOption "RobloxAPID daemon";
    package = lib.mkOption {
      type = lib.types.package;
      default = null;
      defaultText = lib.literalExpression "pkgs.robloxapid";
      description = "RobloxAPID package to run.";
    };
    configFile = lib.mkOption {
      type = lib.types.path;
      default = "/etc/robloxapid/config.json";
      description = ''
        Path to the `config.json` file for RobloxAPID.

        Since this configuration contains secrets (passwords, API keys), it is
        HIGHLY RECOMMENDED to manage this file using a secrets tool like
        <literal>sops-nix</literal> or <literal>agenix</literal>. The file must be
        readable by the user the service runs as.

        Example using <literal>sops-nix</literal>:
        ```nix
        {
          sops.secrets."robloxapid_config" = {
            sopsFile = ./secrets.yaml;
            owner = config.systemd.services.robloxapid.serviceConfig.User;
          };

          services.robloxapid = {
            enable = true;
            configFile = config.sops.secrets.robloxapid_config.path;
          };
        }
        ```
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.robloxapid = {
      description = "RobloxAPID sync daemon";
      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];
      serviceConfig = {
        DynamicUser = true;
        ExecStart = "${cfg.package}/bin/robloxapid";
        StateDirectory = "robloxapid";
        WorkingDirectory = "%S";
        Environment = "ROAPID_CONFIG=${cfg.configFile}";
        Restart = "on-failure";
      };
      wantedBy = [ "multi-user.target" ];
    };
  };
}

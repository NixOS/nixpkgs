{
  config,
  lib,
  pkgs,
  ...
}:

let

  inherit (lib)
    mkIf
    mkEnableOption
    lib.mkOption
    types
    literalExpression
    ;
  cfg = config.services.nextcloud-whiteboard-server;

in
{
  options.services.nextcloud-whiteboard-server = {

    enable = lib.mkEnableOption "Nextcloud backend server for the Whiteboard app";

    settings = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = { };
      description = ''
        Settings to configure backend server. Especially the Nextcloud host
        url has to be set. The required environment variable `JWT_SECRET_KEY`
        should be set via the secrets option.
      '';
      example = lib.literalExpression ''
        {
          NEXTCLOUD_URL = "https://nextcloud.example.org";
        }
      '';
    };

    secrets = lib.mkOption {
      type = with lib.types; listOf str;
      description = ''
        A list of files containing the various secrets. Should be in the
        format expected by systemd's `EnvironmentFile` directory.
      '';
      default = [ ];
    };

  };

  config = lib.mkIf cfg.enable {

    systemd.services.nextcloud-whiteboard-server = {
      description = "Nextcloud backend server for the Whiteboard app";
      wantedBy = [ "multi-user.target" ];
      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];
      environment = cfg.settings;
      serviceConfig = {
        ExecStart = "${lib.getExe pkgs.nextcloud-whiteboard-server}";
        WorkingDirectory = "%S/whiteboard";
        StateDirectory = "whiteboard";
        EnvironmentFile = [ cfg.secrets ];
        DynamicUser = true;
      };
    };

  };

  meta.maintainers = with lib.maintainers; [ onny ];

}

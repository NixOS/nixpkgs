{
  config,
  lib,
  pkgs,
  utils,
  ...
}:
let
  cfg = config.services.sing-box;
  settingsFormat = pkgs.formats.json { };
in
{

  meta = {
    maintainers = with lib.maintainers; [
      nickcao
      prince213
    ];
  };

  options = {
    services.sing-box = {
      enable = lib.mkEnableOption "sing-box universal proxy platform";

      package = lib.mkPackageOption pkgs "sing-box" { };

      settings = lib.mkOption {
        type = lib.types.submodule {
          freeformType = settingsFormat.type;
        };
        default = { };
        description = ''
          The sing-box configuration, see <https://sing-box.sagernet.org/configuration/> for documentation.

          Options containing secret data should be set to an attribute set
          containing the attribute `_secret` - a string pointing to a file
          containing the value the option should be set to.
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    # for polkit rules
    environment.systemPackages = [ cfg.package ];
    services.dbus.packages = [ cfg.package ];
    systemd.packages = [ cfg.package ];

    systemd.services.sing-box = {
      serviceConfig = {
        User = "sing-box";
        Group = "sing-box";
        StateDirectory = "sing-box";
        StateDirectoryMode = "0700";
        RuntimeDirectory = "sing-box";
        RuntimeDirectoryMode = "0700";
        WorkingDirectory = "/var/lib/sing-box";
        ExecStartPre =
          let
            script = pkgs.writeShellScript "sing-box-pre-start" ''
              ${utils.genJqSecretsReplacementSnippet cfg.settings "/run/sing-box/config.json"}
              chown --reference=/run/sing-box /run/sing-box/config.json
            '';
          in
          "+${script}";
        ExecStart = [
          ""
          "${lib.getExe cfg.package} -D \${STATE_DIRECTORY} -C \${RUNTIME_DIRECTORY} run"
        ];
      };
      # After= is specified by upstream
      requires = [ "network-online.target" ];
      wantedBy = [ "multi-user.target" ];
    };

    users = {
      users.sing-box = {
        isSystemUser = true;
        group = "sing-box";
        home = "/var/lib/sing-box";
      };
      groups.sing-box = { };
    };
  };
}

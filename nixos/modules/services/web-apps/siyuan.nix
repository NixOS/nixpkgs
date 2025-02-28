{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib)
    mkEnableOption
    mkIf
    mkOption
    mkPackageOption
    optionalAttrs
    types
    ;

  cfg = config.services.siyuan;
  username = "siyuan";
  workingDirectory = "/var/lib/siyuan";
in

{
  options.services.siyuan = {
    enable = mkEnableOption "the SiYuan service";

    package = mkPackageOption pkgs "siyuan" { };

    language = mkOption {
      type = types.enum [
        "zh_CN"
        "zh_CHT"
        "en_US"
        "fr_FR"
        "es_ES"
      ];
      default = "en_US";
      description = "The language SiYuan should use.";
    };

    listenPort = mkOption {
      type = types.port;
      default = 6806;
      description = "Port SiYuan should use.";
    };

    authCodeFile = mkOption {
      type = types.path;
      description = ''
        File containing the authentication code to authorize access to SiYuan.
      '';
    };
  };

  config =
    let
      startScript = pkgs.writeShellScriptBin "siyuan-start" ''
        ${cfg.package}/share/siyuan/resources/kernel/SiYuan-Kernel \
          --accessAuthCode "$(cat ${cfg.authCodeFile})" \
          --lang ${cfg.language} \
          --port ${toString cfg.listenPort} \
          --workspace ${workingDirectory} \
          -wd ${cfg.package}/share/siyuan/resources
      '';
    in
    mkIf cfg.enable {
      systemd.services.siyuan =
        {
          description = "SiYuan Service";
          wantedBy = [ "multi-user.target" ];
          after = [ "networking.target" ];
          serviceConfig = {
            ExecStart = lib.getExe startScript;
            PrivateTmp = true;
            Restart = "always";
            User = username;
            WorkingDirectory = workingDirectory;
          };
        }
        // optionalAttrs config.boot.isContainer {
          environment = {
            "RUN_IN_CONTAINER" = true;
          };
        };

      users.users.${username} = {
        isSystemUser = true;
        createHome = true;
        description = "SiYuan service user";
        home = workingDirectory;
        group = username;
      };

      users.groups.${config.users.users.${username}.group} = { };
    };
}

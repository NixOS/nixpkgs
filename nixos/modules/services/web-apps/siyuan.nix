{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.siyuan;
  username = "siyuan";
  workingDirectory = "/var/lib/siyuan";
in

{
  options.services.siyuan = {
    enable = mkEnableOption "the Siyuan service";

    package = mkOption {
      type = types.package;
      default = pkgs.siyuan;
      description = "Siyuan package to use.";
    };

    language = mkOption {
      type = types.enum [ "zh_CN" "zh_CHT" "en_US" "fr_FR" "es_ES" ];
      default = "en_US";
      description = "The language Siyan should use.";
    };

    listenHost = mkOption {
      type = types.str;
      default = "localhost";
      example = "::";
      description = "The address (IPv4, IPv6 or DNS) to listen on.";
    };

    listenPort = mkOption {
      type = types.port;
      default = 6806;
      description = "Port number of Siyuan.";
    };

    authCodeFile = mkOption {
      type = types.path;
      description = ''
        File containing the authentication code to authorize access to Siyuan.
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
      systemd.services.siyuan = {
        description = "Siyuan Service";
        wantedBy = [ "multi-user.target" ];
        after = [ "networking.target" ];
        serviceConfig = {
          ExecStart = lib.getExe startScript;
          PrivateTmp = true;
          Restart = "always";
          User = username;
          WorkingDirectory = workingDirectory;
        };
      };

      users.users.${username} = {
        isSystemUser = true;
        createHome = true;
        description = "Siyuan service user";
        home = workingDirectory;
        group = username;
      };

      users.groups.${config.users.users.${username}.group} = {};
    };
}

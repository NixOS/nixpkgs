{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.tinyproxy;
  mkValueStringTinyproxy =
    v:
    if true == v then
      "yes"
    else if false == v then
      "no"
    else if lib.types.path.check v then
      ''"${v}"''
    else
      lib.generators.mkValueStringDefault { } v;
  mkKeyValueTinyproxy =
    {
      mkValueString ? lib.mkValueStringDefault { },
    }:
    sep: k: v:
    if null == v then "" else "${lib.strings.escape [ sep ] k}${sep}${mkValueString v}";

  settingsFormat = (
    pkgs.formats.keyValue {
      mkKeyValue = mkKeyValueTinyproxy {
        mkValueString = mkValueStringTinyproxy;
      } " ";
      listsAsDuplicateKeys = true;
    }
  );
  configFile = settingsFormat.generate "tinyproxy.conf" cfg.settings;

in
{

  options = {
    services.tinyproxy = {
      enable = lib.mkEnableOption "Tinyproxy daemon";
      package = lib.mkPackageOption pkgs "tinyproxy" { };
      settings = lib.mkOption {
        description = "Configuration for [tinyproxy](https://tinyproxy.github.io/).";
        default = { };
        example = lib.literalExpression ''
          {
            Port 8888;
            Listen 127.0.0.1;
            Timeout 600;
            Allow 127.0.0.1;
            Anonymous = ['"Host"' '"Authorization"'];
            ReversePath = '"/example/" "http://www.example.com/"';
          }
        '';
        type = lib.types.submodule (
          { name, ... }:
          {
            freeformType = settingsFormat.type;
            options = {
              Listen = lib.mkOption {
                type = lib.types.nullOr lib.types.str;
                default = "127.0.0.1";
                description = ''
                  Specify which address to listen to.
                '';
              };
              Port = lib.mkOption {
                type = lib.types.port;
                default = 8888;
                description = ''
                  Specify which port to listen to.
                '';
              };
              Anonymous = lib.mkOption {
                type = lib.types.listOf lib.types.str;
                default = [ ];
                description = ''
                  If an `Anonymous` keyword is present, then anonymous proxying is enabled. The headers listed with `Anonymous` are allowed through, while all others are denied. If no Anonymous keyword is present, then all headers are allowed through. You must include quotes around the headers.
                '';
              };
              Filter = lib.mkOption {
                type = lib.types.nullOr lib.types.path;
                default = null;
                description = ''
                  Tinyproxy supports filtering of web sites based on URLs or domains. This option specifies the location of the file containing the filter rules, one rule per line.
                '';
              };
            };
          }
        );
      };
    };
  };
  config = lib.mkIf cfg.enable {
    systemd.services.tinyproxy = {
      description = "TinyProxy daemon";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        User = "tinyproxy";
        Group = "tinyproxy";
        Type = "simple";
        ExecStart = "${lib.getExe cfg.package} -d -c ${configFile}";
        ExecReload = "${pkgs.coreutils}/bin/kill -SIGHUP $MAINPID";
        KillSignal = "SIGINT";
        TimeoutStopSec = "30s";
        Restart = "on-failure";
      };
    };

    users.users.tinyproxy = {
      group = "tinyproxy";
      isSystemUser = true;
    };
    users.groups.tinyproxy = { };
  };
  meta.maintainers = with lib.maintainers; [ tcheronneau ];
}

{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.tinyproxy;
  mkValueStringTinyproxy = with lib; v:
        if true  ==         v then "yes"
        else if false ==    v then "no"
        else if types.path.check v then ''"${v}"''
        else generators.mkValueStringDefault {} v;
  mkKeyValueTinyproxy = {
    mkValueString ? mkValueStringDefault {}
  }: sep: k: v:
    if null     ==  v then ""
    else "${lib.strings.escape [sep] k}${sep}${mkValueString v}";

  settingsFormat = (pkgs.formats.keyValue {
      mkKeyValue = mkKeyValueTinyproxy {
        mkValueString = mkValueStringTinyproxy;
      } " ";
      listsAsDuplicateKeys= true;
  });
  configFile = settingsFormat.generate "tinyproxy.conf" cfg.settings;

in
{

  options = {
    services.tinyproxy = {
      enable = mkEnableOption "Tinyproxy daemon";
      package = mkPackageOption pkgs "tinyproxy" {};
      settings = mkOption {
        description = "Configuration for [tinyproxy](https://tinyproxy.github.io/).";
        default = { };
        example = literalExpression ''{
          Port 8888;
          Listen 127.0.0.1;
          Timeout 600;
          Allow 127.0.0.1;
          Anonymous = ['"Host"' '"Authorization"'];
          ReversePath = '"/example/" "http://www.example.com/"';
        }'';
        type = types.submodule ({name, ...}: {
          freeformType = settingsFormat.type;
          options = {
            Listen = mkOption {
              type = types.str;
              default = "127.0.0.1";
              description = ''
              Specify which address to listen to.
              '';
            };
            Port = mkOption {
              type = types.int;
              default = 8888;
              description = ''
              Specify which port to listen to.
              '';
            };
            Anonymous = mkOption {
              type = types.listOf types.str;
              default = [];
              description = ''
              If an `Anonymous` keyword is present, then anonymous proxying is enabled. The headers listed with `Anonymous` are allowed through, while all others are denied. If no Anonymous keyword is present, then all headers are allowed through. You must include quotes around the headers.
              '';
            };
            Filter = mkOption {
              type = types.nullOr types.path;
              default = null;
              description = ''
              Tinyproxy supports filtering of web sites based on URLs or domains. This option specifies the location of the file containing the filter rules, one rule per line.
              '';
            };
          };
        });
      };
    };
  };
  config = mkIf cfg.enable {
    systemd.services.tinyproxy = {
      description = "TinyProxy daemon";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        User = "tinyproxy";
        Group = "tinyproxy";
        Type = "simple";
        ExecStart = "${getExe cfg.package} -d -c ${configFile}";
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
    users.groups.tinyproxy = {};
  };
  meta.maintainers = with maintainers; [ tcheronneau ];
}

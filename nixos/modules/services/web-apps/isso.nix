{ lib, config, pkgs, ... }:

with lib;

let
  cfg = config.services.isso;

  user = "isso";
  desc = "Isso commenting server";
  home = "/var/lib/isso";
  db = "${home}/comments.db";

  mkSection = sect: attrs: ''
    [${sect}]
    ${concatStringsSep "\n" (mapAttrsToList (key: val: ''
      ${key} = ${val}
    '') attrs)}
  '';

  compose = f: g: x: f (g x);
  concatHosts = mapAttrByPath [ "general" "host" ] (hs: concatStringsSep "\n  ") [];
  generatedConfig = mapAttrsToList mkSection cfg.config;
  configFile = pkgs.writeText "isso.cfg" (concatStringsSep "\n" generatedConfig);

in
{
  options = {

    services.isso = {

      enable = mkEnableOption "the ${desc}";

      config = mkOption {
        type = with types; attrsOf (attrsOf str);
        description = ''
          Isso INI-style configuration mapped to an attribute set.
          Is merged recursively with the default.
        '';
        example = {
          general = rec {
            log-file = "${config.users.users.isso.home}/isso.log";
            host = [ "http://localhost" "http://example.com" ];
          };
          server.listen = "http://localhost:8080";
        };
        default = {
          general.dbpath = db;
        };
      };

    };

  };

  config =
   mkIf cfg.enable {

    systemd.services.isso = {
      description = desc;
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      restartIfChanged = true;

      serviceConfig = {
        # TODO: wsgi support
        ExecStart = ''
          ${pkgs.pythonPackages.isso}/bin/isso -c "${configFile}" run
        '';
        User = user;
        Group = user;
        PrivateTmp = true;
      };
    };

    users.users.isso = {
     description = desc;
     group = user;
     uid = config.ids.uids.isso;
     home = home;
     createHome = true;
    };
    users.groups.isso.gid = config.ids.gids.isso;

  };

}

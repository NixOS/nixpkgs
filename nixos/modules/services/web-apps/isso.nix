{ lib, config, pkgs, ... }:

with lib;

let
  cfg = config.services.isso;

  user = "isso";
  desc = "Isso commenting server";
  home = "/var/lib/isso";
  db = "${home}/comments.db";

  config' = pkgs.runCommand "isso.cfg" {} (''
    echo '[general]' >> $out
    echo 'dbpath = ${db}' >> $out
  ''
  + optionalString (cfg.hosts != []) ''
    echo 'host = ${concatMapStrings (h: "\n  " + h) cfg.hosts}' >> $out
  '' + ''
    echo '${cfg.configGeneral}' | sed '/dbpath.*=/d' >> $out
    echo
    echo '${cfg.config}' >> $out
  '');

in
{
  options = {

    services.isso = {
      enable = mkEnableOption "isso";

      hosts = mkOption {
        type = with types; listOf string;
        description = ''
          List of websites Isso should run on (from [general] config).
        '';
        default = [];
      };

      config = mkOption {
        type = types.lines;
        description = ''
          INI-style isso config, without the [general] section.
        '';
      };

      configGeneral = mkOption {
        type = types.lines;
        default = "";
        description = ''
          The content of [general], dbpath is overwritten to ${db}.
        '';
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
          ${pkgs.pythonPackages.isso}/bin/isso -c "${config'}" run
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

{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.services.ngircd;

  configFile = pkgs.stdenv.mkDerivation {
    name = "ngircd.conf";

    text = cfg.config;

    preferLocalBuild = true;

    buildCommand = ''
      echo -n "$text" > $out
      ${cfg.package}/sbin/ngircd --config $out --configtest
    '';
  };
in
{
  options = {
    services.ngircd = {
      enable = mkEnableOption "the ngircd IRC server";

      config = mkOption {
        description = "The ngircd configuration (see ngircd.conf(5)).";

        type = types.lines;
      };

      package = mkPackageOption pkgs "ngircd" { };
    };
  };

  config = mkIf cfg.enable {
    #!!! TODO: Use ExecReload (see https://github.com/NixOS/nixpkgs/issues/1988)
    systemd.services.ngircd = {
      description = "The ngircd IRC server";

      wantedBy = [ "multi-user.target" ];

      serviceConfig.ExecStart = "${cfg.package}/sbin/ngircd --config ${configFile} --nodaemon";

      serviceConfig.User = "ngircd";
    };

    users.users.ngircd = {
      isSystemUser = true;
      group = "ngircd";
      description = "ngircd user.";
    };
    users.groups.ngircd = { };

  };
}

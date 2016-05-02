{ config, lib, pkgs, ... }: with lib;

let
  cfg = config.flyingcircus.roles.redis;
  fclib = import ../lib;

  listen_addresses =
    fclib.listenAddresses config "lo" ++
    fclib.listenAddresses config "ethsrv";

  generated_password_file = pkgs.runCommand "redis.password"
    { buildInputs = [pkgs.apg]; } ''
      ${pkgs.apg}/bin/apg -a 1 -M lnc -n1 -m 32 > $out
    '';

  read_or_generate_password =
    if pathExists /etc/local/redis/password
    then readFile /etc/local/redis/password
    else readFile generated_password_file;

  password =
    if cfg.password == null
    then read_or_generate_password
    else cfg.password;

in
{

  options = {

    flyingcircus.roles.redis = {

      enable = mkOption {
        type = types.bool;
        default = false;
        description = "Enable the Flying Circus Redis role.";
      };

      password = mkOption {
        type = types.nullOr types.string;
        default = null;
        description = ''
        The password for redis. If null, a random password will be set.
        '';
      };
    };
  };

  config = mkIf cfg.enable {

    services.redis.enable = true;
    services.redis.requirePass = password;
    services.redis.bind = concatStringsSep " " listen_addresses;

    system.activationScripts.fcio-redis = ''
      install -d -o ${toString config.ids.uids.redis} -g service  -m 02775 /etc/local/redis/
    '';

    environment.etc."local/redis/password".text = password;

    flyingcircus.services.sensu-client.checks = {
      redis = {
        notification = "Redis alive";
        command = "check-redis-ping.rb -h localhost -P $(cat /etc/local/redis/password)";
      };
    };

  };

}

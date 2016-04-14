{ config, lib, pkgs, ... }: with lib;

let
  cfg = config.flyingcircus;
  fclib = import ../lib;

  listen_addresses =
    fclib.listenAddresses config "lo" ++
    fclib.listenAddresses config "ethsrv";

  local_config_path = /etc/local/mongodb/mongodb.conf;

  local_config =
    if pathExists local_config_path
    then builtins.readFile  local_config_path
    else "";

in
{
  options = {

    flyingcircus.roles.mongodb = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = "Enable the Flying Circus MongoDB role.";
      };
    };

  };

  config = mkIf cfg.roles.mongodb.enable {

  services.mongodb.enable = true;
  services.mongodb.dbpath = "/srv/mongodb";
  services.mongodb.bind_ip = concatStringsSep "," listen_addresses;
  services.mongodb.extraConfig = ''
    ipv6 = true
    ${local_config}
  '';

  systemd.services.mongodb.preStart = ''
      echo never > /sys/kernel/mm/transparent_hugepage/defrag
  '';
  systemd.services.mongodb.postStop = ''
      echo always > /sys/kernel/mm/transparent_hugepage/defrag
  '';

  users.users.mongodb = {
    shell = "/run/current-system/sw/bin/bash";
    home = "/srv/mongodb";
  };

  system.activationScripts.flyingcircus_mongodb = ''
    install -d -o ${toString config.ids.uids.mongodb} /srv/mongodb
    install -d -o ${toString config.ids.uids.mongodb} -g service -m 02775 /etc/local/mongodb
  '';

  security.sudo.extraConfig = ''
    # Service users may switch to the mongodb system user
    %sudo-srv ALL=(mongodb) ALL
    %service ALL=(mongodb) ALL
    %sensuclient ALL=(mongodb) ALL
  '';

  environment.etc."local/mongodb/README.txt".text = ''
      Put your local mongodb configuration into `mongodb.conf` here.
      It will be joined with the basic config.
      '';


    # flyingcircus.services.sensu-client.checks = {
    #   postgresql = {
    #     notification = "PostgreSQL alive";
    #     command =  "/var/setuid-wrappers/sudo -u postgres check-postgres-alive.rb -d postgres";
    #   };
    # };

  };

}

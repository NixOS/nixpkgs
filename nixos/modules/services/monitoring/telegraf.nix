{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.telegraf;

  configFile = pkgs.runCommand "config.toml" {
    buildInputs = [ pkgs.remarshal ];
  } ''
    remarshal -if json -of toml \
      < ${pkgs.writeText "config.json" (builtins.toJSON cfg.extraConfig)} \
      > $out
  '';
in
{

  ###### interface

  options = {

    services.telegraf = {

      enable = mkEnableOption "telegraf server";

      package = mkOption {
        default = pkgs.telegraf;
        defaultText = "pkgs.telegraf";
        description = "Which telegraf derivation to use";
        type = types.package;
      };

      extraConfig = mkOption {
        default = {};
        description = "Extra configuration options for telegraf";
        type = types.attrs;
      };
    };

  };


  ###### implementation

  config = mkIf config.services.telegraf.enable {

    systemd.services.telegraf = {
      description = "Telegraf Agent";
      wantedBy = [ "multi-user.target" ];
      after = [ "network-interfaces.target" ];
      serviceConfig = {
        ExecStart = ''${cfg.package}/bin/telegraf -config "${configFile}"'';
        User = "telegraf";
        Group = "telegraf";
      };
    };

    users.extraUsers = [{
      name = "telegraf";
      uid = config.ids.uids.telegraf;
      description = "telegraf daemon user";
    }];

    users.extraGroups = [{
      name = "telegraf";
      gid = config.ids.gids.telegraf;
    }];
  };

}


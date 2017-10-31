{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.sks;

  sksPkg = cfg.package;

in

{

  options = {

    services.sks = {

      enable = mkEnableOption "sks";

      package = mkOption {
        default = pkgs.sks;
        defaultText = "pkgs.sks";
        type = types.package;
        description = "
          Which sks derivation to use.
        ";
      };

      hkpAddress = mkOption {
        default = [ "127.0.0.1" "::1" ];
        type = types.listOf types.str;
        description = "
          Wich ip addresses the sks-keyserver is listening on.
        ";
      };

      hkpPort = mkOption {
        default = 11371;
        type = types.int;
        description = "
          Which port the sks-keyserver is listening on.
        ";
      };
    };
  };

  config = mkIf cfg.enable {

    environment.systemPackages = [ sksPkg ];
    
    users.users.sks = {
      createHome = true;
      home = "/var/db/sks";
      isSystemUser = true;
      shell = "${pkgs.coreutils}/bin/true";
    };

    systemd.services = let
      hkpAddress = "'" + (builtins.concatStringsSep " " cfg.hkpAddress) + "'" ;
      hkpPort = builtins.toString cfg.hkpPort;
      home = config.users.users.sks.home;
      user = config.users.users.sks.name;
    in {
      sks-keyserver = {
        wantedBy = [ "multi-user.target" ];
        preStart = ''
          mkdir -p ${home}/dump
          ${pkgs.sks}/bin/sks build ${home}/dump/*.gpg -n 10 -cache 100 || true #*/
          ${pkgs.sks}/bin/sks cleandb || true
          ${pkgs.sks}/bin/sks pbuild -cache 20 -ptree_cache 70 || true
        '';
        serviceConfig = {
          WorkingDirectory = home;
          User = user;
          Restart = "always";
          ExecStart = "${pkgs.sks}/bin/sks db -hkp_address ${hkpAddress} -hkp_port ${hkpPort}";
        };
      };
    };
  };
}

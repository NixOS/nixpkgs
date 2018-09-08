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

      dataDir = mkOption {
        type = types.path;
        default = "/var/db/sks";
        example = "/var/lib/sks";
        # TODO: The default might change to "/var/lib/sks" as this is more
        # common. There's also https://github.com/NixOS/nixpkgs/issues/26256
        # and "/var/db" is not FHS compliant (seems to come from BSD).
        description = ''
          Data directory (-basedir) for SKS, where the database and all
          configuration files are located (e.g. KDB, PTree, membership and
          sksconf).
        '';
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
      home = cfg.dataDir;
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

{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.sks;
  sksPkg = cfg.package;

in {
  meta.maintainers = with maintainers; [ primeos calbrecht jcumming ];

  options = {

    services.sks = {

      enable = mkEnableOption ''
        SKS (synchronizing key server for OpenPGP) and start the database
        server. You need to create "''${dataDir}/dump/*.gpg" for the initial
        import'';

      package = mkOption {
        default = pkgs.sks;
        defaultText = "pkgs.sks";
        type = types.package;
        description = "Which SKS derivation to use.";
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
        description = ''
          Domain names, IPv4 and/or IPv6 addresses to listen on for HKP
          requests.
        '';
      };

      hkpPort = mkOption {
        default = 11371;
        type = types.ints.u16;
        description = "HKP port to listen on.";
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
      "sks-db" = {
        description = "SKS database server";
        after = [ "network.target" ];
        wantedBy = [ "multi-user.target" ];
        preStart = ''
          mkdir -p ${home}/dump
          ${sksPkg}/bin/sks build ${home}/dump/*.gpg -n 10 -cache 100 || true #*/
          ${sksPkg}/bin/sks cleandb || true
          ${sksPkg}/bin/sks pbuild -cache 20 -ptree_cache 70 || true
        '';
        serviceConfig = {
          WorkingDirectory = home;
          User = user;
          Restart = "always";
          ExecStart = "${sksPkg}/bin/sks db -hkp_address ${hkpAddress} -hkp_port ${hkpPort}";
        };
      };
    };
  };
}

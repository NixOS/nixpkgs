{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.sks;

  sksPkg = cfg.package;

  sksConf = pkgs.writeText "sksconf" ''
    hostname: ${cfg.hostname}
    hkp_address: ${concatStringsSep " " cfg.hkpAddress}
    hkp_port: ${toString cfg.hkpPort}

    ${optionalString (cfg.disableMailsync) "disable_mailsync:"}

    ${cfg.extraConfig}
  '';

  membershipConf = pkgs.writeText "membership" ''
    # A list of SKS keyservers to synchronize with

    # Example:
    #keyserver.linux.it 11370
  '';

  mailsyncConf = pkgs.writeText "mailsync" ''
    # A list of PKS keyserver email addresses to synchronize with

    # Example:
    #pgp-public-keys@pgp.mit.edu
  '';

in

{

  options = {

    services.sks = {

      enable = mkEnableOption "Whether to enable the SKS keyserver";

      hostname = mkOption {
        type = types.string;
        default = "localhost";
        description = ''
          The publicly available FQDN under which this SKS is provided.
        '';
      };

      package = mkOption {
        type = types.package;
        default = pkgs.sks;
        defaultText = "pkgs.sks";
        description = "
          Which SKS derivation to use.
        ";
      };

      hkpAddress = mkOption {
        type = types.listOf types.str;
        default = [ "::1" "127.0.0.1" ];
        description = "
          Which IP addresses SKS is listening on.
        ";
      };

      disableMailsync = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Disable sending of PKS mailsync messages. This should only
          be activated for standalone servers with an empty mailsyncConfig
          so as to avoid a log file overflowing with ``Failure("No partners specified")``
          errors."
        '';
      };

      hkpPort = mkOption {
        type = types.int;
        default = 11371;
        description = "
          Which port SKS is listening on.
        ";
      };

      membershipConfig = mkOption {
        type = types.lines;
        default = membershipConf;
        description = ''
          The SKS will attempt to synchronize its keystore with these
          SKS keyservers.
        '';
      };

      mailsyncConfig = mkOption {
        type = types.lines;
        default = mailsyncConf;
        description = ''
          The SKS will attempt to synchronize its keystore with these
          PKS keyservers.
        '';
      };

      extraConfig = mkOption {
        type = types.lines;
        default = "";
        description = ''
          Configuration lines appended to the main SKS config.
        '';
      };
    };
  };

  config = mkIf cfg.enable {

    environment.systemPackages = [ sksPkg ];

    users = {
      users.sks = {
        createHome = true;
        home = "/var/db/sks";
        isSystemUser = true;
        uid = config.ids.uids.sks;
        group = "sks";
        shell = "${pkgs.coreutils}/bin/true";
      };

      groups."sks".gid = config.ids.gids.sks;
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

          # link the configuration files
          ln -sfn ${sksConf} ${home}/sksconf
          ln -sfn ${membershipConf} ${home}/membership
          ln -sfn ${mailsyncConf} ${home}/mailsync
        '';
        serviceConfig = {
          WorkingDirectory = home;
          User = user;
          Restart = "always";
          ExecStart = "${pkgs.sks}/bin/sks db -basedir ${home}";
        };
      };
    };
  };
}

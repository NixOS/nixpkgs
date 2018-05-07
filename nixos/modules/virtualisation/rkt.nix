{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.virtualisation.rkt;
  dataDir = "/var/lib/rkt";

in
{
  options.virtualisation.rkt = {
    enable = mkEnableOption "rkt metadata service";

    useSocketActivation = mkOption {
      default = false;
      type = types.bool;
      description = "Only run the service on demand.";
    };

    gc = {
      automatic = mkOption {
        default = true;
        type = types.bool;
        description = "Automatically run the garbage collector at a specific time.";
      };

      dates = mkOption {
        default = "03:15";
        type = types.str;
        description = ''
          Specification (in the format described by
          <citerefentry><refentrytitle>systemd.time</refentrytitle>
          <manvolnum>7</manvolnum></citerefentry>) of the time at
          which the garbage collector will run.
        '';
      };

      options = mkOption {
        default = "--grace-period=24h";
        type = types.str;
        description = ''
          Options given to <filename>rkt gc</filename> when the
          garbage collector is run automatically.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ rkt ];

    systemd.services = {
      rkt-api = {
        description = "rkt api service";
        wantedBy = lib.mkIf (!cfg.useSocketActivation) [ "multi-user.target" ];
        after = [ "network.target" "rkt-api-tcp.socket" ];
        requires = [ "rkt-api-tcp.socket" ];
        serviceConfig = {
          ExecStart = "${pkgs.rkt}/bin/rkt api-service";
          DynamicUser = true;
          SupplementaryGroups = [ "rkt" ];
          ReadWritePaths = dataDir;
        };
      };

      rkt-metadata = {
        description = "rkt metadata service";
        wantedBy = lib.mkIf (!cfg.useSocketActivation) [ "multi-user.target" ];
        after = [ "network.target" "rkt-metadata.socket" ];
        requires = [ "rkt-metadata.socket" ];
        serviceConfig = {
          ExecStart = "${pkgs.rkt}/bin/rkt metadata-service";
        };
      };

      rkt-gc = {
        description = "rkt garbage collection";
        startAt = optionalString cfg.gc.automatic cfg.gc.dates;
        serviceConfig = {
          Type = "oneshot";
          ExecStart = "${pkgs.rkt}/bin/rkt gc ${cfg.gc.options}";
        };
      };
    };

    systemd.sockets = {
      rkt-api-tcp = {
        description = "rkt api service socket";
        wantedBy = lib.mkIf cfg.useSocketActivation [ "sockets.target" ];
        partOf = [ "rkt-api.service" ];
        socketConfig = {
          ListenStream = [ "127.0.0.1:15441" ] ++ lib.optional config.networking.enableIPv6 "[::1]:15441";
          Service = "rkt-api.service";
          BindIPv6Only = lib.mkIf config.networking.enableIPv6 "both";
        };
      };

      rkt-metadata = {
        description = "rkt metadata service socket";
        wantedBy = lib.mkIf cfg.useSocketActivation [ "sockets.target" ];
        partOf = [ "rkt-metadata.service" ];
        socketConfig = {
          ListenStream = "/run/rkt/metadata-svc.sock";
          SocketMode = "0660";
          SocketUser = "root";
          SocketGroup = "root";
          RemoveOnStop = true;
        };
      };
    };

    systemd.tmpfiles.rules = [
      "d ${dataDir} 2750 root rkt"
      "d ${dataDir}/tmp 2750 root rkt"

      "d ${dataDir}/cas 2770 root rkt"
      "d ${dataDir}/cas/db 2770 root rkt"
      "f ${dataDir}/cas/db/ql.db 0660 root rkt"
      # the ql database uses a WAL file whose name is generated from the sha1 hash of
      # the database name
      "f ${dataDir}/cas/db/.34a8b4c1ad933745146fdbfef3073706ee571625 0660 root rkt"
      "d ${dataDir}/cas/imagelocks 2770 root rkt"
      "d ${dataDir}/cas/imageManifest 2770 root rkt"
      "d ${dataDir}/cas/blob 2770 root rkt"
      "d ${dataDir}/cas/tmp 2770 root rkt"
      "d ${dataDir}/cas/tree 2700 root rkt"
      "d ${dataDir}/cas/treestorelocks 2700 root rkt"
      "d ${dataDir}/locks 2750 root rkt"

      "d ${dataDir}/pods 2750 root rkt"
      "d ${dataDir}/pods/embryo 2750 root rkt"
      "d ${dataDir}/pods/prepare 2750 root rkt"
      "d ${dataDir}/pods/prepared 2750 root rkt"
      "d ${dataDir}/pods/run 2750 root rkt"
      "d ${dataDir}/pods/exited-garbage 2750 root rkt"
      "d ${dataDir}/pods/garbage 2750 root rkt"

      # "d /etc/rkt 2775 root rkt-admin"
    ];

    users.extraGroups.rkt = {};
  };
}

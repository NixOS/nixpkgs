{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.services.notbit;
  varDir = "/var/lib/notbit";
  
  sendmail = pkgs.stdenv.mkDerivation {
    name = "notbit-wrapper";
    buildInputs = [ pkgs.makeWrapper ];
    propagatedBuildInputs = [ pkgs.notbit ];
    buildCommand = ''
      mkdir -p $out/bin
      makeWrapper ${pkgs.notbit}/bin/notbit-sendmail $out/bin/notbit-system-sendmail \
        --set XDG_RUNTIME_DIR ${varDir}
    '';
  };
  opts = "${optionalString cfg.allowPrivateAddresses "-L"} ${optionalString cfg.noBootstrap "-b"} ${optionalString cfg.specifiedPeersOnly "-e"}";
  peers = concatStringsSep " " (map (str: "-P \"${str}\"") cfg.peers);
  listen = if cfg.listenAddress == [] then "-p ${toString cfg.port}" else
    concatStringsSep " " (map (addr: "-a \"${addr}:${toString cfg.port}\"") cfg.listenAddress);
in

with lib;
{

  ### configuration

  options = {

    services.notbit = {

      enable = mkOption {
        type = types.uniq types.bool;
        default = false;
        description = ''
          Enables the notbit daemon and provides a sendmail binary named `notbit-system-sendmail` for sending mail over the system instance of notbit. Users must be in the notbit group in order to send mail over the system notbit instance. Currently mail recipt is not supported.
        '';
      };

      port = mkOption {
        type = types.uniq types.int;
        default = 8444;
        description = "The port which the daemon listens for other bitmessage clients";
      };

      nice = mkOption {
        type = types.uniq types.int;
        default = 10;
        description = "Set the nice level for the notbit daemon";
      };

      listenAddress = mkOption {
        type = types.listOf types.str;
        default = [ ];
        example = [ "localhost" "myhostname" ];
        description = "The addresses which notbit will use to listen for incoming connections. These addresses are advertised to connecting clients.";
      };

      peers = mkOption {
        type = types.listOf types.str;
        default = [ ];
        example = [ "bitmessage.org:8877" ];
        description = "The initial set of peers notbit will connect to.";
      };

      specifiedPeersOnly = mkOption {
        type = types.uniq types.bool;
        default = false;
        description = "If true, notbit will only connect to peers specified by the peers option.";
      };

      allowPrivateAddresses = mkOption {
        type = types.uniq types.bool;
        default = false;
        description = "If true, notbit will allow connections to to RFC 1918 addresses.";
      };

      noBootstrap = mkOption {
        type = types.uniq types.bool;
        default = false;
        description = "If true, notbit will not bootstrap an initial peerlist from bitmessage.org servers";
      };

    };

  };

  ### implementation

  config = mkIf cfg.enable {

    environment.systemPackages = [ sendmail ];

    systemd.services.notbit = {
      description = "Notbit daemon";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      path = [ pkgs.notbit ];
      environment = { XDG_RUNTIME_DIR = varDir; };

      postStart = ''
        [ ! -f "${varDir}/addr" ] && notbit-keygen > ${varDir}/addr
        chmod 0640 ${varDir}/{addr,notbit/notbit-ipc.lock}
        chmod 0750 ${varDir}/notbit/{,notbit-ipc}
      '';

      serviceConfig = {
        Type = "forking";
        ExecStart = "${pkgs.notbit}/bin/notbit -d ${listen} ${peers} ${opts}";
        User = "notbit";
        Group = "notbit";
        UMask = "0077";
        WorkingDirectory = varDir;
        Nice = cfg.nice;
      };
    };

    users.extraUsers.notbit = {
      group = "notbit";
      description = "Notbit daemon user";
      home = varDir;
      createHome = true;
      uid = config.ids.uids.notbit;
    };

    users.extraGroups.notbit.gid = config.ids.gids.notbit;
  };

}

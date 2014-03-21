{ config, pkgs, ... }:

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
in

with pkgs.lib;
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
        default = 8443;
        description = "The port which the daemon listens for other bitmessage clients";
      };

      nice = mkOption {
        type = types.uniq types.int;
        default = 10;
        description = "Set the nice level for the notbit daemon";
      };

    };

  };

  ### implementation

  config = mkIf cfg.enable {

    environment.systemPackages = [ pkgs.notbit sendmail ];

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
        ExecStart = "${pkgs.notbit}/bin/notbit -d -p ${toString cfg.port}";
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

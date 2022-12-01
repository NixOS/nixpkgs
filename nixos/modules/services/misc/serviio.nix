{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.serviio;

  serviioStart = pkgs.writeScript "serviio.sh" ''
    #!${pkgs.bash}/bin/sh

    SERVIIO_HOME=${pkgs.serviio}

    # Setup the classpath
    SERVIIO_CLASS_PATH="$SERVIIO_HOME/lib/*:$SERVIIO_HOME/config"

    # Setup Serviio specific properties
    JAVA_OPTS="-Djava.net.preferIPv4Stack=true -Djava.awt.headless=true -Dorg.restlet.engine.loggerFacadeClass=org.restlet.ext.slf4j.Slf4jLoggerFacade
               -Dderby.system.home=${cfg.dataDir}/library -Dserviio.home=${cfg.dataDir} -Dffmpeg.location=${pkgs.ffmpeg}/bin/ffmpeg -Ddcraw.location=${pkgs.dcraw}/bin/dcraw"

    # Execute the JVM in the foreground
    exec ${pkgs.jre}/bin/java -Xmx512M -Xms20M -XX:+UseG1GC -XX:GCTimeRatio=1 -XX:MinHeapFreeRatio=10 -XX:MaxHeapFreeRatio=20 $JAVA_OPTS -classpath "$SERVIIO_CLASS_PATH" org.serviio.MediaServer "$@"
  '';

in {

  ###### interface
  options = {
    services.serviio = {

      enable = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc ''
          Whether to enable the Serviio Media Server.
        '';
      };

      dataDir = mkOption {
        type = types.path;
        default = "/var/lib/serviio";
        description = lib.mdDoc ''
          The directory where serviio stores its state, data, etc.
        '';
      };

    };
  };

  ###### implementation

  config = mkIf cfg.enable {
    systemd.services.serviio = {
      description = "Serviio Media Server";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      path = [ pkgs.serviio ];
      serviceConfig = {
        User = "serviio";
        Group = "serviio";
        ExecStart = "${serviioStart}";
        ExecStop = "${serviioStart} -stop";
      };
    };

    users.users.serviio =
      { group = "serviio";
        home = cfg.dataDir;
        description = "Serviio Media Server User";
        createHome = true;
        isSystemUser = true;
      };

    users.groups.serviio = { };

    networking.firewall = {
      allowedTCPPorts = [
        8895  # serve UPnP responses
        23423 # console
        23424 # mediabrowser
      ];
      allowedUDPPorts = [
        1900 # UPnP service discovey
      ];
    };
  };
}

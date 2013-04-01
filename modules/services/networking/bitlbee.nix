{ config, pkgs, ... }:

with pkgs.lib;

let

  cfg = config.services.bitlbee;
  bitlbeeUid = config.ids.uids.bitlbee;

  authModeCheck = v:
    v == "Open" ||
    v == "Closed" ||
    v == "Registered";

  bitlbeeConfig = pkgs.writeText "bitlbee.conf"
    ''
    [settings]
    RunMode = Daemon
    User = bitlbee  
    ConfigDir = /var/lib/bitlbee      
    DaemonInterface = ${cfg.interface}
    DaemonPort = ${toString cfg.portNumber}
    AuthMode = ${cfg.authMode}
    ${cfg.extraSettings}

    [defaults]
    ${cfg.extraDefaults}
    '';

in

{

  ###### interface

  options = {

    services.bitlbee = {

      enable = mkOption {
        default = false;
        description = ''
          Whether to run the BitlBee IRC to other chat network gateway.
          Running it allows you to access the MSN, Jabber, Yahoo! and ICQ chat
          networks via an IRC client.
        '';
      };

      interface = mkOption {
        default = "127.0.0.1";
        description = ''
          The interface the BitlBee deamon will be listening to.  If `127.0.0.1',
          only clients on the local host can connect to it; if `0.0.0.0', clients
          can access it from any network interface.
        '';
      };

      portNumber = mkOption {
        default = 6667;
        description = ''
          Number of the port BitlBee will be listening to.
        '';
      };

      authMode = mkOption {
        default = "Open";
        check = authModeCheck;
        description = ''
          The following authentication modes are available:
            Open -- Accept connections from anyone, use NickServ for user authentication.
            Closed -- Require authorization (using the PASS command during login) before allowing the user to connect at all.
            Registered -- Only allow registered users to use this server; this disables the register- and the account command until the user identifies himself.
        ''; 
      };

      extraSettings = mkOption {
        default = "";
        description = ''
          Will be inserted in the Settings section of the config file.
        ''; 
      };

      extraDefaults = mkOption {
        default = "";
        description = ''
          Will be inserted in the Default section of the config file.
        ''; 
      };

    };

  };

  ###### implementation

  config = mkIf config.services.bitlbee.enable {

    users.extraUsers = singleton
      { name = "bitlbee";
        uid = bitlbeeUid;
        description = "BitlBee user";
        home = "/var/lib/bitlbee";
        createHome = true;
      };

    users.extraGroups = singleton
      { name = "bitlbee";
        gid = config.ids.gids.bitlbee;
      };

    systemd.services.bitlbee = 
      { description = "BitlBee IRC to other chat networks gateway";
        after = [ "network.target" ];
        wantedBy = [ "multi-user.target" ];
        serviceConfig.User = "bitlbee";
        serviceConfig.ExecStart = "${pkgs.bitlbee}/sbin/bitlbee -F -n -c ${bitlbeeConfig}";
      };

    environment.systemPackages = [ pkgs.bitlbee ];

  };

}

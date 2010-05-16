{ config, pkgs, ... }:

with pkgs.lib;

let

  inherit (pkgs) tor privoxy;

  stateDir = "/var/lib/tor";
  privoxyDir = stateDir+"/privoxy";

  modprobe = config.system.sbin.modprobe;

  torUser = "tor";

in

{

  ###### interface
  
  options = {
  
    services.tor = {

      enable = mkOption {
        default = false;
        description = ''
          Whether to enable the Tor anonymous routing daemon.
        '';
      };

      socksListenAddress = mkOption {
        default = "127.0.0.1:9050";
        example = "192.168.0.1";
        description = ''
          Bind to this address to listen for connections from Socks-speaking 
          applications. You can also specify a port.
        '';
      };

      config = mkOption {
        default = "";
        description = ''
          Extra configuration. Contents will be added verbatim to the 
          configuration file.
        '';
      };

      enablePrivoxy = mkOption {
        default = true;
        description = ''
          Whether to enable a special instance of privoxy dedicated to Tor.
          To have anonymity, protocols need to be scrubbed of identifying 
          information.
          Most people using Tor want to anonymize their web traffic, so by 
          default we enable an special instance of privoxy specifically for
          Tor.
          However, if you are only going to use Tor only as a relay then you
          can disable this option.
        '';
      };
      
      privoxyListenAddress = mkOption {
        default = "127.0.0.1:8118";
        description = ''
          Address that Tor's instance of privoxy is listening to.
          *This does not configure the standard NixOS instance of privoxy.*  
          This is for Tor connections only! 
          See services.privoxy.listenAddress to configure the standard NixOS 
          instace of privoxy.
        '';
      };

      privoxyConfig = mkOption {
        default = "";
        description = ''
          Extra configuration for Tor's instance of privoxy. Contents will be 
          added verbatim to the configuration file.
          *This does not configure the standard NixOS instance of privoxy.* 
          This is for Tor connections only! 
          See services.privoxy.extraConfig to configure the standard NixOS 
          instace of privoxy.
        '';
      };
    };

  };


  ###### implementation

  config = mkIf config.services.tor.enable {
    environment.systemPackages = [ tor ];  # provides tor-resolve and torify
  
    users.extraUsers = singleton
      { name = torUser;
        uid = config.ids.uids.tor;
        description = "Tor daemon user";
        home = stateDir;
      };

    jobs.tor =
      { name = "Tor";

        startOn = "started network-interfaces";
        stopOn = "stopping network-interfaces";

        preStart =
          ''
            mkdir -m 0755 -p ${stateDir}
            chown ${torUser} ${stateDir}
          '';
        exec = "${tor}/bin/tor -f ${pkgs.writeText "torrc" config.services.tor.config}";
      };

    jobs.torPrivoxy = mkIf config.services.tor.enablePrivoxy 
      { name = "Tor-privoxy";

        startOn = "starting Tor";
        stopOn = "stopping Tor"; 

        preStart =
          ''
            mkdir -m 0755 -p ${privoxyDir}
            chown ${torUser} ${privoxyDir}

            # Needed to run privoxy as an unprivileged user?
            ${modprobe}/sbin/modprobe capability || true
          '';
        exec = "${privoxy}/sbin/privoxy --no-daemon --user ${torUser} ${pkgs.writeText "torPrivoxy.conf" config.services.tor.privoxyConfig}";
      };

      services.tor.config = ''
        DataDirectory ${stateDir}
        User ${torUser}
        SocksListenAddress ${config.services.tor.socksListenAddress}
    
        # Extra configurations go here
      '';
    
      services.tor.privoxyConfig = ''
        # Generally, this file goes in /etc/privoxy/config
        #
        # Tor listens as a SOCKS4a proxy here:
        forward-socks4a / ${config.services.tor.socksListenAddress} .
        confdir ${privoxy}/etc
        logdir ${privoxyDir}
        # actionsfile standard  # Internal purpose, recommended
        actionsfile default.action   # Main actions file
        actionsfile user.action      # User customizations
        filterfile default.filter
        
        # Don't log interesting things, only startup messages, warnings and errors
        logfile logfile
        #jarfile jarfile
        #debug   0    # show each GET/POST/CONNECT request
        debug   4096 # Startup banner and warnings
        debug   8192 # Errors - *we highly recommended enabling this*
        
        user-manual ${privoxy}/doc/privoxy/user-manual
        listen-address  ${config.services.tor.privoxyListenAddress}
        toggle  1
        enable-remote-toggle 0
        enable-edit-actions 0
        enable-remote-http-toggle 0
        buffer-limit 4096
    
        # Extra config goes here
      '';
     
  };
  
}

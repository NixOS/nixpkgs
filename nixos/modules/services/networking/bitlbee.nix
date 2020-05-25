{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.bitlbee;
  bitlbeeUid = config.ids.uids.bitlbee;

  bitlbeePkg = pkgs.bitlbee.override {
    enableLibPurple = cfg.libpurple_plugins != [];
    enablePam = cfg.authBackend == "pam";
  };

  bitlbeeConfig = pkgs.writeText "bitlbee.conf"
    ''
    [settings]
    RunMode = Daemon
    User = bitlbee
    ConfigDir = ${cfg.configDir}
    DaemonInterface = ${cfg.interface}
    DaemonPort = ${toString cfg.portNumber}
    AuthMode = ${cfg.authMode}
    AuthBackend = ${cfg.authBackend}
    Plugindir = ${pkgs.bitlbee-plugins cfg.plugins}/lib/bitlbee
    ${lib.optionalString (cfg.hostName != "") "HostName = ${cfg.hostName}"}
    ${lib.optionalString (cfg.protocols != "") "Protocols = ${cfg.protocols}"}
    ${cfg.extraSettings}

    [defaults]
    ${cfg.extraDefaults}
    '';

  purple_plugin_path =
    lib.concatMapStringsSep ":"
      (plugin: "${plugin}/lib/pidgin/:${plugin}/lib/purple-2/")
      cfg.libpurple_plugins
    ;

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

      authBackend = mkOption {
        default = "storage";
        type = types.enum [ "storage" "pam" ];
        description = ''
          How users are authenticated
            storage -- save passwords internally
            pam -- Linux PAM authentication
        '';
      };

      authMode = mkOption {
        default = "Open";
        type = types.enum [ "Open" "Closed" "Registered" ];
        description = ''
          The following authentication modes are available:
            Open -- Accept connections from anyone, use NickServ for user authentication.
            Closed -- Require authorization (using the PASS command during login) before allowing the user to connect at all.
            Registered -- Only allow registered users to use this server; this disables the register- and the account command until the user identifies himself.
        '';
      };

      hostName = mkOption {
        default = "";
        type = types.str;
        description = ''
          Normally, BitlBee gets a hostname using getsockname(). If you have a nicer
          alias for your BitlBee daemon, you can set it here and BitlBee will identify
          itself with that name instead.
        '';
      };

      plugins = mkOption {
        type = types.listOf types.package;
        default = [];
        example = literalExample "[ pkgs.bitlbee-facebook ]";
        description = ''
          The list of bitlbee plugins to install.
        '';
      };

      libpurple_plugins = mkOption {
        type = types.listOf types.package;
        default = [];
        example = literalExample "[ pkgs.purple-matrix ]";
        description = ''
          The list of libpurple plugins to install.
        '';
      };

      configDir = mkOption {
        default = "/var/lib/bitlbee";
        type = types.path;
        description = ''
          Specify an alternative directory to store all the per-user configuration
          files.
        '';
      };

      protocols = mkOption {
        default = "";
        type = types.str;
        description = ''
          This option allows to remove the support of protocol, even if compiled
          in. If nothing is given, there are no restrictions.
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

  config =  mkMerge [
    (mkIf config.services.bitlbee.enable {
      users.users.bitlbee = {
        uid = bitlbeeUid;
        description = "BitlBee user";
        home = "/var/lib/bitlbee";
        createHome = true;
      };

      users.groups.bitlbee = {
        gid = config.ids.gids.bitlbee;
      };

      systemd.services.bitlbee = {
        environment.PURPLE_PLUGIN_PATH = purple_plugin_path;
        description = "BitlBee IRC to other chat networks gateway";
        after = [ "network.target" ];
        wantedBy = [ "multi-user.target" ];
        serviceConfig.User = "bitlbee";
        serviceConfig.ExecStart = "${bitlbeePkg}/sbin/bitlbee -F -n -c ${bitlbeeConfig}";
      };

      environment.systemPackages = [ bitlbeePkg ];

    })
    (mkIf (config.services.bitlbee.authBackend == "pam") {
      security.pam.services.bitlbee = {};
    })
  ];

}

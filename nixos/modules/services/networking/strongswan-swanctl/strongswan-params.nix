# See: https://wiki.strongswan.org/projects/strongswan/wiki/StrongswanConf
#
# When strongSwan is upgraded please update the parameters in this file. You can
# see which parameters should be deleted, changed or added by diffing
# the strongswan conf directory:
#
#   git clone https://github.com/strongswan/strongswan.git
#   cd strongswan
#   git diff 5.5.3..5.6.0 conf/

lib: with (import ./param-constructors.nix lib);

let charonParams = import ./strongswan-charon-params.nix lib;
in {
  aikgen = {
    load = mkSpaceSepListParam [] ''
      Plugins to load in ipsec aikgen tool.
    '';
  };
  attest = {
    database = mkOptionalStrParam ''
      File measurement information database URI. If it contains a password,
      make sure to adjust the permissions of the config file accordingly.
    '';

    load = mkSpaceSepListParam [] ''
      Plugins to load in ipsec attest tool.
    '';
  };

  charon = charonParams;

  charon-nm = {
    ca_dir = mkStrParam "<default>" ''
      Directory from which to load CA certificates if no certificate is
      configured.
    '';
  };

  charon-systemd = charonParams // {
    journal = import ./strongswan-loglevel-params.nix lib;
  };

  imv_policy_manager = {
    command_allow = mkOptionalStrParam ''
      Shell command to be executed with recommendation allow.
    '';

    command_block = mkOptionalStrParam ''
      Shell command to be executed with all other recommendations.
    '';

    database = mkOptionalStrParam ''
      Database URI for the database that stores the package information. If it
      contains a password, make sure to adjust permissions of the config file
      accordingly.
    '';

    load = mkSpaceSepListParam ["sqlite"] ''
      Plugins to load in IMV policy manager.
    '';
  };

  libimcv = import ./strongswan-libimcv-params.nix lib;

  manager = {
    database = mkOptionalStrParam ''
      Credential database URI for manager. If it contains a password, make
      sure to adjust the permissions of the config file accordingly.
    '';

    debug = mkYesNoParam no ''
      Enable debugging in manager.
    '';

    load = mkSpaceSepListParam [] ''
      Plugins to load in manager.
    '';

    socket = mkOptionalStrParam ''
      FastCGI socket of manager, to run it statically.
    '';

    threads = mkIntParam 10 ''
      Threads to use for request handling.
    '';

    timeout = mkDurationParam "15m" ''
      Session timeout for manager.
    '';
  };

  medcli = {
    database = mkOptionalStrParam ''
      Mediation client database URI. If it contains a password, make sure to
      adjust the permissions of the config file accordingly.
    '';

    dpd = mkDurationParam "5m" ''
      DPD timeout to use in mediation client plugin.
    '';

    rekey = mkDurationParam "20m" ''
      Rekeying time on mediation connections in mediation client plugin.
    '';
  };

  medsrv = {
    database = mkOptionalStrParam ''
      Mediation server database URI. If it contains a password, make sure to
      adjust the permissions of the config file accordingly.
    '';

    debug = mkYesNoParam no ''
      Debugging in mediation server web application.
    '';

    dpd = mkDurationParam "5m" ''
      DPD timeout to use in mediation server plugin.
    '';

    load = mkSpaceSepListParam [] ''
      Plugins to load in mediation server plugin.
    '';

    password_length = mkIntParam 6 ''
      Minimum password length required for mediation server user accounts.
    '';

    rekey = mkDurationParam "20m" ''
      Rekeying time on mediation connections in mediation server plugin.
    '';

    socket = mkOptionalStrParam ''
      Run Mediation server web application statically on socket.
    '';

    threads = mkIntParam 5 ''
      Number of thread for mediation service web application.
    '';

    timeout = mkDurationParam "15m" ''
      Session timeout for mediation service.
    '';
  };

  pacman.database = mkOptionalStrParam ''
    Database URI for the database that stores the package information. If it
    contains a password, make sure to adjust the permissions of the config
    file accordingly.
  '';

  pki.load = mkSpaceSepListParam [] ''
    Plugins to load in ipsec pki tool.
  '';

  pool = {
    database = mkOptionalStrParam ''
      Database URI for the database that stores IP pools and configuration
      attributes. If it contains a password, make sure to adjust the
      permissions of the config file accordingly.
    '';

    load = mkSpaceSepListParam [] ''
      Plugins to load in ipsec pool tool.
    '';
  };

  pt-tls-client.load = mkSpaceSepListParam [] ''
    Plugins to load in ipsec pt-tls-client tool.
  '';

  scepclient.load = mkSpaceSepListParam [] ''
    Plugins to load in ipsec scepclient tool.
  '';

  starter = {
    config_file = mkStrParam "\${sysconfdir}/ipsec.conf" ''
      Location of the ipsec.conf file.
    '';

    load_warning = mkYesNoParam yes ''
      Show charon.load setting warning, see
      https://wiki.strongswan.org/projects/strongswan/wiki/PluginLoad
    '';
  };

  sw-collector = {
    database = mkOptionalStrParam ''
      URI to software collector database containing event timestamps,
      software creation and deletion events and collected software
      identifiers. If it contains a password, make sure to adjust the
      permissions of the config file accordingly.
    '';

    first_file = mkStrParam "/var/log/bootstrap.log" ''
      Path pointing to file created when the Linux OS was installed.
    '';

    first_time = mkStrParam "0000-00-00T00:00:00Z" ''
      Time in UTC when the Linux OS was installed.
    '';

    history = mkOptionalStrParam ''
      Path pointing to apt history.log file.
    '';

    rest_api = {
      uri = mkOptionalStrParam ''
        HTTP URI of the central collector's REST API.
      '';

      timeout = mkIntParam 120 ''
        Timeout of REST API HTTP POST transaction.
      '';
    };

    load = mkSpaceSepListParam [] "Plugins to load in sw-collector tool.";
  };

  swanctl = {
    load = mkSpaceSepListParam [] "Plugins to load in swanctl.";

    socket = mkStrParam "unix://\${piddir}/charon.vici" ''
      VICI socket to connect to by default.
    '';
  };
}

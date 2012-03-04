{ config, pkgs, ... }:

with pkgs.lib;

let

  cfg = config.services.gw6c;

  gw6cService = pkgs.stdenv.mkDerivation {
    name = "gw6c-service";
    inherit (pkgs) gw6c coreutils procps upstart iputils gnused gnugrep seccure;

    inherit (cfg) username password keepAlive everPing;

    gw6server = cfg.server;
    authMethod = if cfg.username == "" then "anonymous" else "any";
    gw6dir = pkgs.gw6c;

    pingBefore = if cfg.waitPingableBroker then "true" else "";

    pubkey = config.security.seccureKeys.public;
    privkey = config.security.seccureKeys.private;

    buildCommand =
      ''
        mkdir -p $out/bin $out/conf

        mkdir conf
        chmod 0700 conf
        touch conf/raw
        chmod 0700 conf/raw

        substituteAll ${./gw6c.conf} conf/raw
        $seccure/bin/seccure-encrypt "$(cat $pubkey)" -i conf/raw -o $out/conf/gw6c.conf
        substituteAll ${./control.in} $out/bin/control
        chmod a+x $out/bin/control
      '';
  };

in

{

  ###### interface

  options = {

    services.gw6c = {

      enable = mkOption {
        default = false;
        description = "
          Whether to enable Gateway6 client (IPv6 tunnel).
        ";
      };

      autorun = mkOption {
        default = true;
        description = "
          Switch to false to create upstart-job and configuration,
          but not run it automatically
        ";
      };

      username = mkOption {
        default = "";
        description = "
          Your Gateway6 login name, if any.
        ";
      };

      password = mkOption {
        default = "";
        description = "
          Your Gateway6 password, if any.
        ";
      };

      server = mkOption {
        default = "anon.freenet6.net";
        example = "broker.freenet6.net";
        description = "
          Used Gateway6 server.
        ";
      };

      keepAlive = mkOption {
        default = "30";
        example = "2";
        description = "
          Gateway6 keep-alive period.
        ";
      };

      everPing = mkOption {
        default = "1000000";
        example = "2";
        description = "
          Gateway6 manual ping period.
        ";
      };

      waitPingableBroker = mkOption {
        default = true;
        example = false;
        description = "
          Whether to wait until tunnel broker returns ICMP echo.
        ";
      };

    };

    security.seccureKeys = {

      # !!! It's not clear to me (ED) what additional security this
      # provides.  Passwords shouldn't be in configuration.nix,
      # period.  You could just place the password in
      # /var/blah/password or whatever.

      public = mkOption {
        default = /var/elliptic-keys/public;
        description = "
          Public key. Make it path argument, so it is copied into store and
          hashed.

          The key is used to encrypt Gateway 6 configuration in store, as it
          contains a password for external service. Unfortunately,
          derivation file should be protected by other means. For example,
          nix-http-export.cgi will happily export any non-derivation path,
          but not a derivation.
        ";
      };

      private = mkOption {
        default = "/var/elliptic-keys/private";
        description = "
          Private key. Make it string argument, so it is not copied into store.
        ";
      };

    };

  };


  ###### implementation

  config = mkIf cfg.enable {

    jobs.gw6c =
      { description = "Gateway6 client";

        startOn = optionalString cfg.autorun "starting networking";
        stopOn = "stopping network-interfaces";

        exec = "${gw6cService}/bin/control start";
      };

    networking.enableIPv6 = true;

  };

}

{ config, lib, pkgs, ... }:
let
  cfgs = config.services;
  cfg  = cfgs.ncdns;

  dataDir  = "/var/lib/ncdns";
  username = "ncdns";

  valueType = with lib.types; oneOf [ int str bool path ]
    // { description = "setting type (integer, string, bool or path)"; };

  configType = with lib.types; attrsOf (nullOr (either valueType configType))
    // { description = ''
          ncdns.conf configuration type. The format consists of an
          attribute set of settings. Each setting can be either `null`,
          a value or an attribute set. The allowed values are integers,
          strings, booleans or paths.
         '';
       };

  configFile = pkgs.runCommand "ncdns.conf"
    { json = builtins.toJSON cfg.settings;
      passAsFile = [ "json" ];
    }
    "${pkgs.remarshal}/bin/json2toml < $jsonPath > $out";

  defaultFiles = {
    public  = "${dataDir}/bit.key";
    private = "${dataDir}/bit.private";
    zonePublic  = "${dataDir}/bit-zone.key";
    zonePrivate = "${dataDir}/bit-zone.private";
  };

  # if all keys are the default value
  needsKeygen = lib.all lib.id (lib.flip lib.mapAttrsToList cfg.dnssec.keys
    (n: v: v == lib.getAttr n defaultFiles));

  mkDefaultAttrs = lib.mapAttrs (n: v: lib.mkDefault v);

in

{

  ###### interface

  options = {

    services.ncdns = {

      enable = lib.mkEnableOption ''
        ncdns, a Go daemon to bridge Namecoin to DNS.
        To resolve .bit domains set `services.namecoind.enable = true;`
        and an RPC username/password
      '';

      address = lib.mkOption {
        type = lib.types.str;
        default = "[::1]";
        description = ''
          The IP address the ncdns resolver will bind to.  Leave this unchanged
          if you do not wish to directly expose the resolver.
        '';
      };

      port = lib.mkOption {
        type = lib.types.port;
        default = 5333;
        description = ''
          The port the ncdns resolver will bind to.
        '';
      };

      identity.hostname = lib.mkOption {
        type = lib.types.str;
        default = config.networking.hostName;
        defaultText = lib.literalExpression "config.networking.hostName";
        example = "example.com";
        description = ''
          The hostname of this ncdns instance, which defaults to the machine
          hostname. If specified, ncdns lists the hostname as an NS record at
          the zone apex:
          ```
          bit. IN NS ns1.example.com.
          ```
          If unset ncdns will generate an internal pseudo-hostname under the
          zone, which will resolve to the value of
          {option}`services.ncdns.identity.address`.
          If you are only using ncdns locally you can ignore this.
        '';
      };

      identity.hostmaster = lib.mkOption {
        type = lib.types.str;
        default = "";
        example = "root@example.com";
        description = ''
          An email address for the SOA record at the bit zone.
          If you are only using ncdns locally you can ignore this.
        '';
      };

      identity.address = lib.mkOption {
        type = lib.types.str;
        default = "127.127.127.127";
        description = ''
          The IP address the hostname specified in
          {option}`services.ncdns.identity.hostname` should resolve to.
          If you are only using ncdns locally you can ignore this.
        '';
      };

      dnssec.enable = lib.mkEnableOption ''
        DNSSEC support in ncdns. This will generate KSK and ZSK keypairs
        (unless provided via the options
        {option}`services.ncdns.dnssec.publicKey`,
        {option}`services.ncdns.dnssec.privateKey` etc.) and add a trust
        anchor to recursive resolvers
      '';

      dnssec.keys.public = lib.mkOption {
        type = lib.types.path;
        default = defaultFiles.public;
        description = ''
          Path to the file containing the KSK public key.
          The key can be generated using the `dnssec-keygen`
          command, provided by the package `bind` as follows:
          ```
          $ dnssec-keygen -a RSASHA256 -3 -b 2048 -f KSK bit
          ```
        '';
      };

      dnssec.keys.private = lib.mkOption {
        type = lib.types.path;
        default = defaultFiles.private;
        description = ''
          Path to the file containing the KSK private key.
        '';
      };

      dnssec.keys.zonePublic = lib.mkOption {
        type = lib.types.path;
        default = defaultFiles.zonePublic;
        description = ''
          Path to the file containing the ZSK public key.
          The key can be generated using the `dnssec-keygen`
          command, provided by the package `bind` as follows:
          ```
          $ dnssec-keygen -a RSASHA256 -3 -b 2048 bit
          ```
        '';
      };

      dnssec.keys.zonePrivate = lib.mkOption {
        type = lib.types.path;
        default = defaultFiles.zonePrivate;
        description = ''
          Path to the file containing the ZSK private key.
        '';
      };

      settings = lib.mkOption {
        type = configType;
        default = { };
        example = lib.literalExpression ''
          { # enable webserver
            ncdns.httplistenaddr = ":8202";

            # synchronize TLS certs
            certstore.nss = true;
            # note: all paths are relative to the config file
            certstore.nsscertdir =  "../../var/lib/ncdns";
            certstore.nssdbdir = "../../home/alice/.pki/nssdb";
          }
        '';
        description = ''
          ncdns settings. Use this option to configure ncds
          settings not exposed in a NixOS option or to bypass one.
          See the example ncdns.conf file at <https://github.com/namecoin/ncdns/blob/master/_doc/ncdns.conf.example>
          for the available options.
        '';
      };

    };

    services.pdns-recursor.resolveNamecoin = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Resolve `.bit` top-level domains using ncdns and namecoin.
      '';
    };

  };


  ###### implementation

  config = lib.mkIf cfg.enable {

    services.pdns-recursor = lib.mkIf cfgs.pdns-recursor.resolveNamecoin {
      forwardZonesRecurse.bit = "${cfg.address}:${toString cfg.port}";
      luaConfig =
        if cfg.dnssec.enable
          then ''readTrustAnchorsFromFile("${cfg.dnssec.keys.public}")''
          else ''addNTA("bit", "namecoin DNSSEC disabled")'';
    };

    # Avoid pdns-recursor not finding the DNSSEC keys
    systemd.services.pdns-recursor = lib.mkIf cfgs.pdns-recursor.resolveNamecoin {
      after = [ "ncdns.service" ];
      wants = [ "ncdns.service" ];
    };

    services.ncdns.settings = mkDefaultAttrs {
      ncdns =
        { # Namecoin RPC
          namecoinrpcaddress =
            "${cfgs.namecoind.rpc.address}:${toString cfgs.namecoind.rpc.port}";
          namecoinrpcusername = cfgs.namecoind.rpc.user;
          namecoinrpcpassword = cfgs.namecoind.rpc.password;

          # Identity
          selfname = cfg.identity.hostname;
          hostmaster = cfg.identity.hostmaster;
          selfip = cfg.identity.address;

          # Other
          bind = "${cfg.address}:${toString cfg.port}";
        }
        // lib.optionalAttrs cfg.dnssec.enable
        { # DNSSEC
          publickey  = "../.." + cfg.dnssec.keys.public;
          privatekey = "../.." + cfg.dnssec.keys.private;
          zonepublickey  = "../.." + cfg.dnssec.keys.zonePublic;
          zoneprivatekey = "../.." + cfg.dnssec.keys.zonePrivate;
        };

        # Daemon
        service.daemon = true;
        xlog.journal = true;
    };

    users.users.ncdns = {
      isSystemUser = true;
      group = "ncdns";
      description = "ncdns daemon user";
    };
    users.groups.ncdns = {};

    systemd.services.ncdns = {
      description = "ncdns daemon";
      after    = [ "namecoind.service" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        User = "ncdns";
        StateDirectory = "ncdns";
        Restart = "on-failure";
        ExecStart = "${pkgs.ncdns}/bin/ncdns -conf=${configFile}";
      };

      preStart = lib.optionalString (cfg.dnssec.enable && needsKeygen) ''
        cd ${dataDir}
        if [ ! -e bit.key ]; then
          ${pkgs.bind}/bin/dnssec-keygen -a RSASHA256 -3 -b 2048 bit
          mv Kbit.*.key bit-zone.key
          mv Kbit.*.private bit-zone.private
          ${pkgs.bind}/bin/dnssec-keygen -a RSASHA256 -3 -b 2048 -f KSK bit
          mv Kbit.*.key bit.key
          mv Kbit.*.private bit.private
        fi
      '';
    };

  };

  meta.maintainers = with lib.maintainers; [ rnhmjoj ];

}

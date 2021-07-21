{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.stunnel;

  # lines :: [String] -> String
  # Intersperse with newlines and concatenate
  lines = concatStringsSep "\n";

  # noNullOrEmpty :: AttrSet -> AttrSet
  # Remove all null or empty list attributes from an attribute set.
  noNullOrEmpty = filterAttrs (_: v: v != null && v != []);

  # mapKeys :: (String -> String) -> AttrSet -> AttrSet
  # Map over just the keys of an attribute set with a function.
  # If the function is not injective, the attrset might lose values.
  mapKeys = f: as: mapAttrs' (n: v: nameValuePair (f n) v);

  # renameKeys :: AttrSet -> AttrSet -> AttrSet
  # Given an AttrSet of Strings, rename all keys of the second attribute set with
  # the matching value of the first attribute set. If the attribute is not found,
  # it is kept
  renameKeys = r: as: mapKeys (k: as.${k} or k) as;

  # Rename the service keys from nixos-style naming to stunnel names.
  renameServiceCfg = n: v:
    let rename = renameKeys { verifyHostName = "checkHost"; certMode = "OCSPaia"; };
    in nameValuePair n (rename v);

  # mkEntry :: String -> a -> String
  # Make a single stunnel-style config entry by converting bools to "yes" or "no"
  # and everything else to string via toString.
  mkEntry = name: value:
    let
      val = if value == true then "yes"
            else if value == false then "no"
            else if (builtins.isList value) then (lines (map (mkEntry name) value))
            else toString value;
    in "${name} = ${val}";

  # Make an stunnel service config section fom a client or server.
  mkService = n: v: lines (["[${n}]"] ++ mapAttrsToList mkEntry (noNullOrEmpty v));

  # The full and final text of the stunnel config.
  configText = lines [ (lines (mapAttrsToList mkEntry (noNullOrEmpty cfg.globalConfig)))
                       "; ----- SERVER CONFIGURATIONS -----"
                       (lines (mapAttrsToList mkService cfg.servers))
                       "; ----- CLIENT CONFIGURATIONS -----"
                       (lines (mapAttrsToList mkService cfg.clients))
                     ];

  serverConfig = {
    freeformType = types.attrsOf (types.nullOr (types.oneOf
      [ types.str
        types.path
        types.bool
        types.int
        (types.listOf types.str)
      ]));

    options.client = mkOption {
      type = types.bool;
      default = false;
      readOnly = true;
      description = "Set this service to run in server mode";
    };

    options.accept = mkOption {
      type = types.oneOf [types.str types.int];
      description = ''
        Listen address '[host:]port' or unix domain socket, where the tunnel for the local service is exposed at.
        Note: If no host is specified, this will bind on all IP addresses.
      '';
      example = "localhost:1234";
    };

    options.connect = mkOption {
      type = types.oneOf [types.str types.int];
      description = ''
        Destination address '[host:]port' or unix domain socket a local service listens on.
        Note: If no host is specified, localhost is assumed.
      '';
      example = "localhost:1234";
    };

    options.options = mkOption {
      type = types.listOf types.str;
      default = if cfg.enableInsecureSSLv3 then ["-NO_SSLv3"] else [];
      description = "SSL options for stunnel";
    };
  };

  clientConfig = {
    freeformType = types.attrsOf (types.nullOr (types.oneOf
      [ types.str
        types.path
        types.bool
        types.int
        (types.listOf types.str)
      ]));

    options.client = mkOption {
      type = types.bool;
      default = true;
      readOnly = true;
      description = "Set this service to run in client mode";
    };

    options.accept = mkOption {
      type = types.oneOf [types.str types.int];
      description = ''
        Listen address '[host:]port' or unix domain socket, for a local client to connect to.
        Note: If no host is specified, this will bind on all IP addresses.
      '';
      example = "localhost:1234";
    };

    options.connect = mkOption {
      type = types.oneOf [types.str types.int];
      description = ''
        Listen address '[host:]port' or unix domain socket of the remote stunnel server.
        Note: If no host is specified, localhost is assumed.
      '';
      example = "localhost:1234";
    };

    options.options = mkOption {
      type = types.listOf types.str;
      default = if cfg.enableInsecureSSLv3 then ["-NO_SSLv3"] else [];
      description = "SSL options for stunnel";
    };
  };

  globalConfig = {
    freeformType = types.attrsOf (types.nullOr (types.oneOf
      [ types.str
        types.path
        types.bool
        types.int
        (types.listOf types.str)
      ]));
    options.setuid = mkOption { type = types.nullOr types.str; default = cfg.user; };
    options.setgid = mkOption { type = types.nullOr types.str; default = cfg.group; };
    options.debug = mkOption { type = types.nullOr types.str; default = cfg.logLevel; };
    options.fips = mkOption { type = types.nullOr types.bool; default = cfg.fipsMode; };
  };
in

{

  ###### interface

  options = {

    services.stunnel = {
      globalConfig = mkOption {
        type = types.submodule globalConfig;
        default = {};
        description = ''
          Contents of stunnel config file.
        '';
      };

      enable = mkOption {
        type = types.bool;
        default = false;
        description = "Whether to enable the stunnel TLS tunneling service.";
      };

      user = mkOption {
        type = with types; nullOr str;
        default = "nobody";
        description = "The user under which stunnel runs.";
      };

      group = mkOption {
        type = with types; nullOr str;
        default = "nogroup";
        description = "The group under which stunnel runs.";
      };

      logLevel = mkOption {
        type = types.enum [ "emerg" "alert" "crit" "err" "warning" "notice" "info" "debug" ];
        default = "notice";
        description = "Verbosity of stunnel output.";
      };

      fipsMode = mkOption {
        type = types.bool;
        default = false;
        description = "Enable FIPS 140-2 mode required for compliance.";
      };

      enableInsecureSSLv3 = mkOption {
        type = types.bool;
        default = false;
        description = "Enable support for the insecure SSLv3 protocol.";
      };

      servers = mkOption {
        description = "Define the server configuations.";
        type = with types; attrsOf (submodule serverConfig);
        example = {
          fancyWebserver = {
            accept = 443;
            connect = 8080;
            cert = "/path/to/pem/file";
          };
        };
        default = { };
      };

      clients = mkOption {
        description = "Define the client configurations.";
        type = with types; attrsOf (submodule clientConfig);
        example = {
          foobar = {
            accept = "0.0.0.0:8080";
            connect = "nixos.org:443";
            verifyChain = false;
          };
        };
        default = { };
      };
    };
  };


  ###### implementation

  config = mkIf cfg.enable {

    assertions = concatLists [
      (singleton {
        assertion = length (attrValues cfg.servers) != 0
                 || length (attrValues cfg.clients) != 0;
        message = "stunnel: At least one server- or client-configuration has to be present.";
      })
    ];

    environment.systemPackages = [ pkgs.stunnel ];

    environment.etc."stunnel.cfg".text = configText;

    systemd.services.stunnel = {
      description = "stunnel TLS tunneling service";
      after = [ "network.target" ];
      wants = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      restartTriggers = [ config.environment.etc."stunnel.cfg".source ];
      serviceConfig = {
        ExecStart = "${pkgs.stunnel}/bin/stunnel ${config.environment.etc."stunnel.cfg".source}";
        Type = "forking";
      };
    };

    meta.maintainers = with maintainers; [
      dminuoso
    ];
  };
}

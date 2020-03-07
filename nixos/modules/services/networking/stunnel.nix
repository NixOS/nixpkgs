{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.stunnel;
  yesNo = val: if val then "yes" else "no";

  verifyChainPathAssert = n: c: {
    assertion = c.verifyHostname == null || (c.verifyChain || c.verifyPeer);
    message =  "stunnel: \"${n}\" client configuration - hostname verification " +
      "is not possible without either verifyChain or verifyPeer enabled";
  };

  serverConfig = {
    options = {
      accept = mkOption {
        type = types.int;
        description = "On which port stunnel should listen for incoming TLS connections.";
      };

      connect = mkOption {
        type = types.int;
        description = "To which port the decrypted connection should be forwarded.";
      };

      cert = mkOption {
        type = types.path;
        description = "File containing both the private and public keys.";
      };
    };
  };

  clientConfig = {
    options = {
      accept = mkOption {
        type = types.str;
        description = "IP:Port on which connections should be accepted.";
      };

      connect = mkOption {
        type = types.str;
        description = "IP:Port destination to connect to.";
      };

      verifyChain = mkOption {
        type = types.bool;
        default = true;
        description = "Check if the provided certificate has a valid certificate chain (against CAPath).";
      };

      verifyPeer = mkOption {
        type = types.bool;
        default = false;
        description = "Check if the provided certificate is contained in CAPath.";
      };

      CAPath = mkOption {
        type = types.nullOr types.path;
        default = null;
        description = "Path to a directory containing certificates to validate against.";
      };

      CAFile = mkOption {
        type = types.nullOr types.path;
        default = "${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt";
        description = "Path to a file containing certificates to validate against.";
      };

      verifyHostname = mkOption {
        type = with types; nullOr str;
        default = null;
        description = "If set, stunnel checks if the provided certificate is valid for the given hostname.";
      };
    };
  };


in

{

  ###### interface

  options = {

    services.stunnel = {

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
        default = "info";
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
            enable = true;
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
        assertion = (length (attrValues cfg.servers) != 0) || ((length (attrValues cfg.clients)) != 0);
        message = "stunnel: At least one server- or client-configuration has to be present.";
      })

      (mapAttrsToList verifyChainPathAssert cfg.clients)
    ];

    environment.systemPackages = [ pkgs.stunnel ];

    environment.etc."stunnel.cfg".text = ''
      ${ if cfg.user != null then "setuid = ${cfg.user}" else "" }
      ${ if cfg.group != null then "setgid = ${cfg.group}" else "" }

      debug = ${cfg.logLevel}

      ${ optionalString cfg.fipsMode "fips = yes" }
      ${ optionalString cfg.enableInsecureSSLv3 "options = -NO_SSLv3" }

      ; ----- SERVER CONFIGURATIONS -----
      ${ lib.concatStringsSep "\n"
           (lib.mapAttrsToList
             (n: v: ''
               [${n}]
               accept = ${toString v.accept}
               connect = ${toString v.connect}
               cert = ${v.cert}

             '')
           cfg.servers)
      }

      ; ----- CLIENT CONFIGURATIONS -----
      ${ lib.concatStringsSep "\n"
           (lib.mapAttrsToList
             (n: v: ''
               [${n}]
               client = yes
               accept = ${v.accept}
               connect = ${v.connect}
               verifyChain = ${yesNo v.verifyChain}
               verifyPeer = ${yesNo v.verifyPeer}
               ${optionalString (v.CAPath != null) "CApath = ${v.CAPath}"}
               ${optionalString (v.CAFile != null) "CAFile = ${v.CAFile}"}
               ${optionalString (v.verifyHostname != null) "checkHost = ${v.verifyHostname}"}
               OCSPaia = yes

             '')
           cfg.clients)
      }
    '';

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
      # Server side
      lschuermann
      # Client side
      das_j
    ];
  };

}

{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.stunnel;
  yesNo = val: if val then "yes" else "no";

  verifyRequiredField = type: field: n: c: {
    assertion = hasAttr field c;
    message = "stunnel: \"${n}\" ${type} configuration - Field ${field} is required.";
  };

  verifyChainPathAssert = n: c: {
    assertion = (c.verifyHostname or null) == null || (c.verifyChain || c.verifyPeer);
    message = "stunnel: \"${n}\" client configuration - hostname verification " +
      "is not possible without either verifyChain or verifyPeer enabled";
  };

  removeNulls = filterAttrs (_: v: v != null);
  mkValueString = default: v:
    if v == true then "yes"
    else if v == false then "no"
    else default v;
  generateConfig = { sections, globalSection }:
    generators.toINIWithGlobalSection
      {
        mkKeyValue = generators.mkKeyValueDefault { mkValueString = mkValueString (generators.mkValueStringDefault { }); } " = ";
        listsAsDuplicateKeys = true;
      }
      {
        sections = mapAttrs (_: removeNulls) sections;
        globalSection = removeNulls globalSection;
      };

in

{

  ###### interface

  options = {

    services.stunnel = {

      enable = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc "Whether to enable the stunnel TLS tunneling service.";
      };

      user = mkOption {
        type = with types; nullOr str;
        default = "nobody";
        description = lib.mdDoc "The user under which stunnel runs.";
      };

      group = mkOption {
        type = with types; nullOr str;
        default = "nogroup";
        description = lib.mdDoc "The group under which stunnel runs.";
      };

      logLevel = mkOption {
        type = types.enum [ "emerg" "alert" "crit" "err" "warning" "notice" "info" "debug" ];
        default = "info";
        description = lib.mdDoc "Verbosity of stunnel output.";
      };

      fipsMode = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc "Enable FIPS 140-2 mode required for compliance.";
      };

      enableInsecureSSLv3 = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc "Enable support for the insecure SSLv3 protocol.";
      };


      servers = mkOption {
        description = lib.mdDoc ''
          Define the server configurations.

          See "SERVICE-LEVEL OPTIONS" in {manpage}`stunnel(8)`.

          Lists will expand to multiple options, to be used with options which can be specified multiple times (such as `checkHost` or `socket`).
        '';
        type = with types; let atoms = [ bool int str ]; in attrsOf (attrsOf (nullOr (oneOf (atoms ++ [ (listOf (oneOf atoms)) ]))));
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
        description = lib.mdDoc ''
          Define the client configurations.

          By default, verifyChain and OCSPaia are enabled and a CAFile is provided from pkgs.cacert.

          See "SERVICE-LEVEL OPTIONS" in {manpage}`stunnel(8)`.

          Lists will expand to multiple options, to be used with options which can be specified multiple times (such as `checkHost` or `socket`).
        '';
        type = with types; let atoms = [ bool int str ]; in attrsOf (attrsOf (nullOr (oneOf (atoms ++ [ (listOf (oneOf atoms)) ]))));

        apply =
          let
            applyDefaults = c:
              {
                CAFile = "${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt";
                OCSPaia = true;
                verifyChain = true;
              } // c;
            setCheckHostFromVerifyHostname = c:
              # To preserve backward-compatibility with the old NixOS stunnel module
              # definition, allow "verifyHostname" as an alias for "checkHost".
              c // {
                checkHost = c.checkHost or c.verifyHostname or null;
                verifyHostname = null; # Not a real stunnel configuration setting
              };
            forceClient = c: c // { client = true; };
          in
          mapAttrs (_: c: forceClient (setCheckHostFromVerifyHostname (applyDefaults c)));

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
      (mapAttrsToList (verifyRequiredField "client" "accept") cfg.clients)
      (mapAttrsToList (verifyRequiredField "client" "connect") cfg.clients)
      (mapAttrsToList (verifyRequiredField "server" "accept") cfg.servers)
      (mapAttrsToList (verifyRequiredField "server" "cert") cfg.servers)
      (mapAttrsToList (verifyRequiredField "server" "connect") cfg.servers)
    ];

    environment.systemPackages = [ pkgs.stunnel ];

    environment.etc."stunnel.cfg".text = generateConfig {
      globalSection = {
        setuid = cfg.user;
        setgid = cfg.group;
        debug = cfg.logLevel;
        fips = if cfg.fipsMode then true else null;
        options = if cfg.enableInsecureSSLv3 then "-NO_SSLv3" else null;
      };
      sections = lib.mergeAttrs cfg.servers cfg.clients;
    };


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

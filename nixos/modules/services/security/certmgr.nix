{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.certmgr;

  specs = mapAttrsToList (n: v: rec {
    name = n + ".json";
    path = if isAttrs v then pkgs.writeText name (builtins.toJSON v) else v;
  }) cfg.specs;

  allSpecs = pkgs.linkFarm "certmgr.d" specs;

  certmgrYaml = pkgs.writeText "certmgr.yaml" (builtins.toJSON {
    dir = allSpecs;
    default_remote = cfg.defaultRemote;
    svcmgr = cfg.svcManager;
    before = cfg.validMin;
    interval = cfg.renewInterval;
    inherit (cfg) metricsPort metricsAddress;
  });

  specPaths = map dirOf (concatMap (spec:
    if isAttrs spec then
      collect isString (filterAttrsRecursive (n: v: isAttrs v || n == "path") spec)
    else
      [ spec ]
  ) (attrValues cfg.specs));

  preStart = ''
    ${concatStringsSep " \\\n" (["mkdir -p"] ++ map escapeShellArg specPaths)}
    ${cfg.package}/bin/certmgr -f ${certmgrYaml} check
  '';
in
{
  options.services.certmgr = {
    enable = mkEnableOption "certmgr";

    package = mkOption {
      type = types.package;
      default = pkgs.certmgr;
      defaultText = "pkgs.certmgr";
      description = "Which certmgr package to use in the service.";
    };

    defaultRemote = mkOption {
      type = types.str;
      default = "127.0.0.1:8888";
      description = "The default CA host:port to use.";
    };

    validMin = mkOption {
      default = "72h";
      type = types.str;
      description = "The interval before a certificate expires to start attempting to renew it.";
    };

    renewInterval = mkOption {
      default = "30m";
      type = types.str;
      description = "How often to check certificate expirations and how often to update the cert_next_expires metric.";
    };

    metricsAddress = mkOption {
      default = "127.0.0.1";
      type = types.str;
      description = "The address for the Prometheus HTTP endpoint.";
    };

    metricsPort = mkOption {
      default = 9488;
      type = types.ints.u16;
      description = "The port for the Prometheus HTTP endpoint.";
    };

    specs = mkOption {
      default = {};
      example = literalExample ''
      {
        exampleCert =
        let
          domain = "example.com";
          secret = name: "/var/lib/secrets/''${name}.pem";
        in {
          service = "nginx";
          action = "reload";
          authority = {
            file.path = secret "ca";
          };
          certificate = {
            path = secret domain;
          };
          private_key = {
            owner = "root";
            group = "root";
            mode = "0600";
            path = secret "''${domain}-key";
          };
          request = {
            CN = domain;
            hosts = [ "mail.''${domain}" "www.''${domain}" ];
            key = {
              algo = "rsa";
              size = 2048;
            };
            names = {
              O = "Example Organization";
              C = "USA";
            };
          };
        };
        otherCert = "/var/certmgr/specs/other-cert.json";
      }
      '';
      type = with types; attrsOf (either (submodule {
        options = {
          service = mkOption {
            type = nullOr str;
            default = null;
            description = "The service on which to perform &lt;action&gt; after fetching.";
          };

          action = mkOption {
            type = addCheck str (x: cfg.svcManager == "command" || elem x ["restart" "reload" "nop"]);
            default = "nop";
            description = "The action to take after fetching.";
          };

          # These ought all to be specified according to certmgr spec def.
          authority = mkOption {
            type = attrs;
            description = "certmgr spec authority object.";
          };

          certificate = mkOption {
            type = nullOr attrs;
            description = "certmgr spec certificate object.";
          };

          private_key = mkOption {
            type = nullOr attrs;
            description = "certmgr spec private_key object.";
          };

          request = mkOption {
            type = nullOr attrs;
            description = "certmgr spec request object.";
          };
        };
    }) path);
      description = ''
        Certificate specs as described by:
        <link xlink:href="https://github.com/cloudflare/certmgr#certificate-specs" />
        These will be added to the Nix store, so they will be world readable.
      '';
    };

    svcManager = mkOption {
      default = "systemd";
      type = types.enum [ "circus" "command" "dummy" "openrc" "systemd" "sysv" ];
      description = ''
        This specifies the service manager to use for restarting or reloading services.
        See: <link xlink:href="https://github.com/cloudflare/certmgr#certmgryaml" />.
        For how to use the "command" service manager in particular,
        see: <link xlink:href="https://github.com/cloudflare/certmgr#command-svcmgr-and-how-to-use-it" />.
      '';
    };

  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.specs != {};
        message = "Certmgr specs cannot be empty.";
      }
      {
        assertion = !any (hasAttrByPath [ "authority" "auth_key" ]) (attrValues cfg.specs);
        message = ''
          Inline services.certmgr.specs are added to the Nix store rendering them world readable.
          Specify paths as specs, if you want to use include auth_key - or use the auth_key_file option."
        '';
      }
    ];

    systemd.services.certmgr = {
      description = "certmgr";
      path = mkIf (cfg.svcManager == "command") [ pkgs.bash ];
      after = [ "network-online.target" ];
      wantedBy = [ "multi-user.target" ];
      inherit preStart;

      serviceConfig = {
        Restart = "always";
        RestartSec = "10s";
        ExecStart = "${cfg.package}/bin/certmgr -f ${certmgrYaml}";
      };
    };
  };
}

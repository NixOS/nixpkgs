{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.certmgr;

  specs = lib.mapAttrsToList (n: v: rec {
    name = n + ".json";
    path = if lib.isAttrs v then pkgs.writeText name (builtins.toJSON v) else v;
  }) cfg.specs;

  allSpecs = pkgs.linkFarm "certmgr.d" specs;

  certmgrYaml = pkgs.writeText "certmgr.yaml" (
    builtins.toJSON {
      dir = allSpecs;
      default_remote = cfg.defaultRemote;
      svcmgr = cfg.svcManager;
      before = cfg.validMin;
      interval = cfg.renewInterval;
      inherit (cfg) metricsPort metricsAddress;
    }
  );

  specPaths = map dirOf (
    lib.concatMap (
      spec:
      if lib.isAttrs spec then
        lib.collect lib.isString (lib.filterAttrsRecursive (n: v: lib.isAttrs v || n == "path") spec)
      else
        [ spec ]
    ) (lib.attrValues cfg.specs)
  );

  preStart = ''
    ${lib.concatStringsSep " \\\n" ([ "mkdir -p" ] ++ map lib.escapeShellArg specPaths)}
    ${cfg.package}/bin/certmgr -f ${certmgrYaml} check
  '';
in
{
  options.services.certmgr = {
    enable = lib.mkEnableOption "certmgr";

    package = lib.mkPackageOption pkgs "certmgr" { };

    defaultRemote = lib.mkOption {
      type = lib.types.str;
      default = "127.0.0.1:8888";
      description = "The default CA host:port to use.";
    };

    validMin = lib.mkOption {
      default = "72h";
      type = lib.types.str;
      description = "The interval before a certificate expires to start attempting to renew it.";
    };

    renewInterval = lib.mkOption {
      default = "30m";
      type = lib.types.str;
      description = "How often to check certificate expirations and how often to update the cert_next_expires metric.";
    };

    metricsAddress = lib.mkOption {
      default = "127.0.0.1";
      type = lib.types.str;
      description = "The address for the Prometheus HTTP endpoint.";
    };

    metricsPort = lib.mkOption {
      default = 9488;
      type = lib.types.ints.u16;
      description = "The port for the Prometheus HTTP endpoint.";
    };

    specs = lib.mkOption {
      default = { };
      example = lib.literalExpression ''
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
      type =
        with lib.types;
        attrsOf (
          either path (submodule {
            options = {
              service = lib.mkOption {
                type = nullOr str;
                default = null;
                description = "The service on which to perform \\<action\\> after fetching.";
              };

              action = lib.mkOption {
                type = addCheck str (
                  x:
                  cfg.svcManager == "command"
                  || lib.elem x [
                    "restart"
                    "reload"
                    "nop"
                  ]
                );
                default = "nop";
                description = "The action to take after fetching.";
              };

              # These ought all to be specified according to certmgr spec def.
              authority = lib.mkOption {
                type = attrs;
                description = "certmgr spec authority object.";
              };

              certificate = lib.mkOption {
                type = nullOr attrs;
                description = "certmgr spec certificate object.";
              };

              private_key = lib.mkOption {
                type = nullOr attrs;
                description = "certmgr spec private_key object.";
              };

              request = lib.mkOption {
                type = nullOr attrs;
                description = "certmgr spec request object.";
              };
            };
          })
        );
      description = ''
        Certificate specs as described by:
        <https://github.com/cloudflare/certmgr#certificate-specs>
        These will be added to the Nix store, so they will be world readable.
      '';
    };

    svcManager = lib.mkOption {
      default = "systemd";
      type = lib.types.enum [
        "circus"
        "command"
        "dummy"
        "openrc"
        "systemd"
        "sysv"
      ];
      description = ''
        This specifies the service manager to use for restarting or reloading services.
        See: <https://github.com/cloudflare/certmgr#certmgryaml>.
        For how to use the "command" service manager in particular,
        see: <https://github.com/cloudflare/certmgr#command-svcmgr-and-how-to-use-it>.
      '';
    };

  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.specs != { };
        message = "Certmgr specs cannot be empty.";
      }
      {
        assertion =
          !lib.any (lib.hasAttrByPath [
            "authority"
            "auth_key"
          ]) (lib.attrValues cfg.specs);
        message = ''
          Inline services.certmgr.specs are added to the Nix store rendering them world readable.
          Specify paths as specs, if you want to use include auth_key - or use the auth_key_file option."
        '';
      }
    ];

    systemd.services.certmgr = {
      description = "certmgr";
      path = lib.mkIf (cfg.svcManager == "command") [ pkgs.bash ];
      wants = [ "network-online.target" ];
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

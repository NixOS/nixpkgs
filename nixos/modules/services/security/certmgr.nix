{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.certmgr;

  mkFileMeta = file: {
    inherit (file) path owner group mode;
  };

  mkSpec = spec: {
    inherit (spec) service action request;
    authority = {
      inherit (spec.authority) name remote label profile;
      root_ca = spec.authority.rootCA;
      auth_key = spec.authority.authKey;
      auth_key_file = spec.authority.authKeyFile;
      file = mkFileMeta spec.authority.file;
    };
    certificate = mkFileMeta spec.certificate;
    private_key = mkFileMeta spec.privateKey;
  };

  specs = mapAttrsToList (n: v: rec {
    name = "${if isAttrs v then v.name else n}.json";
    path = if isAttrs v then pkgs.writeText name (builtins.toJSON (mkSpec v)) else v;
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

  trustOnBootstrapAuthorities =
    unique (map (spec: { inherit (spec.authority) rootCA remote; })
      (filter
        (spec: isAttrs spec && spec.authority.trustOnBootstrap)
        (attrValues cfg.specs)));

  fileOptions = {
    options = {
      path = mkOption {
        type = types.path;
        description = "Generated certmgr file path.";
      };

      owner = mkOption {
        type = types.str;
        default = "root";
        description = "Generated certmgr file owner.";
      };

      group = mkOption {
        type = types.str;
        default = "root";
        description = "Generated certmgr file group.";
      };

      mode = mkOption {
        type = types.str;
        default = "0600";
        description = "Generated certmgr file mode.";
      };
    };
  };

  specOptions = { name, ... }: {
    options = {
      name = mkOption {
        type = types.str;
        default = name;
        description = "Certmgr spec name";
      };

      service = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = "The service on which to perform &lt;action&gt; after fetching.";
      };

      action = mkOption {
        type = with types; addCheck str (x: cfg.svcManager == "command" || elem x ["restart" "reload" "nop"]);
        default = "nop";
        description = "The action to take after fetching.";
      };

      # These ought all to be specified according to certmgr spec def.
      authority = mkOption {
        type = types.submodule {
          options = {
            name = mkOption {
              type = types.nullOr types.str;
              default = null;
              description = "Name of the global CA as defined in config file";
            };

            remote = mkOption {
              type = types.nullOr types.str;
              default = null;
              description = "CFSSL remote address";
            };

            label = mkOption {
              type = types.nullOr types.str;
              default = null;
              description = "CA label";
            };

            profile = mkOption {
              type = types.nullOr types.str;
              default = null;
              description = "Name of the cfssl profile to use";
            };

            authKey = mkOption {
              type = types.nullOr types.str;
              default = null;
              description = "Authentication key to use for cfssl authentication";
            };

            authKeyFile = mkOption {
              type = types.nullOr types.path;
              default = null;
              description = "Authentication key file path";
            };

            file = mkOption {
              type = types.nullOr (types.submodule fileOptions);
              default = null;
              description = "File where to output certificate authority.";
            };

            rootCA = mkOption {
              type = types.nullOr types.path;
              default = null;
              description = "Path to rootca used for verification of selfsigned certs.";
            };

            trustOnBootstrap = mkOption {
              type = types.bool;
              default = false;
              description = "Whether to trust CA on bootstrap";
            };
          };
        };
        default = {};
        description = "certmgr spec authority object.";
      };

      certificate = mkOption {
        type = types.nullOr (types.submodule fileOptions);
        default = null;
        description = "certmgr spec ceritificate file metadata.";
      };

      privateKey = mkOption {
        type = types.nullOr (types.submodule fileOptions);
        default = null;
        description = "certmgr spec private key file metadata.";
      };

      request = mkOption {
        type = types.nullOr types.attrs;
        default = null;
        description = "certmgr spec request object.";
      };
    };
  };

in {
  options.services.certmgr = {
    enable = mkEnableOption "certmgr";

    package = mkOption {
      type = types.package;
      default = pkgs.certmgr;
      defaultText = "pkgs.certmgr";
      description = "Which certmgr package to use in the service.";
    };

    defaultRemote = mkOption {
      type = types.nullOr types.str;
      default = "127.0.0.1:8888";
      description = "The default CA host:port to use.";
    };

    validMin = mkOption {
      default = "72h";
      type = types.str;
      description = "The interval before a certificate expires to start attempting to renew it.";
    };

    renewInterval = mkOption {
      default = "2m";
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
          secretsPath = "/var/lib/secrets";
        in {
          service = "nginx";
          action = "reload";
          authority = {
            remote = "ca.example.net:8888",
            authKeyFile = "''${secretsPath}/auth-key.secret";
            label = "www_ca";
            profile = "three-month";
            file.path = "''${secretsPath}/ca.pem";
            trustOnBootstrap = true;
          };
          certificate = {
            path = "''${secretsPath}/nginx.crt";
            owner = "nginx";
            group = "nginx";
          };
          privateKey = {
            path = "''${secretsPath}/nginx.key";
            owner = "nginx";
            group = "nginx";
            mode = "0600";
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
      type = with types; attrsOf (either (submodule specOptions) path);
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

    ensurePreStart = mkOption {
      default = true;
      type = types.bool;
      description = "Whether to ensure that certs are present before starting service.";
    };
  };

  config = mkIf cfg.enable {
    warnings = [
      (mkIf (any (spec: isAttrs spec && spec.authority.authKey != null) (attrValues cfg.specs)) ''
        Inline services.certmgr.specs are added to the Nix store rendering them world readable.
        Specify paths as specs, if you want to use include authKey - or use the authKeyFile option.
      '')
    ];

    services.cfssl.enable = mkDefault true;

    systemd.services.certmgr = {
      description = "certmgr";
      path = with pkgs; [ cfg.package curl cfssl ] ++
        (optional (cfg.svcManager == "command") pkgs.bash);
      after = [ "network-online.target" "cfssl.service" ];
      wantedBy = [ "multi-user.target" ];
      preStart = ''
        ${concatStringsSep " \\\n" (["mkdir -p"] ++ map escapeShellArg (unique specPaths))}

        ${optionalString (trustOnBootstrapAuthorities != []) (concatMapStrings (authority: ''
        if [ ! -f ${authority.rootCA} ]; then
          authority_json=$(mktemp --tmpdir certmgr-XXXX)
          until curl --fail-early -fskd '{}' ${authority.remote}/api/v1/cfssl/info -o $authority_json; do
            echo "error fetching root ca '${authority.rootCA}' from '${authority.remote}/api/v1/cfssl/info'"
            sleep 2
          done
          cfssljson -f $authority_json -stdout >${authority.rootCA}
          rm $authority_json
        fi
        '') trustOnBootstrapAuthorities)}

        ${if cfg.ensurePreStart then ''
        certmgr -f ${certmgrYaml} ensure --enableActions
        '' else ''
        certmgr -f ${certmgrYaml} check
        ''}
      '';

      serviceConfig = {
        Restart = "always";
        RestartSec = "10s";
        ExecStart = "${cfg.package}/bin/certmgr -f ${certmgrYaml}";
      };
    };
  };
}

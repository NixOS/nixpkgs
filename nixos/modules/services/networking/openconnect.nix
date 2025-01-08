{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.networking.openconnect;
  openconnect = cfg.package;
  pkcs11 = lib.types.strMatching "pkcs11:.+" // {
    name = "pkcs11";
    description = "PKCS#11 URI";
  };
  interfaceOptions = {
    options = {
      autoStart = lib.mkOption {
        default = true;
        description = "Whether this VPN connection should be started automatically.";
        type = lib.types.bool;
      };

      gateway = lib.mkOption {
        description = "Gateway server to connect to.";
        example = "gateway.example.com";
        type = lib.types.str;
      };

      protocol = lib.mkOption {
        description = "Protocol to use.";
        example = "anyconnect";
        type = lib.types.enum [
          "anyconnect"
          "array"
          "nc"
          "pulse"
          "gp"
          "f5"
          "fortinet"
        ];
      };

      user = lib.mkOption {
        description = "Username to authenticate with.";
        example = "example-user";
        type = lib.types.nullOr lib.types.str;
        default = null;
      };

      # Note: It does not make sense to provide a way to declaratively
      # set an authentication cookie, because they have to be requested
      # for every new connection and would only work once.
      passwordFile = lib.mkOption {
        description = ''
          File containing the password to authenticate with. This
          is passed to `openconnect` via the
          `--passwd-on-stdin` option.
        '';
        default = null;
        example = "/var/lib/secrets/openconnect-passwd";
        type = lib.types.nullOr lib.types.path;
      };

      certificate = lib.mkOption {
        description = "Certificate to authenticate with.";
        default = null;
        example = "/var/lib/secrets/openconnect_certificate.pem";
        type = with lib.types; nullOr (either path pkcs11);
      };

      privateKey = lib.mkOption {
        description = "Private key to authenticate with.";
        example = "/var/lib/secrets/openconnect_private_key.pem";
        default = null;
        type = with lib.types; nullOr (either path pkcs11);
      };

      extraOptions = lib.mkOption {
        description = ''
          Extra config to be appended to the interface config. It should
          contain long-format options as would be accepted on the command
          line by `openconnect`
          (see https://www.infradead.org/openconnect/manual.html).
          Non-key-value options like `deflate` can be used by
          declaring them as booleans, i. e. `deflate = true;`.
        '';
        default = { };
        example = {
          compression = "stateless";

          no-http-keepalive = true;
          no-dtls = true;
        };
        type = with lib.types; attrsOf (either str bool);
      };
    };
  };
  generateExtraConfig =
    extra_cfg:
    lib.strings.concatStringsSep "\n" (
      lib.attrsets.mapAttrsToList (name: value: if (value == true) then name else "${name}=${value}") (
        lib.attrsets.filterAttrs (_: value: value != false) extra_cfg
      )
    );
  generateConfig =
    name: icfg:
    pkgs.writeText "config" ''
      interface=${name}
      ${lib.optionalString (icfg.protocol != null) "protocol=${icfg.protocol}"}
      ${lib.optionalString (icfg.user != null) "user=${icfg.user}"}
      ${lib.optionalString (icfg.passwordFile != null) "passwd-on-stdin"}
      ${lib.optionalString (icfg.certificate != null) "certificate=${icfg.certificate}"}
      ${lib.optionalString (icfg.privateKey != null) "sslkey=${icfg.privateKey}"}

      ${generateExtraConfig icfg.extraOptions}
    '';
  generateUnit = name: icfg: {
    description = "OpenConnect Interface - ${name}";
    requires = [ "network-online.target" ];
    after = [
      "network.target"
      "network-online.target"
    ];
    wantedBy = lib.optional icfg.autoStart "multi-user.target";

    serviceConfig = {
      Type = "simple";
      ExecStart = "${openconnect}/bin/openconnect --config=${generateConfig name icfg} ${icfg.gateway}";
      StandardInput = lib.mkIf (icfg.passwordFile != null) "file:${icfg.passwordFile}";

      ProtectHome = true;
    };
  };
in
{
  options.networking.openconnect = {
    package = lib.mkPackageOption pkgs "openconnect" { };

    interfaces = lib.mkOption {
      description = "OpenConnect interfaces.";
      default = { };
      example = {
        openconnect0 = {
          gateway = "gateway.example.com";
          protocol = "anyconnect";
          user = "example-user";
          passwordFile = "/var/lib/secrets/openconnect-passwd";
        };
      };
      type = with lib.types; attrsOf (submodule interfaceOptions);
    };
  };

  config = {
    systemd.services = lib.mapAttrs' (name: value: {
      name = "openconnect-${name}";
      value = generateUnit name value;
    }) cfg.interfaces;
  };

  meta.maintainers = with lib.maintainers; [ alyaeanyx ];
}

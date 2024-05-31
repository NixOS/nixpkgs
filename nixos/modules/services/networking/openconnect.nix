{ config, lib, options, pkgs, ... }:
with lib;
let
  cfg = config.networking.openconnect;
  openconnect = cfg.package;
  pkcs11 = types.strMatching "pkcs11:.+" // {
    name = "pkcs11";
    description = "PKCS#11 URI";
  };
  interfaceOptions = {
    options = {
      autoStart = mkOption {
        default = true;
        description = "Whether this VPN connection should be started automatically.";
        type = types.bool;
      };

      gateway = mkOption {
        description = "Gateway server to connect to.";
        example = "gateway.example.com";
        type = types.str;
      };

      protocol = mkOption {
        description = "Protocol to use.";
        example = "anyconnect";
        type =
          types.enum [ "anyconnect" "array" "nc" "pulse" "gp" "f5" "fortinet" ];
      };

      user = mkOption {
        description = "Username to authenticate with.";
        example = "example-user";
        type = types.nullOr types.str;
        default = null;
      };

      # Note: It does not make sense to provide a way to declaratively
      # set an authentication cookie, because they have to be requested
      # for every new connection and would only work once.
      passwordFile = mkOption {
        description = ''
          File containing the password to authenticate with. This
          is passed to `openconnect` via the
          `--passwd-on-stdin` option.
        '';
        default = null;
        example = "/var/lib/secrets/openconnect-passwd";
        type = types.nullOr types.path;
      };

      certificate = mkOption {
        description = "Certificate to authenticate with.";
        default = null;
        example = "/var/lib/secrets/openconnect_certificate.pem";
        type = with types; nullOr (either path pkcs11);
      };

      privateKey = mkOption {
        description = "Private key to authenticate with.";
        example = "/var/lib/secrets/openconnect_private_key.pem";
        default = null;
        type = with types; nullOr (either path pkcs11);
      };

      extraOptions = mkOption {
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
        type = with types; attrsOf (either str bool);
      };
    };
  };
  generateExtraConfig = extra_cfg:
    strings.concatStringsSep "\n" (attrsets.mapAttrsToList
      (name: value: if (value == true) then name else "${name}=${value}")
      (attrsets.filterAttrs (_: value: value != false) extra_cfg));
  generateConfig = name: icfg:
    pkgs.writeText "config" ''
      interface=${name}
      ${optionalString (icfg.protocol != null) "protocol=${icfg.protocol}"}
      ${optionalString (icfg.user != null) "user=${icfg.user}"}
      ${optionalString (icfg.passwordFile != null) "passwd-on-stdin"}
      ${optionalString (icfg.certificate != null)
      "certificate=${icfg.certificate}"}
      ${optionalString (icfg.privateKey != null) "sslkey=${icfg.privateKey}"}

      ${generateExtraConfig icfg.extraOptions}
    '';
  generateUnit = name: icfg: {
    description = "OpenConnect Interface - ${name}";
    requires = [ "network-online.target" ];
    after = [ "network.target" "network-online.target" ];
    wantedBy = optional icfg.autoStart "multi-user.target";

    serviceConfig = {
      Type = "simple";
      ExecStart = "${openconnect}/bin/openconnect --config=${
          generateConfig name icfg
        } ${icfg.gateway}";
      StandardInput = lib.mkIf (icfg.passwordFile != null) "file:${icfg.passwordFile}";

      ProtectHome = true;
    };
  };
in {
  options.networking.openconnect = {
    package = mkPackageOption pkgs "openconnect" { };

    interfaces = mkOption {
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
      type = with types; attrsOf (submodule interfaceOptions);
    };
  };

  config = {
    systemd.services = mapAttrs' (name: value: {
      name = "openconnect-${name}";
      value = generateUnit name value;
    }) cfg.interfaces;
  };

  meta.maintainers = with maintainers; [ alyaeanyx ];
}

{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    attrValues
    concatMap
    concatStringsSep
    escapeShellArg
    literalExpression
    mapAttrs'
    mkDefault
    mkEnableOption
    mkPackageOption
    mkIf
    lib.mkOption
    nameValuePair
    lib.optional
    types
    ;

  mainCfg = config.services.ghostunnel;

  module =
    { config, name, ... }:
    {
      options = {

        listen = lib.mkOption {
          description = ''
            Address and port to listen on (can be HOST:PORT, unix:PATH).
          '';
          type = lib.types.str;
        };

        target = lib.mkOption {
          description = ''
            Address to forward connections to (can be HOST:PORT or unix:PATH).
          '';
          type = lib.types.str;
        };

        keystore = lib.mkOption {
          description = ''
            Path to keystore (combined PEM with cert/key, or PKCS12 keystore).

            NB: storepass is not supported because it would expose credentials via `/proc/*/cmdline`.

            Specify this or `cert` and `key`.
          '';
          type = lib.types.nullOr lib.types.str;
          default = null;
        };

        cert = lib.mkOption {
          description = ''
            Path to certificate (PEM with certificate chain).

            Not required if `keystore` is set.
          '';
          type = lib.types.nullOr lib.types.str;
          default = null;
        };

        key = lib.mkOption {
          description = ''
            Path to certificate private key (PEM with private key).

            Not required if `keystore` is set.
          '';
          type = lib.types.nullOr lib.types.str;
          default = null;
        };

        cacert = lib.mkOption {
          description = ''
            Path to CA bundle file (PEM/X509). Uses system trust store if `null`.
          '';
          type = lib.types.nullOr lib.types.str;
        };

        disableAuthentication = lib.mkOption {
          description = ''
            Disable client authentication, no client certificate will be required.
          '';
          type = lib.types.bool;
          default = false;
        };

        allowAll = lib.mkOption {
          description = ''
            If true, allow all clients, do not check client cert subject.
          '';
          type = lib.types.bool;
          default = false;
        };

        allowCN = lib.mkOption {
          description = ''
            Allow client if common name appears in the list.
          '';
          type = lib.types.listOf lib.types.str;
          default = [ ];
        };

        allowOU = lib.mkOption {
          description = ''
            Allow client if organizational unit name appears in the list.
          '';
          type = lib.types.listOf lib.types.str;
          default = [ ];
        };

        allowDNS = lib.mkOption {
          description = ''
            Allow client if DNS subject alternative name appears in the list.
          '';
          type = lib.types.listOf lib.types.str;
          default = [ ];
        };

        allowURI = lib.mkOption {
          description = ''
            Allow client if URI subject alternative name appears in the list.
          '';
          type = lib.types.listOf lib.types.str;
          default = [ ];
        };

        extraArguments = lib.mkOption {
          description = "Extra arguments to pass to `ghostunnel server`";
          type = lib.types.separatedString " ";
          default = "";
        };

        unsafeTarget = lib.mkOption {
          description = ''
            If set, does not limit target to localhost, 127.0.0.1, [::1], or UNIX sockets.

            This is meant to protect against accidental unencrypted traffic on
            untrusted networks.
          '';
          type = lib.types.bool;
          default = false;
        };

        # Definitions to apply at the root of the NixOS configuration.
        atRoot = lib.mkOption {
          internal = true;
        };
      };

      # Clients should not be authenticated with the public root certificates
      # (afaict, it doesn't make sense), so we only provide that default when
      # client cert auth is disabled.
      config.cacert = lib.mkIf config.disableAuthentication (mkDefault null);

      config.atRoot = {
        assertions = [
          {
            message = ''
              services.ghostunnel.servers.${name}: At least one access control flag is required.
              Set at least one of:
                - services.ghostunnel.servers.${name}.disableAuthentication
                - services.ghostunnel.servers.${name}.allowAll
                - services.ghostunnel.servers.${name}.allowCN
                - services.ghostunnel.servers.${name}.allowOU
                - services.ghostunnel.servers.${name}.allowDNS
                - services.ghostunnel.servers.${name}.allowURI
            '';
            assertion =
              config.disableAuthentication
              || config.allowAll
              || config.allowCN != [ ]
              || config.allowOU != [ ]
              || config.allowDNS != [ ]
              || config.allowURI != [ ];
          }
        ];

        systemd.services."ghostunnel-server-${name}" = {
          after = [ "network.target" ];
          wants = [ "network.target" ];
          wantedBy = [ "multi-user.target" ];
          serviceConfig = {
            Restart = "always";
            AmbientCapabilities = [ "CAP_NET_BIND_SERVICE" ];
            DynamicUser = true;
            LoadCredential =
              lib.optional (config.keystore != null) "keystore:${config.keystore}"
              ++ lib.optional (config.cert != null) "cert:${config.cert}"
              ++ lib.optional (config.key != null) "key:${config.key}"
              ++ lib.optional (config.cacert != null) "cacert:${config.cacert}";
          };
          script = concatStringsSep " " (
            [ "${mainCfg.package}/bin/ghostunnel" ]
            ++ lib.optional (config.keystore != null) "--keystore=$CREDENTIALS_DIRECTORY/keystore"
            ++ lib.optional (config.cert != null) "--cert=$CREDENTIALS_DIRECTORY/cert"
            ++ lib.optional (config.key != null) "--key=$CREDENTIALS_DIRECTORY/key"
            ++ lib.optional (config.cacert != null) "--cacert=$CREDENTIALS_DIRECTORY/cacert"
            ++ [
              "server"
              "--listen ${config.listen}"
              "--target ${config.target}"
            ]
            ++ lib.optional config.allowAll "--allow-all"
            ++ map (v: "--allow-cn=${lib.escapeShellArg v}") config.allowCN
            ++ map (v: "--allow-ou=${lib.escapeShellArg v}") config.allowOU
            ++ map (v: "--allow-dns=${lib.escapeShellArg v}") config.allowDNS
            ++ map (v: "--allow-uri=${lib.escapeShellArg v}") config.allowURI
            ++ lib.optional config.disableAuthentication "--disable-authentication"
            ++ lib.optional config.unsafeTarget "--unsafe-target"
            ++ [ config.extraArguments ]
          );
        };
      };
    };

in
{

  options = {
    services.ghostunnel.enable = lib.mkEnableOption "ghostunnel";

    services.ghostunnel.package = lib.mkPackageOption pkgs "ghostunnel" { };

    services.ghostunnel.servers = lib.mkOption {
      description = ''
        Server mode ghostunnels (TLS listener -> plain TCP/UNIX target)
      '';
      type = lib.types.attrsOf (types.submodule module);
      default = { };
    };
  };

  config = lib.mkIf mainCfg.enable {
    assertions = lib.mkMerge (map (v: v.atRoot.assertions) (lib.attrValues mainCfg.servers));
    systemd = lib.mkMerge (map (v: v.atRoot.systemd) (lib.attrValues mainCfg.servers));
  };

  meta.maintainers = with lib.maintainers; [
    roberth
  ];
}

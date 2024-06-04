{ config, lib, pkgs, ... }:
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
    mkOption
    nameValuePair
    optional
    types
    ;

  mainCfg = config.services.ghostunnel;

  module = { config, name, ... }:
    {
      options = {

        listen = mkOption {
          description = ''
            Address and port to listen on (can be HOST:PORT, unix:PATH).
          '';
          type = types.str;
        };

        target = mkOption {
          description = ''
            Address to forward connections to (can be HOST:PORT or unix:PATH).
          '';
          type = types.str;
        };

        keystore = mkOption {
          description = ''
            Path to keystore (combined PEM with cert/key, or PKCS12 keystore).

            NB: storepass is not supported because it would expose credentials via `/proc/*/cmdline`.

            Specify this or `cert` and `key`.
          '';
          type = types.nullOr types.str;
          default = null;
        };

        cert = mkOption {
          description = ''
            Path to certificate (PEM with certificate chain).

            Not required if `keystore` is set.
          '';
          type = types.nullOr types.str;
          default = null;
        };

        key = mkOption {
          description = ''
            Path to certificate private key (PEM with private key).

            Not required if `keystore` is set.
          '';
          type = types.nullOr types.str;
          default = null;
        };

        cacert = mkOption {
          description = ''
            Path to CA bundle file (PEM/X509). Uses system trust store if `null`.
          '';
          type = types.nullOr types.str;
        };

        disableAuthentication = mkOption {
          description = ''
            Disable client authentication, no client certificate will be required.
          '';
          type = types.bool;
          default = false;
        };

        allowAll = mkOption {
          description = ''
            If true, allow all clients, do not check client cert subject.
          '';
          type = types.bool;
          default = false;
        };

        allowCN = mkOption {
          description = ''
            Allow client if common name appears in the list.
          '';
          type = types.listOf types.str;
          default = [];
        };

        allowOU = mkOption {
          description = ''
            Allow client if organizational unit name appears in the list.
          '';
          type = types.listOf types.str;
          default = [];
        };

        allowDNS = mkOption {
          description = ''
            Allow client if DNS subject alternative name appears in the list.
          '';
          type = types.listOf types.str;
          default = [];
        };

        allowURI = mkOption {
          description = ''
            Allow client if URI subject alternative name appears in the list.
          '';
          type = types.listOf types.str;
          default = [];
        };

        extraArguments = mkOption {
          description = "Extra arguments to pass to `ghostunnel server`";
          type = types.separatedString " ";
          default = "";
        };

        unsafeTarget = mkOption {
          description = ''
            If set, does not limit target to localhost, 127.0.0.1, [::1], or UNIX sockets.

            This is meant to protect against accidental unencrypted traffic on
            untrusted networks.
          '';
          type = types.bool;
          default = false;
        };

        # Definitions to apply at the root of the NixOS configuration.
        atRoot = mkOption {
          internal = true;
        };
      };

      # Clients should not be authenticated with the public root certificates
      # (afaict, it doesn't make sense), so we only provide that default when
      # client cert auth is disabled.
      config.cacert = mkIf config.disableAuthentication (mkDefault null);

      config.atRoot = {
        assertions = [
          { message = ''
              services.ghostunnel.servers.${name}: At least one access control flag is required.
              Set at least one of:
                - services.ghostunnel.servers.${name}.disableAuthentication
                - services.ghostunnel.servers.${name}.allowAll
                - services.ghostunnel.servers.${name}.allowCN
                - services.ghostunnel.servers.${name}.allowOU
                - services.ghostunnel.servers.${name}.allowDNS
                - services.ghostunnel.servers.${name}.allowURI
            '';
            assertion = config.disableAuthentication
              || config.allowAll
              || config.allowCN != []
              || config.allowOU != []
              || config.allowDNS != []
              || config.allowURI != []
              ;
          }
        ];

        systemd.services."ghostunnel-server-${name}" = {
          after = [ "network.target" ];
          wants = [ "network.target" ];
          wantedBy = [ "multi-user.target" ];
          serviceConfig = {
            Restart = "always";
            AmbientCapabilities = ["CAP_NET_BIND_SERVICE"];
            DynamicUser = true;
            LoadCredential = optional (config.keystore != null) "keystore:${config.keystore}"
              ++ optional (config.cert != null) "cert:${config.cert}"
              ++ optional (config.key != null) "key:${config.key}"
              ++ optional (config.cacert != null) "cacert:${config.cacert}";
           };
          script = concatStringsSep " " (
            [ "${mainCfg.package}/bin/ghostunnel" ]
            ++ optional (config.keystore != null) "--keystore=$CREDENTIALS_DIRECTORY/keystore"
            ++ optional (config.cert != null) "--cert=$CREDENTIALS_DIRECTORY/cert"
            ++ optional (config.key != null) "--key=$CREDENTIALS_DIRECTORY/key"
            ++ optional (config.cacert != null) "--cacert=$CREDENTIALS_DIRECTORY/cacert"
            ++ [
              "server"
              "--listen ${config.listen}"
              "--target ${config.target}"
            ] ++ optional config.allowAll "--allow-all"
              ++ map (v: "--allow-cn=${escapeShellArg v}") config.allowCN
              ++ map (v: "--allow-ou=${escapeShellArg v}") config.allowOU
              ++ map (v: "--allow-dns=${escapeShellArg v}") config.allowDNS
              ++ map (v: "--allow-uri=${escapeShellArg v}") config.allowURI
              ++ optional config.disableAuthentication "--disable-authentication"
              ++ optional config.unsafeTarget "--unsafe-target"
              ++ [ config.extraArguments ]
          );
        };
      };
    };

in
{

  options = {
    services.ghostunnel.enable = mkEnableOption "ghostunnel";

    services.ghostunnel.package = mkPackageOption pkgs "ghostunnel" { };

    services.ghostunnel.servers = mkOption {
      description = ''
        Server mode ghostunnels (TLS listener -> plain TCP/UNIX target)
      '';
      type = types.attrsOf (types.submodule module);
      default = {};
    };
  };

  config = mkIf mainCfg.enable {
    assertions = lib.mkMerge (map (v: v.atRoot.assertions) (attrValues mainCfg.servers));
    systemd = lib.mkMerge (map (v: v.atRoot.systemd) (attrValues mainCfg.servers));
  };

  meta.maintainers = with lib.maintainers; [
    roberth
  ];
}

# Non-module dependencies (`importApply`)
{ }:

# Service module
{
  lib,
  config,
  options,
  ...
}:
let
  inherit (lib)
    concatStringsSep
    getExe
    mkDefault
    mkIf
    mkOption
    optional
    types
    ;
  cfg = config.ghostunnel;

  landlockArguments = rec {
    # Many paths in /etc are symlinks into the store.
    best-effort = [ "--landlock-allow-read=${builtins.storeDir}" ];
    required = best-effort ++ [ "--require-landlock" ];
    disabled = [ "--disable-landlock" ];
  };

in
{
  # https://nixos.org/manual/nixos/unstable/#modular-services
  _class = "service";
  options = {
    ghostunnel = {
      package = mkOption {
        description = "Package to use for ghostunnel";
        defaultText = "The ghostunnel package that provided this module.";
        type = types.package;
      };

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
        default = [ ];
      };

      allowOU = mkOption {
        description = ''
          Allow client if organizational unit name appears in the list.
        '';
        type = types.listOf types.str;
        default = [ ];
      };

      allowDNS = mkOption {
        description = ''
          Allow client if DNS subject alternative name appears in the list.
        '';
        type = types.listOf types.str;
        default = [ ];
      };

      allowURI = mkOption {
        description = ''
          Allow client if URI subject alternative name appears in the list.
        '';
        type = types.listOf types.str;
        default = [ ];
      };

      extraArguments = mkOption {
        description = "Extra arguments to pass to `ghostunnel server`";
        type = types.listOf types.str;
        default = [ ];
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

      landlock = mkOption {
        description = ''
          Whether ghostunnel runs in its landlock sandbox, which limits the
          files and network ports that the process can use.

          - `"required"`: ghostunnel exits if it cannot set up the sandbox.
          - `"best-effort"`: if ghostunnel cannot set up the sandbox, it logs
            a warning and runs without it. Ghostunnel does this by default.
          - `"disabled"`: ghostunnel runs without the sandbox.

          On a kernel with an older landlock version, the sandbox lacks some
          restrictions. Ghostunnel then logs a warning and runs, also with
          `"required"`. With PKCS#11, ghostunnel runs without the sandbox, so
          `"required"` does not work with it.

          The sandbox can read the Nix store, because many paths in `/etc`
          are symlinks into it. To allow another directory, add
          `--landlock-allow-read=DIR` to {option}`${options.ghostunnel.extraArguments}`.
        '';
        type = types.enum [
          "required"
          "best-effort"
          "disabled"
        ];
        default = "required";
      };
    };
  };

  config = {
    assertions = [
      {
        message = ''
          At least one access control flag is required.
          Set at least one of:
            - ${options.ghostunnel.disableAuthentication}
            - ${options.ghostunnel.allowAll}
            - ${options.ghostunnel.allowCN}
            - ${options.ghostunnel.allowOU}
            - ${options.ghostunnel.allowDNS}
            - ${options.ghostunnel.allowURI}
        '';
        assertion =
          cfg.disableAuthentication
          || cfg.allowAll
          || cfg.allowCN != [ ]
          || cfg.allowOU != [ ]
          || cfg.allowDNS != [ ]
          || cfg.allowURI != [ ];
      }
    ];

    ghostunnel = {
      # Clients should not be authenticated with the public root certificates
      # (afaict, it doesn't make sense), so we only provide that default when
      # client cert auth is disabled.
      cacert = mkIf cfg.disableAuthentication (mkDefault null);
    };

    # TODO assertions

    process = {
      argv = [
        (getExe cfg.package)
      ]
      ++ landlockArguments.${cfg.landlock}
      ++ [
        "server"
        "--listen"
        cfg.listen
        "--target"
        cfg.target
      ]
      ++ optional cfg.allowAll "--allow-all"
      ++ map (v: "--allow-cn=${v}") cfg.allowCN
      ++ map (v: "--allow-ou=${v}") cfg.allowOU
      ++ map (v: "--allow-dns=${v}") cfg.allowDNS
      ++ map (v: "--allow-uri=${v}") cfg.allowURI
      ++ optional cfg.disableAuthentication "--disable-authentication"
      ++ optional cfg.unsafeTarget "--unsafe-target"
      ++ cfg.extraArguments;
    };
  }
  # Refine the service for systemd
  // lib.optionalAttrs (options ? systemd) (
    let
      # Build credential flags with systemd variable substitution
      credentialFlags = concatStringsSep " " (
        optional (cfg.keystore != null) "--keystore=\${CREDENTIALS_DIRECTORY}/keystore"
        ++ optional (cfg.cert != null) "--cert=\${CREDENTIALS_DIRECTORY}/cert"
        ++ optional (cfg.key != null) "--key=\${CREDENTIALS_DIRECTORY}/key"
        ++ optional (cfg.cacert != null) "--cacert=\${CREDENTIALS_DIRECTORY}/cacert"
      );
    in
    {
      # Use mainExecStart to add credential flags with systemd variable substitution
      systemd.mainExecStart =
        config.systemd.lib.escapeSystemdExecArgs config.process.argv
        + lib.optionalString (credentialFlags != "") " ${credentialFlags}";

      systemd.service = {
        after = [ "network.target" ];
        wants = [ "network.target" ];
        wantedBy = [ "multi-user.target" ];
        serviceConfig = {
          Restart = "always";
          AmbientCapabilities = [ "CAP_NET_BIND_SERVICE" ];
          DynamicUser = true;
          LoadCredential =
            optional (cfg.keystore != null) "keystore:${cfg.keystore}"
            ++ optional (cfg.cert != null) "cert:${cfg.cert}"
            ++ optional (cfg.key != null) "key:${cfg.key}"
            ++ optional (cfg.cacert != null) "cacert:${cfg.cacert}";
        };
      };
    }
  );
}

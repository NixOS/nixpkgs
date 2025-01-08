{
  config,
  lib,
  pkgs,
  ...
}:

let

  cfg = config.services.ttyd;

  inherit (lib)
    lib.optionals
    types
    lib.mkOption
    ;

  # Command line arguments for the ttyd daemon
  args =
    [
      "--port"
      (toString cfg.port)
    ]
    ++ lib.optionals (cfg.socket != null) [
      "--interface"
      cfg.socket
    ]
    ++ lib.optionals (cfg.interface != null) [
      "--interface"
      cfg.interface
    ]
    ++ [
      "--signal"
      (toString cfg.signal)
    ]
    ++ (lib.concatLists (
      lib.mapAttrsToList (_k: _v: [
        "--client-option"
        "${_k}=${_v}"
      ]) cfg.clientOptions
    ))
    ++ [
      "--terminal-type"
      cfg.terminalType
    ]
    ++ lib.optionals cfg.checkOrigin [ "--check-origin" ]
    ++ lib.optionals cfg.writeable [ "--writable" ] # the typo is correct
    ++ [
      "--max-clients"
      (toString cfg.maxClients)
    ]
    ++ lib.optionals (cfg.indexFile != null) [
      "--index"
      cfg.indexFile
    ]
    ++ lib.optionals cfg.enableIPv6 [ "--ipv6" ]
    ++ lib.optionals cfg.enableSSL [
      "--ssl"
      "--ssl-cert"
      cfg.certFile
      "--ssl-key"
      cfg.keyFile
    ]
    ++ lib.optionals (cfg.enableSSL && cfg.caFile != null) [
      "--ssl-ca"
      cfg.caFile
    ]
    ++ [
      "--debug"
      (toString cfg.logLevel)
    ];

in

{

  ###### interface

  options = {
    services.ttyd = {
      enable = lib.mkEnableOption ("ttyd daemon");

      port = lib.mkOption {
        type = lib.types.port;
        default = 7681;
        description = "Port to listen on (use 0 for random port)";
      };

      socket = lib.mkOption {
        type = lib.types.nullOr lib.types.path;
        default = null;
        example = "/var/run/ttyd.sock";
        description = "UNIX domain socket path to bind.";
      };

      interface = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        example = "eth0";
        description = "Network interface to bind.";
      };

      username = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = "Username for basic http authentication.";
      };

      passwordFile = lib.mkOption {
        type = lib.types.nullOr lib.types.path;
        default = null;
        apply = value: if value == null then null else toString value;
        description = ''
          File containing the password to use for basic http authentication.
          For insecurely putting the password in the globally readable store use
          `pkgs.writeText "ttydpw" "MyPassword"`.
        '';
      };

      signal = lib.mkOption {
        type = lib.types.ints.u8;
        default = 1;
        description = "Signal to send to the command on session close.";
      };

      entrypoint = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ "${pkgs.shadow}/bin/login" ];
        defaultText = lib.literalExpression ''
          [ "''${pkgs.shadow}/bin/login" ]
        '';
        example = lib.literalExpression ''
          [ (lib.getExe pkgs.htop) ]
        '';
        description = "Which command ttyd runs.";
        apply = lib.escapeShellArgs;
      };

      user = lib.mkOption {
        type = lib.types.str;
        # `login` needs to be run as root
        default = "root";
        description = "Which unix user ttyd should run as.";
      };

      writeable = lib.mkOption {
        type = lib.types.nullOr lib.types.bool;
        default = null; # null causes an eval error, forcing the user to consider attack surface
        example = true;
        description = "Allow clients to write to the TTY.";
      };

      clientOptions = lib.mkOption {
        type = lib.types.attrsOf lib.types.str;
        default = { };
        example = lib.literalExpression ''
          {
            fontSize = "16";
            fontFamily = "Fira Code";
          }
        '';
        description = ''
          Attribute set of client options for xtermjs.
          <https://xtermjs.org/docs/api/terminal/interfaces/iterminaloptions/>
        '';
      };

      terminalType = lib.mkOption {
        type = lib.types.str;
        default = "xterm-256color";
        description = "Terminal type to report.";
      };

      checkOrigin = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Whether to allow a websocket connection from a different origin.";
      };

      maxClients = lib.mkOption {
        type = lib.types.int;
        default = 0;
        description = "Maximum clients to support (0, no limit)";
      };

      indexFile = lib.mkOption {
        type = lib.types.nullOr lib.types.path;
        default = null;
        description = "Custom index.html path";
      };

      enableIPv6 = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Whether or not to enable IPv6 support.";
      };

      enableSSL = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Whether or not to enable SSL (https) support.";
      };

      certFile = lib.mkOption {
        type = lib.types.nullOr lib.types.path;
        default = null;
        description = "SSL certificate file path.";
      };

      keyFile = lib.mkOption {
        type = lib.types.nullOr lib.types.path;
        default = null;
        apply = value: if value == null then null else toString value;
        description = ''
          SSL key file path.
          For insecurely putting the keyFile in the globally readable store use
          `pkgs.writeText "ttydKeyFile" "SSLKEY"`.
        '';
      };

      caFile = lib.mkOption {
        type = lib.types.nullOr lib.types.path;
        default = null;
        description = "SSL CA file path for client certificate verification.";
      };

      logLevel = lib.mkOption {
        type = lib.types.int;
        default = 7;
        description = "Set log level.";
      };
    };
  };

  ###### implementation

  config = lib.mkIf cfg.enable {

    assertions = [
      {
        assertion = cfg.enableSSL -> cfg.certFile != null && cfg.keyFile != null;
        message = "SSL is enabled for ttyd, but no certFile or keyFile has been specified.";
      }
      {
        assertion = cfg.writeable != null;
        message = "services.ttyd.writeable must be set";
      }
      {
        assertion = !(cfg.interface != null && cfg.socket != null);
        message = "Cannot set both interface and socket for ttyd.";
      }
      {
        assertion = (cfg.username != null) == (cfg.passwordFile != null);
        message = "Need to set both username and passwordFile for ttyd";
      }
    ];

    systemd.services.ttyd = {
      description = "ttyd Web Server Daemon";

      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        User = cfg.user;
        LoadCredential = lib.optionalString (
          cfg.passwordFile != null
        ) "TTYD_PASSWORD_FILE:${cfg.passwordFile}";
      };

      script =
        if cfg.passwordFile != null then
          ''
            PASSWORD=$(cat "$CREDENTIALS_DIRECTORY/TTYD_PASSWORD_FILE")
            ${pkgs.ttyd}/bin/ttyd ${lib.escapeShellArgs args} \
              --credential ${lib.escapeShellArg cfg.username}:"$PASSWORD" \
              ${cfg.entrypoint}
          ''
        else
          ''
            ${pkgs.ttyd}/bin/ttyd ${lib.escapeShellArgs args} \
              ${cfg.entrypoint}
          '';
    };
  };
}

{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib)
    types
    mkOption
    hasPrefix
    concatMapStringsSep
    optionalString
    concatMap
    ;

  cfg = config.services.vinyl-cache;

  # Vinyl Cache has very strong opinions and very complicated code around handling
  # the stateDir. After a lot of back and forth, we decided that we a)
  # do not want a configurable option here, as most of the handling depends
  # on the version and the compile time options. Putting everything into
  # /var/run (RAM backed) is absolutely recommended by Vinyl Cache anyways.
  # We do need to pay attention to the version-dependend variations, though!
  stateDir = "/var/run/vinyld";

  # from --help:
  #   -a [<name>=]address[:port][,proto] # HTTP listen address and port
  #      [,user=<u>][,group=<g>]   # Can be specified multiple times.
  #      [,mode=<m>]               #   default: ":80,HTTP"
  #                                # Proto can be "PROXY" or "HTTP" (default)
  #                                # user, group and mode set permissions for
  #                                #   a Unix domain socket.
  commandLineAddresses = (
    concatMapStringsSep " " (
      a:
      "-a "
      + optionalString (!isNull a.name) "${a.name}="
      + a.address
      + optionalString (!isNull a.port) ":${toString a.port}"
      + optionalString (!isNull a.proto) ",${a.proto}"
      + optionalString (!isNull a.user) ",user=${a.user}"
      + optionalString (!isNull a.group) ",group=${a.group}"
      + optionalString (!isNull a.mode) ",mode=${a.mode}"
    ) cfg.listen
  );

  addressSubmodule = types.submodule {
    options = {
      name = mkOption {
        description = "Name is referenced in logs. If name is not specified, 'a0', 'a1', etc. is used.";
        default = null;
        type = with types; nullOr str;
      };
      address = mkOption {
        description = ''
          If given an IP address, it can be a host name ("localhost"), an IPv4 dotted-quad
          ("127.0.0.1") or an IPv6  address enclosed in square brackets ("[::1]").

          (VCL4.1 and higher) If given an absolute Path ("/path/to/listen.sock") or "@"
          followed by the name of an abstract socket ("@myvinyld") accept connections
          on a Unix domain socket.

          The user, group and mode sub-arguments may be used to specify the permissions
          of the socket file. These sub-arguments do not apply to  abstract sockets.
        '';
        type = types.str;
      };
      port = mkOption {
        description = "The port to use for IP sockets. If port is not specified, port 80 (http) is used.";
        default = null;
        type = with types; nullOr port;
      };
      proto = mkOption {
        description = "PROTO can be 'HTTP' (the default) or 'PROXY'.  Both version 1 and 2 of the proxy protocol can be used.";
        type = types.enum [
          "HTTP"
          "PROXY"
        ];
        default = "HTTP";
      };
      user = mkOption {
        description = "User name who owns the socket file.";
        default = null;
        type = with lib.types; nullOr str;
      };
      group = mkOption {
        description = "Group name who owns the socket file.";
        default = null;
        type = with lib.types; nullOr str;
      };
      mode = mkOption {
        description = "Permission of the socket file (3-digit octal value).";
        default = null;
        type = with types; nullOr str;
      };
    };
  };
  checkedAddressModule = types.addCheck addressSubmodule (
    m:
    (
      if ((hasPrefix "@" m.address) || (hasPrefix "/" m.address)) then
        # this is a unix socket
        (m.port != null)
      else
      # this is not a path-based unix socket
      if !(hasPrefix "/" m.address) && (m.group != null) || (m.user != null) || (m.mode != null) then
        false
      else
        true
    )
  );
  commandLine =
    "-f ${pkgs.writeText "default.vcl" cfg.config}"
    +
      lib.optionalString (cfg.extraModules != [ ])
        " -p vmod_path='${
           lib.makeSearchPathOutput "lib" "lib/vinyl/vmods" ([ cfg.package ] ++ cfg.extraModules)
         }' -r vmod_path";
in
{
  meta.maintainers = [
    lib.maintainers.leona
    lib.maintainers.osnyx
  ];
  options = {
    services.vinyl-cache = {
      enable = lib.mkEnableOption "Vinyl Cache";

      enableConfigCheck = lib.mkEnableOption "checking the config during build time" // {
        default = true;
      };

      package = lib.mkPackageOption pkgs "vinyl-cache" { };

      listen = lib.mkOption {
        description = "Accept for client requests on the specified listen addresses.";
        type = lib.types.listOf checkedAddressModule;
        defaultText = lib.literalExpression ''[ { address="*"; port=6081; } ]'';
        default = [
          {
            address = "*";
            port = 6081;
          }
        ];
      };

      config = lib.mkOption {
        type = lib.types.lines;
        description = ''
          Verbatim default.vcl configuration.
        '';
      };

      extraModules = lib.mkOption {
        type = lib.types.listOf lib.types.package;
        default = [ ];
        description = ''
          Vinyl Cache modules (except 'std').
        '';
      };

      extraCommandLine = lib.mkOption {
        type = lib.types.str;
        default = "";
        example = "-s malloc,256M";
        description = ''
          Command line switches for vinyld (run 'vinyld -?' to get list of options)
        '';
      };

      enableFileLogging = lib.mkEnableOption "file based logging";
    };

  };

  config = lib.mkMerge [
    (lib.mkIf cfg.enable {
      systemd.services.vinyl-cache = {
        description = "Vinyl Cache";
        wantedBy = [ "multi-user.target" ];
        after = [ "network.target" ];
        serviceConfig = {
          Type = "simple";
          ExecStart = "${cfg.package}/bin/vinyld ${commandLineAddresses} -n ${stateDir} -F ${cfg.extraCommandLine} ${commandLine}";
          Restart = "always";
          RestartSec = "5s";
          User = "vinyl-cache";
          Group = "vinyl-cache";
          DynamicUser = true;
          RuntimeDirectory = lib.removePrefix "/var/run/" stateDir;
          AmbientCapabilities = [ "CAP_NET_BIND_SERVICE" ];
          NoNewPrivileges = true;
          LimitNOFILE = 131072;
        };
      };

      environment.systemPackages = [ cfg.package ];

      # check .vcl syntax at compile time (e.g. before nixops deployment)
      system.checks = lib.mkIf cfg.enableConfigCheck [
        (pkgs.runCommand "check-vinyl-cache-syntax" { } ''
          ${cfg.package}/bin/vinyld -C ${commandLine} 2> $out || (cat $out; exit 1)
        '')
      ];

      assertions =
        concatMap (m: [
          {
            assertion = (hasPrefix "/" m.address) || (hasPrefix "@" m.address) -> m.port == null;
            message = "Listen ports must not be specified with UNIX sockets: ${builtins.toJSON m}";
          }
          {
            assertion = !(hasPrefix "/" m.address) -> m.user == null && m.group == null && m.mode == null;
            message = "Abstract UNIX sockets or IP sockets can not be used with user, group, and mode settings: ${builtins.toJSON m}";
          }
        ]) cfg.listen
        ++ [
          {
            assertion = cfg.package.pname == "vinyl-cache";
            message = "services.vinyl-cache only supports Vinyl Cache. Please use services.varnish.";
          }
        ];
    })
    (lib.mkIf (cfg.enable && cfg.enableFileLogging) {
      systemd.services = {
        vinylncsa = {
          after = [ "vinyl-cache.service" ];
          requires = [ "vinyl-cache.service" ];
          description = "Vinyl Cache logging daemon";
          wantedBy = [ "multi-user.target" ];
          # We want to reopen logs with HUP. vinylncsa must run in daemon mode for that.
          serviceConfig = {
            Type = "forking";
            Restart = "always";
            RuntimeDirectory = "vinylncsa";
            LogsDirectory = "vinyl-cache";
            PIDFile = "/run/vinylncsa/vinylncsa.pid";
            User = "vinyl-cache";
            Group = "vinyl-cache";
            ExecStart = "${cfg.package}/bin/vinylncsa -D -a -w /var/log/vinyl-cache/vinyl-cache.log -P /run/vinylncsa/vinylncsa.pid";
            ExecReload = "${pkgs.coreutils}/bin/kill -HUP $MAINPID";
          };
        };
      };

      services.logrotate.settings.vinyl-cache = lib.mapAttrs (_: lib.mkDefault) {
        files = [ "/var/log/vinyl-cache/*.log" ];
        frequency = "daily";
        rotate = 14;
        compress = true;
        delaycompress = true;
        postrotate = "systemctl reload vinylncsa";
      };
    })
  ];
}

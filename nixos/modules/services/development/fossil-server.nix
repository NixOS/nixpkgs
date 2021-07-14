{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.services.fossil;
in
{

  ###### interface

  options.services.fossil = {

    enable = mkOption {
      type = types.bool;
      default = false;
      description = ''
          Enable the Fossil server, which will start an HTTP server to
          publish Fossil repositories.
        '';
    };

    repository = mkOption {
      type = types.str;
      default = "/srv/fossil";
      example = "/fossils/repo.fossil";
      description = ''
          The REPOSITORY can be a directory that contains one or more
          repositories with names ending in ".fossil" or a single file.
        '';
    };

    baseurl = mkOption {
      type = types.str;
      default = "";
      example = "example.com";
      description = "Use URL as the base (useful for reverse proxies)";
    };

    extroot = mkOption {
      type = types.str;
      default = "";
      description = "Document root for the /ext extension mechanism";
    };

    files = mkOption {
      type = types.str;
      default = "";
      description = "Comma-separated list of glob patterns for static files";
    };

    localhost = mkOption {
      type = types.bool;
      default = false;
      description = "Listen on 127.0.0.1 only";
    };

    https = mkOption {
      type = types.bool;
      default = false;
      description = ''
          Indicates that the input is coming through a reverse proxy
          that has already translated HTTPS into HTTP.
        '';
    };

    jsmode = mkOption {
      type = types.nullOr (types.enum [ "inline" "separate" "bundled" ]);
      default = null;
      example = "inline";
      description = ''
          Determine how JavaScript is delivered with pages.
          Mode can be one of:
            inline       All JavaScript is inserted inline at
                         the end of the HTML file.
            separate     Separate HTTP requests are made for
                         each JavaScript file.
            bundled      One single separate HTTP fetches all
                         JavaScript concatenated together.
        '';
    };

    maxLatency = mkOption {
      type = types.int;
      default = 0;
      example = 60;
      description = "Do not let any single HTTP request run for more than N seconds";
    };

    nocompress = mkOption {
      type = types.bool;
      default = false;
      description = "Do not compress HTTP replies";
    };

    nossl = mkOption {
      type = types.bool;
      default = false;
      description = "Signal that no SSL connections are available";
    };

    port = mkOption {
      type = types.int;
      default = 8080;
      description = "Port to listen on";
    };

    repolist = mkOption {
      type = types.bool;
      default = if (lib.strings.hasSuffix ".fossil" cfg.repository) then false else true;
      description = ''If REPOSITORY is dir, URL "/" lists repos.'';
    };

    user = mkOption {
      type = types.str;
      default = "fossil";
      description = "User to run fossil as";
    };

    group = mkOption {
      type = types.str;
      default = "fossil";
      description = "Group to run fossil as";
    };

  };

  ###### implementation

  config = mkIf cfg.enable {

    users.users.${cfg.user} = {
      description     = "Fossil server user";
      group           = cfg.group;
      isSystemUser    = true;
    };

    users.groups.${cfg.group} = {
      members = [ cfg.user ];
    };

    networking.firewall.allowedTCPPorts = [ cfg.port ];
    systemd.services.fossil = {
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        User = cfg.user;
        Group = cfg.group;
        ExecStart = "${pkgs.fossil}/bin/fossil server "
        + (optionalString (cfg.baseurl != "") "--baseurl ${cfg.baseurl} ")
        + (optionalString (cfg.extroot != "") "--extroot ${cfg.extroot} ")
        + (optionalString (cfg.files != "") "--files ${cfg.files} ")
        + (optionalString (cfg.jsmode != null) "--jsmode  ${cfg.jsmode} ")
        + (optionalString (cfg.maxLatency > 0) "--max-latency  ${toString cfg.maxLatency} ")
        + (optionalString cfg.nocompress "--nocompress ")
        + (optionalString cfg.https "--https ")
        + (optionalString cfg.nossl "--nossl ")
        + (optionalString cfg.repolist "--repolist ")
        + (optionalString cfg.localhost "--localhost ")
        + "--port ${toString cfg.port} "
        + cfg.repository;

        # Proc filesystem
        ProcSubset = "pid";
        ProtectProc = "invisible";

        # New file permissions
        UMask = "0027"; # 0640 / 0750

        # Capabilities
        AmbientCapabilities = [ "CAP_NET_BIND_SERVICE" ];
        CapabilityBoundingSet = [ "CAP_NET_BIND_SERVICE" ];

        # Security
        NoNewPrivileges = true;

        # Sandboxing (sorted by occurrence in https://www.freedesktop.org/software/systemd/man/systemd.exec.html)
        ProtectSystem = "strict";
        ProtectHome = mkDefault true;
        ReadWritePaths = [ cfg.repository ];
        PrivateTmp = true;
        PrivateDevices = true;
        ProtectHostname = true;
        ProtectClock = true;
        ProtectKernelTunables = true;
        ProtectKernelModules = true;
        ProtectKernelLogs = true;
        ProtectControlGroups = true;
        RestrictAddressFamilies = [ "AF_INET" "AF_INET6" ];
        RestrictNamespaces = true;
        LockPersonality = true;
        MemoryDenyWriteExecute = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        RemoveIPC = true;
        PrivateMounts = true;

        # System Call Filtering
        SystemCallArchitectures = "native";
        SystemCallFilter = "~@cpu-emulation @debug @keyring @ipc @mount @obsolete @privileged @setuid";

      };
    };

  };

}

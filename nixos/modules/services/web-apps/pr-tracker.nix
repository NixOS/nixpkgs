{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) getExe mkIf types;
  inherit (lib.lists) optionals;
  inherit (lib.attrsets) optionalAttrs;
  inherit (lib.strings) concatStringsSep escapeShellArg;
  inherit (lib.options) mkEnableOption mkOption mkPackageOption;

  cfg = config.services.pr-tracker;
  dataDir = "/var/lib/pr-tracker";

  useClone = cfg.nixpkgsClone.managedByModule;

  preStart = ''
    if [ ! -d ${cfg.nixpkgsClone.cloneDir} ]; then
        ${getExe pkgs.git} clone https://github.com/NixOS/nixpkgs.git ${cfg.nixpkgsClone.cloneDir}
    fi
  '';

  commonUnitSettings = {
    User = cfg.user;
    Group = cfg.group;
    StateDirectory = builtins.baseNameOf dataDir;
    WorkingDirectory = dataDir;
    LimitNOFILE = "1048576";
    PrivateTmp = true;
    PrivateDevices = true;
    StateDirectoryMode = "0700";
  };
in
{
  options.services.pr-tracker = {
    enable = mkEnableOption "pr-tracker";

    package = mkPackageOption pkgs "pr-tracker" { };

    githubApiTokenFile = mkOption {
      type = types.path;
      example = "/run/secrets/gh-token";
      description = ''
        Path to a file containing your GitHub API token like so:

        ```
        ghp_...
        ```

        ::: {.note}
        The contents of this file will be the stdin of pr-tracker.
        :::
      '';
    };

    nixpkgsClone = {
      cloneDir = mkOption {
        type = types.path;
        example = "/home/nixos/git/nixpkgs";
        default = "${dataDir}/nixpkgs";
        defaultText = "/var/lib/pr-tracker/nixpkgs";
        description = ''
          The path to the cloned nixpkgs pr-tracker will use.

          ::: {.note}
          If left as the default value this repo will automatically be cloned before
          the pr-tracker server starts, otherwise you are responsible for ensuring
          the directory exists with appropriate ownership and permissions.
          :::
        '';
      };

      remote = mkOption {
        type = types.str;
        example = "upstream";
        default = "origin";
        description = ''
          The remote name in the repository corresponding to upstream Nixpkgs.
        '';
      };

      managedByModule = mkOption {
        type = types.bool;
        default = true;
        description = ''
          Whether you want this service to manage itself a clone of the nixpkgs
          repository to work with in `services.pr-tracker.dataDir`.

          If you want to manage that by yourself, set this option to `false`
        '';
      };

      interval = mkOption {
        type = types.str;
        example = "15min";
        default = "30min";
        description = ''
          How often to fetch nixpkgs if `services.pr-tracker.nixpkgsClone.managedByModule`
          is true.

          The format is described in {manpage}`systemd.time(7)`.
        '';
      };
    };

    userAgent = mkOption {
      type = types.str;
      example = "pr-tracker run by a NixOS user";
      description = ''
        The User-Agent string used in the headers of the https requests when sending API request to GitHub.
        It is recommended to contain your GitHub username and application name.

        See the [GitHub Documentation](https://docs.github.com/en/rest/using-the-rest-api/getting-started-with-the-rest-api#user-agent) for more details.
      '';
    };

    sourceUrl = mkOption {
      type = types.str;
      example = "https://github.com/me/my-pr-tracker-fork";
      default = cfg.package.meta.homepage or "https://git.qyliss.net/pr-tracker";
      defaultText = "https://git.qyliss.net/pr-tracker";
      description = ''
        The URL where users can download the program's source code.
      '';
    };

    mountPath = mkOption {
      type = with types; nullOr str;
      example = "pr-tracker.html";
      default = null;
      description = ''
        A "mount" path can be specified, which will be prefixed to all
        of the server's routes, so that it can be served at a non-root
        HTTP path.

        Adding a leading slash to your mount path is optional.
      '';
    };

    user = mkOption {
      default = "pr-tracker";
      type = types.str;
      description = ''
        User account under which pr-tracker runs.

        ::: {.note}
        If left as the default value this user will automatically be created
        on system activation, otherwise you are responsible for ensuring the
        user exists before the pr-tracker service starts.
        :::
      '';
    };

    group = mkOption {
      default = "pr-tracker";
      type = types.str;
      description = ''
        Group account under which pr-tracker runs.

        ::: {.note}
        If left as the default value this user will automatically be created
        on system activation, otherwise you are responsible for ensuring the
        user exists before the pr-tracker service starts.
        :::
      '';
    };

    listen = mkOption {
      type = types.str;
      default = "0.0.0.0";
      example = "127.0.0.1";
      description = ''
        The IP address to bind the socket to.
      '';
    };

    port = mkOption {
      type = types.port;
      default = 3000;
      description = ''
        TCP port where pr-tracker will listen on.
      '';
    };

    openFirewall = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Open ports needed for the functionality of the program.
      '';
    };
  };

  config = mkIf cfg.enable {
    users.users = optionalAttrs (cfg.user == "pr-tracker") {
      pr-tracker = {
        group = cfg.group;
        home = dataDir;
        isSystemUser = true;
      };
    };

    users.groups = optionalAttrs (cfg.group == "pr-tracker") { pr-tracker = { }; };

    networking.firewall = mkIf cfg.openFirewall { allowedTCPPorts = [ cfg.port ]; };

    systemd.sockets.pr-tracker = {
      listenStreams = [ "${cfg.listen}:${toString cfg.port}" ];
      wantedBy = [ "sockets.target" ];
    };

    systemd.services.pr-tracker = optionalAttrs useClone { inherit preStart; } // {
      path = [ pkgs.git ];

      serviceConfig = commonUnitSettings // {
        Restart = "always";

        StandardInput = "file:${cfg.githubApiTokenFile}";

        ExecStart = concatStringsSep " " (
          escapeShellArg (
            [
              (getExe cfg.package)
              "--source-url ${cfg.sourceUrl}"
              "--user-agent ${cfg.userAgent}"
              "--path ${cfg.nixpkgsClone.cloneDir}"
              "--remote ${cfg.nixpkgsClone.remote}"
            ]
            ++ optionals (cfg.mountPath != null) [ "--mount ${cfg.mountPath}" ]
          )
        );

        # Hardening
        CapabilityBoundingSet = "";
        LockPersonality = true;
        MemoryDenyWriteExecute = true;
        PrivateUsers = true;
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHome = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectProc = "invisible";
        ProcSubset = "pid";
        ProtectSystem = "strict";
        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
          "AF_NETLINK"
        ];
        RestrictNamespaces = true;
        RestrictRealtime = true;
        SystemCallArchitectures = "native";
        SystemCallFilter = [
          "@system-service"
          "@pkey"
        ];
        UMask = "0077";
      };
    };

    systemd.timers.pr-tracker-update = optionalAttrs useClone {
      wantedBy = [ "timers.target" ];
      timerConfig = {
        OnBootSec = cfg.nixpkgsClone.interval;
        OnUnitActiveSec = cfg.nixpkgsClone.interval;
      };
    };

    systemd.services.pr-tracker-update = optionalAttrs useClone {
      path = with pkgs; [ git ];
      inherit preStart;

      script = ''
        set -eu
        git -C ${cfg.nixpkgsClone.cloneDir} fetch
      '';

      serviceConfig = commonUnitSettings // {
        Requires = "pr-tracker";
        Type = "oneshot";
      };
    };
  };

  meta = with lib; {
    maintainers = with maintainers; [ matt1432 ];
  };
}

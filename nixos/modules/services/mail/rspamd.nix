{
  config,
  options,
  pkgs,
  lib,
  ...
}:

let

  cfg = config.services.rspamd;
  opt = options.services.rspamd;
  postfixCfg = config.services.postfix;

  bindSocketOpts =
    { options, config, ... }:
    {
      options = {
        socket = lib.mkOption {
          type = lib.types.str;
          example = "localhost:11333";
          description = ''
            Socket for this worker to listen on in a format acceptable by rspamd.
          '';
        };
        mode = lib.mkOption {
          type = lib.types.str;
          default = "0644";
          description = "Mode to set on unix socket";
        };
        owner = lib.mkOption {
          type = lib.types.str;
          default = "${cfg.user}";
          description = "Owner to set on unix socket";
        };
        group = lib.mkOption {
          type = lib.types.str;
          default = "${cfg.group}";
          description = "Group to set on unix socket";
        };
        rawEntry = lib.mkOption {
          type = lib.types.str;
          internal = true;
        };
      };
      config.rawEntry =
        let
          maybeOption = option: lib.optionalString options.${option}.isDefined " ${option}=${config.${option}}";
        in
        if (!(lib.hasPrefix "/" config.socket)) then
          "${config.socket}"
        else
          "${config.socket}${maybeOption "mode"}${maybeOption "owner"}${maybeOption "group"}";
    };

  traceWarning = w: x: builtins.trace "[1;31mwarning: ${w}[0m" x;

  workerOpts =
    { name, options, ... }:
    {
      options = {
        enable = lib.mkOption {
          type = lib.types.nullOr lib.types.bool;
          default = null;
          description = "Whether to run the rspamd worker.";
        };
        name = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          default = name;
          description = "Name of the worker";
        };
        type = lib.mkOption {
          type = lib.types.nullOr (
            lib.types.enum [
              "normal"
              "controller"
              "fuzzy"
              "rspamd_proxy"
              "lua"
              "proxy"
            ]
          );
          description = ''
            The type of this worker. The type `proxy` is
            deprecated and only kept for backwards compatibility and should be
            replaced with `rspamd_proxy`.
          '';
          apply =
            let
              from = "services.rspamd.workers.\"${name}\".type";
              files = options.type.files;
              warning = "The option `${from}` defined in ${lib.showFiles files} has enum value `proxy` which has been renamed to `rspamd_proxy`";
            in
            x: if x == "proxy" then traceWarning warning "rspamd_proxy" else x;
        };
        bindSockets = lib.mkOption {
          type = lib.types.listOf (lib.types.either lib.types.str (lib.types.submodule bindSocketOpts));
          default = [ ];
          description = ''
            List of sockets to listen, in format acceptable by rspamd
          '';
          example = [
            {
              socket = "/run/rspamd.sock";
              mode = "0666";
              owner = "rspamd";
            }
            "*:11333"
          ];
          apply =
            value:
            map (
              each:
              if (lib.isString each) then
                if (isUnixSocket each) then
                  {
                    socket = each;
                    owner = cfg.user;
                    group = cfg.group;
                    mode = "0644";
                    rawEntry = "${each}";
                  }
                else
                  {
                    socket = each;
                    rawEntry = "${each}";
                  }
              else
                each
            ) value;
        };
        count = lib.mkOption {
          type = lib.types.nullOr lib.types.int;
          default = null;
          description = ''
            Number of worker instances to run
          '';
        };
        includes = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [ ];
          description = ''
            List of files to include in configuration
          '';
        };
        extraConfig = lib.mkOption {
          type = lib.types.lines;
          default = "";
          description = "Additional entries to put verbatim into worker section of rspamd config file.";
        };
      };
      config =
        lib.mkIf (name == "normal" || name == "controller" || name == "fuzzy" || name == "rspamd_proxy")
          {
            type = lib.mkDefault name;
            includes = lib.mkDefault [ "$CONFDIR/worker-${if name == "rspamd_proxy" then "proxy" else name}.inc" ];
            bindSockets =
              let
                unixSocket = name: {
                  mode = "0660";
                  socket = "/run/rspamd/${name}.sock";
                  owner = cfg.user;
                  group = cfg.group;
                };
              in
              lib.mkDefault (
                if name == "normal" then
                  [ (unixSocket "rspamd") ]
                else if name == "controller" then
                  [ "localhost:11334" ]
                else if name == "rspamd_proxy" then
                  [ (unixSocket "proxy") ]
                else
                  [ ]
              );
          };
    };

  isUnixSocket = socket: lib.hasPrefix "/" (if (lib.isString socket) then socket else socket.socket);

  mkBindSockets =
    enabled: socks:
    lib.concatStringsSep "\n  " (lib.flatten (map (each: "bind_socket = \"${each.rawEntry}\";") socks));

  rspamdConfFile = pkgs.writeText "rspamd.conf" ''
    .include "$CONFDIR/common.conf"

    options {
      pidfile = "$RUNDIR/rspamd.pid";
      .include "$CONFDIR/options.inc"
      .include(try=true; priority=1,duplicate=merge) "$LOCAL_CONFDIR/local.d/options.inc"
      .include(try=true; priority=10) "$LOCAL_CONFDIR/override.d/options.inc"
    }

    logging {
      type = "syslog";
      .include "$CONFDIR/logging.inc"
      .include(try=true; priority=1,duplicate=merge) "$LOCAL_CONFDIR/local.d/logging.inc"
      .include(try=true; priority=10) "$LOCAL_CONFDIR/override.d/logging.inc"
    }

    ${lib.concatStringsSep "\n" (
      lib.mapAttrsToList (
        name: value:
        let
          includeName = if name == "rspamd_proxy" then "proxy" else name;
          tryOverride = lib.boolToString (value.extraConfig == "");
        in
        ''
          worker "${value.type}" {
            type = "${value.type}";
            ${lib.optionalString (value.enable != null)
              "enabled = ${if value.enable != false then "yes" else "no"};"
            }
            ${mkBindSockets value.enable value.bindSockets}
            ${lib.optionalString (value.count != null) "count = ${toString value.count};"}
            ${lib.concatStringsSep "\n  " (map (each: ".include \"${each}\"") value.includes)}
            .include(try=true; priority=1,duplicate=merge) "$LOCAL_CONFDIR/local.d/worker-${includeName}.inc"
            .include(try=${tryOverride}; priority=10) "$LOCAL_CONFDIR/override.d/worker-${includeName}.inc"
          }
        ''
      ) cfg.workers
    )}

    ${lib.optionalString (cfg.extraConfig != "") ''
      .include(priority=10) "$LOCAL_CONFDIR/override.d/extra-config.inc"
    ''}
  '';

  filterFiles = files: lib.filterAttrs (n: v: v.enable) files;
  rspamdDir = pkgs.linkFarm "etc-rspamd-dir" (
    (lib.mapAttrsToList (name: file: {
      name = "local.d/${name}";
      path = file.source;
    }) (filterFiles cfg.locals))
    ++ (lib.mapAttrsToList (name: file: {
      name = "override.d/${name}";
      path = file.source;
    }) (filterFiles cfg.overrides))
    ++ (lib.optional (cfg.localLuaRules != null) {
      name = "rspamd.local.lua";
      path = cfg.localLuaRules;
    })
    ++ [
      {
        name = "rspamd.conf";
        path = rspamdConfFile;
      }
    ]
  );

  configFileModule =
    prefix:
    { name, config, ... }:
    {
      options = {
        enable = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = ''
            Whether this file ${prefix} should be generated.  This
            option allows specific ${prefix} files to be disabled.
          '';
        };

        text = lib.mkOption {
          default = null;
          type = lib.types.nullOr lib.types.lines;
          description = "Text of the file.";
        };

        source = lib.mkOption {
          type = lib.types.path;
          description = "Path of the source file.";
        };
      };
      config = {
        source = lib.mkIf (config.text != null) (
          let
            name' = "rspamd-${prefix}-" + baseNameOf name;
          in
          lib.mkDefault (pkgs.writeText name' config.text)
        );
      };
    };

  configOverrides =
    (lib.mapAttrs' (
      n: v:
      lib.nameValuePair "worker-${if n == "rspamd_proxy" then "proxy" else n}.inc" {
        text = v.extraConfig;
      }
    ) (lib.filterAttrs (n: v: v.extraConfig != "") cfg.workers))
    // (lib.optionalAttrs (cfg.extraConfig != "") {
      "extra-config.inc".text = cfg.extraConfig;
    });
in

{
  ###### interface

  options = {

    services.rspamd = {

      enable = lib.mkEnableOption "rspamd, the Rapid spam filtering system";

      debug = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Whether to run the rspamd daemon in debug mode.";
      };

      locals = lib.mkOption {
        type = with lib.types; attrsOf (submodule (configFileModule "locals"));
        default = { };
        description = ''
          Local configuration files, written into {file}`/etc/rspamd/local.d/{name}`.
        '';
        example = lib.literalExpression ''
          { "redis.conf".source = "/nix/store/.../etc/dir/redis.conf";
            "arc.conf".text = "allow_envfrom_empty = true;";
          }
        '';
      };

      overrides = lib.mkOption {
        type = with lib.types; attrsOf (submodule (configFileModule "overrides"));
        default = { };
        description = ''
          Overridden configuration files, written into {file}`/etc/rspamd/override.d/{name}`.
        '';
        example = lib.literalExpression ''
          { "redis.conf".source = "/nix/store/.../etc/dir/redis.conf";
            "arc.conf".text = "allow_envfrom_empty = true;";
          }
        '';
      };

      localLuaRules = lib.mkOption {
        default = null;
        type = lib.types.nullOr lib.types.path;
        description = ''
          Path of file to link to {file}`/etc/rspamd/rspamd.local.lua` for local
          rules written in Lua
        '';
      };

      workers = lib.mkOption {
        type = with lib.types; attrsOf (submodule workerOpts);
        description = ''
          Attribute set of workers to start.
        '';
        default = {
          normal = { };
          controller = { };
        };
        example = lib.literalExpression ''
          {
            normal = {
              includes = [ "$CONFDIR/worker-normal.inc" ];
              bindSockets = [{
                socket = "/run/rspamd/rspamd.sock";
                mode = "0660";
                owner = "''${config.${opt.user}}";
                group = "''${config.${opt.group}}";
              }];
            };
            controller = {
              includes = [ "$CONFDIR/worker-controller.inc" ];
              bindSockets = [ "[::1]:11334" ];
            };
          }
        '';
      };

      extraConfig = lib.mkOption {
        type = lib.types.lines;
        default = "";
        description = ''
          Extra configuration to add at the end of the rspamd configuration
          file.
        '';
      };

      user = lib.mkOption {
        type = lib.types.str;
        default = "rspamd";
        description = ''
          User to use when no root privileges are required.
        '';
      };

      group = lib.mkOption {
        type = lib.types.str;
        default = "rspamd";
        description = ''
          Group to use when no root privileges are required.
        '';
      };

      postfix = {
        enable = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Add rspamd milter to postfix main.conf";
        };

        config = lib.mkOption {
          type =
            with lib.types;
            attrsOf (oneOf [
              bool
              str
              (listOf str)
            ]);
          description = ''
            Addon to postfix configuration
          '';
          default = {
            smtpd_milters = [ "unix:/run/rspamd/rspamd-milter.sock" ];
            non_smtpd_milters = [ "unix:/run/rspamd/rspamd-milter.sock" ];
          };
        };
      };
    };
  };

  ###### implementation

  config = lib.mkIf cfg.enable {
    services.rspamd.overrides = configOverrides;
    services.rspamd.workers = lib.mkIf cfg.postfix.enable {
      controller = { };
      rspamd_proxy = {
        bindSockets = [
          {
            mode = "0660";
            socket = "/run/rspamd/rspamd-milter.sock";
            owner = cfg.user;
            group = postfixCfg.group;
          }
        ];
        extraConfig = ''
          upstream "local" {
            default = yes; # Self-scan upstreams are always default
            self_scan = yes; # Enable self-scan
          }
        '';
      };
    };
    services.postfix.config = lib.mkIf cfg.postfix.enable cfg.postfix.config;

    systemd.services.postfix = lib.mkIf cfg.postfix.enable {
      serviceConfig.SupplementaryGroups = [ postfixCfg.group ];
    };

    # Allow users to run 'rspamc' and 'rspamadm'.
    environment.systemPackages = [ pkgs.rspamd ];

    users.users.${cfg.user} = {
      description = "rspamd daemon";
      uid = config.ids.uids.rspamd;
      group = cfg.group;
    };

    users.groups.${cfg.group} = {
      gid = config.ids.gids.rspamd;
    };

    environment.etc.rspamd.source = rspamdDir;

    systemd.services.rspamd = {
      description = "Rspamd Service";

      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      restartTriggers = [ rspamdDir ];

      serviceConfig = {
        ExecStart = "${pkgs.rspamd}/bin/rspamd ${lib.optionalString cfg.debug "-d"} -c /etc/rspamd/rspamd.conf -f";
        Restart = "always";

        User = "${cfg.user}";
        Group = "${cfg.group}";
        SupplementaryGroups = lib.mkIf cfg.postfix.enable [ postfixCfg.group ];

        RuntimeDirectory = "rspamd";
        RuntimeDirectoryMode = "0755";
        StateDirectory = "rspamd";
        StateDirectoryMode = "0700";

        AmbientCapabilities = [ ];
        CapabilityBoundingSet = "";
        DevicePolicy = "closed";
        LockPersonality = true;
        NoNewPrivileges = true;
        PrivateDevices = true;
        PrivateMounts = true;
        PrivateTmp = true;
        # we need to chown socket to rspamd-milter
        PrivateUsers = !cfg.postfix.enable;
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHome = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectSystem = "strict";
        RemoveIPC = true;
        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
          "AF_UNIX"
        ];
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        SystemCallArchitectures = "native";
        SystemCallFilter = "@system-service";
        UMask = "0077";
      };
    };
  };
  imports = [
    (lib.mkRemovedOptionModule [
      "services"
      "rspamd"
      "socketActivation"
    ] "Socket activation never worked correctly and could at this time not be fixed and so was removed")
    (lib.mkRenamedOptionModule
      [ "services" "rspamd" "bindSocket" ]
      [ "services" "rspamd" "workers" "normal" "bindSockets" ]
    )
    (lib.mkRenamedOptionModule
      [ "services" "rspamd" "bindUISocket" ]
      [ "services" "rspamd" "workers" "controller" "bindSockets" ]
    )
    (lib.mkRemovedOptionModule [
      "services"
      "rmilter"
    ] "Use services.rspamd.* instead to set up milter service")
  ];
}

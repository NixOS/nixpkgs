{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.uwsgi;

  isEmperor = cfg.instance.type == "emperor";

  imperialPowers = [
    # spawn other user processes
    "CAP_SETUID"
    "CAP_SETGID"
    "CAP_SYS_CHROOT"
    # transfer capabilities
    "CAP_SETPCAP"
    # create other user sockets
    "CAP_CHOWN"
  ];

  buildCfg =
    name: c:
    let
      plugins' =
        if lib.any (n: !lib.any (m: m == n) cfg.plugins) (c.plugins or [ ]) then
          throw "`plugins` attribute in uWSGI configuration contains plugins not in config.services.uwsgi.plugins"
        else
          c.plugins or cfg.plugins;
      plugins = lib.unique plugins';

      hasPython = v: lib.filter (n: n == "python${v}") plugins != [ ];
      hasPython2 = hasPython "2";
      hasPython3 = hasPython "3";

      python =
        if hasPython2 && hasPython3 then
          throw "`plugins` attribute in uWSGI configuration shouldn't contain both python2 and python3"
        else if hasPython2 then
          cfg.package.python2
        else if hasPython3 then
          cfg.package.python3
        else
          null;

      pythonEnv = python.withPackages (c.pythonPackages or (self: [ ]));

      uwsgiCfg = {
        uwsgi =
          if c.type == "normal" then
            {
              inherit plugins;
            }
            // removeAttrs c [
              "type"
              "pythonPackages"
            ]
            // lib.optionalAttrs (python != null) {
              pyhome = "${pythonEnv}";
              env =
                # Argh, uwsgi expects list of key-values there instead of a dictionary.
                let
                  envs = lib.partition (lib.hasPrefix "PATH=") (c.env or [ ]);
                  oldPaths = map (x: lib.substring (lib. "PATH=") (lib.stringLength x) x) envs.right;
                  paths = oldPaths ++ [ "${pythonEnv}/bin" ];
                in
                [ "PATH=${lib.concatStringsSep ":" paths}" ] ++ envs.wrong;
            }
          else if isEmperor then
            {
              emperor =
                if builtins.typeOf c.vassals != "set" then
                  c.vassals
                else
                  pkgs.buildEnv {
                    name = "vassals";
                    paths = lib.mapAttrsToList buildCfg c.vassals;
                  };
            }
            // removeAttrs c [
              "type"
              "vassals"
            ]
          else
            throw "`type` attribute in uWSGI configuration should be either 'normal' or 'emperor'";
      };

    in
    pkgs.writeTextDir "${name}.json" (builtins.toJSON uwsgiCfg);

in
{

  options = {
    services.uwsgi = {

      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable uWSGI";
      };

      runDir = lib.mkOption {
        type = lib.types.path;
        default = "/run/uwsgi";
        description = "Where uWSGI communication sockets can live";
      };

      package = lib.mkOption {
        type = lib.types.package;
        internal = true;
      };

      instance = lib.mkOption {
        type =
          let
            valueType =
              lib.types.nullOr (lib.types.oneOf [
                lib.types.bool
                lib.types.int
                lib.types.float
                lib.types.str
                (lib.types.lazyAttrsOf valueType)
                (lib.types.listOf valueType)
                (lib.types.mkOptionType {
                  name = "function";
                  description = "function";
                  check = x: lib.isFunction x;
                  merge = lib.mergeOneOption;
                })
              ])
              // {
                description = "Json value or lambda";
                emptyValue.value = { };
              };
          in
          valueType;
        default = {
          type = "normal";
        };
        example = lib.literalExpression ''
          {
            type = "emperor";
            vassals = {
              moin = {
                type = "normal";
                pythonPackages = self: with self; [ moinmoin ];
                socket = "''${config.services.uwsgi.runDir}/uwsgi.sock";
              };
            };
          }
        '';
        description = ''
          uWSGI configuration. It awaits an attribute `type` inside which can be either
          `normal` or `emperor`.

          For `normal` mode you can specify `pythonPackages` as a function
          from libraries set into a list of libraries. `pythonpath` will be set accordingly.

          For `emperor` mode, you should use `vassals` attribute
          which should be either a set of names and configurations or a path to a directory.

          Other attributes will be used in configuration file as-is. Notice that you can redefine
          `plugins` setting here.
        '';
      };

      plugins = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ ];
        description = "Plugins used with uWSGI";
      };

      user = lib.mkOption {
        type = lib.types.str;
        default = "uwsgi";
        description = "User account under which uWSGI runs.";
      };

      group = lib.mkOption {
        type = lib.types.str;
        default = "uwsgi";
        description = "Group account under which uWSGI runs.";
      };

      capabilities = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        apply = caps: caps ++ lib.optionals isEmperor imperialPowers;
        default = [ ];
        example = lib.literalExpression ''
          [
            "CAP_NET_BIND_SERVICE" # bind on ports <1024
            "CAP_NET_RAW"          # open raw sockets
          ]
        '';
        description = ''
          Grant capabilities to the uWSGI instance. See the
          `capabilities(7)` for available values.

          ::: {.note}
          uWSGI runs as an unprivileged user (even as Emperor) with the minimal
          capabilities required. This option can be used to add fine-grained
          permissions without running the service as root.

          When in Emperor mode, any capability to be inherited by a vassal must
          be specified again in the vassal configuration using `cap`.
          See the uWSGI [docs](https://uwsgi-docs.readthedocs.io/en/latest/Capabilities.html)
          for more information.
          :::
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.tmpfiles.rules = lib.optional (cfg.runDir != "/run/uwsgi") ''
      d ${cfg.runDir} 775 ${cfg.user} ${cfg.group}
    '';

    systemd.services.uwsgi = {
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        User = cfg.user;
        Group = cfg.group;
        Type = "notify";
        ExecStart = "${cfg.package}/bin/uwsgi --json ${buildCfg "server" cfg.instance}/server.json";
        ExecReload = "${pkgs.coreutils}/bin/kill -HUP $MAINPID";
        ExecStop = "${pkgs.coreutils}/bin/kill -INT $MAINPID";
        NotifyAccess = "main";
        KillSignal = "SIGQUIT";
        AmbientCapabilities = cfg.capabilities;
        CapabilityBoundingSet = cfg.capabilities;
        RuntimeDirectory = lib.mkIf (cfg.runDir == "/run/uwsgi") "uwsgi";
      };
    };

    users.users = lib.optionalAttrs (cfg.user == "uwsgi") {
      uwsgi = {
        group = cfg.group;
        uid = config.ids.uids.uwsgi;
      };
    };

    users.groups = lib.optionalAttrs (cfg.group == "uwsgi") {
      uwsgi.gid = config.ids.gids.uwsgi;
    };

    services.uwsgi.package = pkgs.uwsgi.override {
      plugins = lib.unique cfg.plugins;
    };
  };
}

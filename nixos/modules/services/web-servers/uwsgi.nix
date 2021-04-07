{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.uwsgi;

  isEmperor = cfg.instance.type == "emperor";

  imperialPowers =
    [
      # spawn other user processes
      "CAP_SETUID" "CAP_SETGID"
      "CAP_SYS_CHROOT"
      # transfer capabilities
      "CAP_SETPCAP"
      # create other user sockets
      "CAP_CHOWN"
    ];

  buildCfg = name: c:
    let
      plugins =
        if any (n: !any (m: m == n) cfg.plugins) (c.plugins or [])
        then throw "`plugins` attribute in uWSGI configuration contains plugins not in config.services.uwsgi.plugins"
        else c.plugins or cfg.plugins;

      hasPython = v: filter (n: n == "python${v}") plugins != [];
      hasPython2 = hasPython "2";
      hasPython3 = hasPython "3";

      python =
        if hasPython2 && hasPython3 then
          throw "`plugins` attribute in uWSGI configuration shouldn't contain both python2 and python3"
        else if hasPython2 then cfg.package.python2
        else if hasPython3 then cfg.package.python3
        else null;

      pythonEnv = python.withPackages (c.pythonPackages or (self: []));

      uwsgiCfg = {
        uwsgi =
          if c.type == "normal"
            then {
              inherit plugins;
            } // removeAttrs c [ "type" "pythonPackages" ]
              // optionalAttrs (python != null) {
                pyhome = "${pythonEnv}";
                env =
                  # Argh, uwsgi expects list of key-values there instead of a dictionary.
                  let env' = c.env or [];
                      getPath =
                        x: if hasPrefix "PATH=" x
                           then substring (stringLength "PATH=") (stringLength x) x
                           else null;
                      oldPaths = filter (x: x != null) (map getPath env');
                  in env' ++ [ "PATH=${optionalString (oldPaths != []) "${last oldPaths}:"}${pythonEnv}/bin" ];
              }
          else if isEmperor
            then {
              emperor = if builtins.typeOf c.vassals != "set" then c.vassals
                        else pkgs.buildEnv {
                          name = "vassals";
                          paths = mapAttrsToList buildCfg c.vassals;
                        };
            } // removeAttrs c [ "type" "vassals" ]
          else throw "`type` attribute in uWSGI configuration should be either 'normal' or 'emperor'";
      };

    in pkgs.writeTextDir "${name}.json" (builtins.toJSON uwsgiCfg);

in {

  options = {
    services.uwsgi = {

      enable = mkOption {
        type = types.bool;
        default = false;
        description = "Enable uWSGI";
      };

      runDir = mkOption {
        type = types.path;
        default = "/run/uwsgi";
        description = "Where uWSGI communication sockets can live";
      };

      package = mkOption {
        type = types.package;
        internal = true;
      };

      instance = mkOption {
        type =  with types; let
          valueType = nullOr (oneOf [
            bool
            int
            float
            str
            (lazyAttrsOf valueType)
            (listOf valueType)
            (mkOptionType {
              name = "function";
              description = "function";
              check = x: isFunction x;
              merge = mergeOneOption;
            })
          ]) // {
            description = "Json value or lambda";
            emptyValue.value = {};
          };
        in valueType;
        default = {
          type = "normal";
        };
        example = literalExample ''
          {
            type = "emperor";
            vassals = {
              moin = {
                type = "normal";
                pythonPackages = self: with self; [ moinmoin ];
                socket = "${config.services.uwsgi.runDir}/uwsgi.sock";
              };
            };
          }
        '';
        description = ''
          uWSGI configuration. It awaits an attribute <literal>type</literal> inside which can be either
          <literal>normal</literal> or <literal>emperor</literal>.

          For <literal>normal</literal> mode you can specify <literal>pythonPackages</literal> as a function
          from libraries set into a list of libraries. <literal>pythonpath</literal> will be set accordingly.

          For <literal>emperor</literal> mode, you should use <literal>vassals</literal> attribute
          which should be either a set of names and configurations or a path to a directory.

          Other attributes will be used in configuration file as-is. Notice that you can redefine
          <literal>plugins</literal> setting here.
        '';
      };

      plugins = mkOption {
        type = types.listOf types.str;
        default = [];
        description = "Plugins used with uWSGI";
      };

      user = mkOption {
        type = types.str;
        default = "uwsgi";
        description = "User account under which uWSGI runs.";
      };

      group = mkOption {
        type = types.str;
        default = "uwsgi";
        description = "Group account under which uWSGI runs.";
      };

      capabilities = mkOption {
        type = types.listOf types.str;
        apply = caps: caps ++ optionals isEmperor imperialPowers;
        default = [ ];
        example = literalExample ''
          [
            "CAP_NET_BIND_SERVICE" # bind on ports <1024
            "CAP_NET_RAW"          # open raw sockets
          ]
        '';
        description = ''
          Grant capabilities to the uWSGI instance. See the
          <literal>capabilities(7)</literal> for available values.
          <note>
            <para>
              uWSGI runs as an unprivileged user (even as Emperor) with the minimal
              capabilities required. This option can be used to add fine-grained
              permissions without running the service as root.
            </para>
            <para>
              When in Emperor mode, any capability to be inherited by a vassal must
              be specified again in the vassal configuration using <literal>cap</literal>.
              See the uWSGI <link
              xlink:href="https://uwsgi-docs.readthedocs.io/en/latest/Capabilities.html">docs</link>
              for more information.
            </para>
          </note>
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    systemd.tmpfiles.rules = optional (cfg.runDir != "/run/uwsgi") ''
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
        RuntimeDirectory = mkIf (cfg.runDir == "/run/uwsgi") "uwsgi";
      };
    };

    users.users = optionalAttrs (cfg.user == "uwsgi") {
      uwsgi = {
        group = cfg.group;
        uid = config.ids.uids.uwsgi;
      };
    };

    users.groups = optionalAttrs (cfg.group == "uwsgi") {
      uwsgi.gid = config.ids.gids.uwsgi;
    };

    services.uwsgi.package = pkgs.uwsgi.override {
      inherit (cfg) plugins;
    };
  };
}

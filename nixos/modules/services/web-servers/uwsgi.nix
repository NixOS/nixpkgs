{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.uwsgi;

  uwsgi = pkgs.uwsgi.override {
    plugins = cfg.plugins;
  };

  buildCfg = name: c:
    let
      plugins =
        if any (n: !any (m: m == n) cfg.plugins) (c.plugins or [])
        then throw "`plugins` attribute in UWSGI configuration contains plugins not in config.services.uwsgi.plugins"
        else c.plugins or cfg.plugins;

      hasPython = v: filter (n: n == "python${v}") plugins != [];
      hasPython2 = hasPython "2";
      hasPython3 = hasPython "3";

      python =
        if hasPython2 && hasPython3 then
          throw "`plugins` attribute in UWSGI configuration shouldn't contain both python2 and python3"
        else if hasPython2 then uwsgi.python2
        else if hasPython3 then uwsgi.python3
        else null;

      pythonPackages = pkgs.pythonPackages.override {
        inherit python;
        self = pythonPackages;
      };

      penv = python.buildEnv.override {
        extraLibs = (c.pythonPackages or (self: [])) pythonPackages;
      };

      uwsgiCfg = {
        uwsgi =
          if c.type == "normal"
            then {
              inherit plugins;
            } // removeAttrs c [ "type" "pythonPackages" ]
              // optionalAttrs (python != null) {
                pythonpath = "${penv}/${python.sitePackages}";
                env =
                  # Argh, uwsgi expects list of key-values there instead of a dictionary.
                  let env' = c.env or [];
                      getPath =
                        x: if hasPrefix "PATH=" x
                           then substring (stringLength "PATH=") (stringLength x) x
                           else null;
                      oldPaths = filter (x: x != null) (map getPath env');
                  in env' ++ [ "PATH=${optionalString (oldPaths != []) "${last oldPaths}:"}${penv}/bin" ];
              }
          else if c.type == "emperor"
            then {
              emperor = if builtins.typeOf c.vassals != "set" then c.vassals
                        else pkgs.buildEnv {
                          name = "vassals";
                          paths = mapAttrsToList buildCfg c.vassals;
                        };
            } // removeAttrs c [ "type" "vassals" ]
          else throw "`type` attribute in UWSGI configuration should be either 'normal' or 'emperor'";
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
        type = types.string;
        default = "/run/uwsgi";
        description = "Where uWSGI communication sockets can live";
      };

      instance = mkOption {
        type = types.attrs;
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
        description = "User account under which uwsgi runs.";
      };

      group = mkOption {
        type = types.str;
        default = "uwsgi";
        description = "Group account under which uwsgi runs.";
      };
    };
  };

  config = mkIf cfg.enable {
    systemd.services.uwsgi = {
      wantedBy = [ "multi-user.target" ];
      preStart = ''
        mkdir -p ${cfg.runDir}
        chown ${cfg.user}:${cfg.group} ${cfg.runDir}
      '';
      serviceConfig = {
        Type = "notify";
        ExecStart = "${uwsgi}/bin/uwsgi --uid ${cfg.user} --gid ${cfg.group} --json ${buildCfg "server" cfg.instance}/server.json";
        ExecReload = "${pkgs.coreutils}/bin/kill -HUP $MAINPID";
        ExecStop = "${pkgs.coreutils}/bin/kill -INT $MAINPID";
        NotifyAccess = "main";
        KillSignal = "SIGQUIT";
      };
    };

    users.extraUsers = optionalAttrs (cfg.user == "uwsgi") (singleton
      { name = "uwsgi";
        group = cfg.group;
        uid = config.ids.uids.uwsgi;
      });

    users.extraGroups = optionalAttrs (cfg.group == "uwsgi") (singleton
      { name = "uwsgi";
        gid = config.ids.gids.uwsgi;
      });
  };
}

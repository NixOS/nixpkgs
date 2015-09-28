{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.uwsgi;

  python2Pkgs = pkgs.python2Packages.override {
    python = pkgs.uwsgi.python2;
    self = python2Pkgs;
  };

  python3Pkgs = pkgs.python3Packages.override {
    python = pkgs.uwsgi.python3;
    self = python3Pkgs;
  };

  buildCfg = c: if builtins.typeOf c != "set" then builtins.readFile c else builtins.toJSON {
    uwsgi =
      if c.type == "normal"
        then {
          pythonpath =
               (if c ? python2Packages
                then builtins.map (x: "${x}/${pkgs.uwsgi.python2.sitePackages}") (c.python2Packages python2Pkgs)
                else [])
            ++ (if c ? python3Packages
                then builtins.map (x: "${x}/${pkgs.uwsgi.python3.sitePackages}") (c.python3Packages python3Pkgs)
                else []);
          plugins = cfg.plugins;
        } // removeAttrs c [ "type" "python2Packages" "python3Packages" ]
      else if c.type == "emperor"
        then {
          emperor = if builtins.typeOf c.vassals != "set" then c.vassals
                    else pkgs.buildEnv {
                      name = "vassals";
                      paths = mapAttrsToList (n: c: pkgs.writeTextDir "${n}.json" (buildCfg c)) c.vassals;
                    };
        } // removeAttrs c [ "type" "vassals" ]
      else abort "type should be either 'normal' or 'emperor'";
  };

  uwsgi = pkgs.uwsgi.override {
    plugins = cfg.plugins;
  };

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
                python2Packages = self: with self; [ moinmoin ];
                socket = "${config.services.uwsgi.runDir}/uwsgi.sock";
              };
            };
          }
        '';
        description = ''
          uWSGI configuration. This awaits either a path to file or a set which will be made into one.
          If given a set, it awaits an attribute <literal>type</literal> which can be either <literal>normal</literal>
          or <literal>emperor</literal>.

          For <literal>normal</literal> mode you can specify <literal>python2Packages</literal> and
          <literal>python3Packages</literal> as functions from libraries set into lists of libraries.
          For <literal>emperor</literal> mode, you should use <literal>vassals</literal> attribute
          which should be either a set of names and configurations or a path to a directory.
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
        ExecStart = "${uwsgi}/bin/uwsgi --uid ${cfg.user} --gid ${cfg.group} --json ${pkgs.writeText "uwsgi.json" (buildCfg cfg.instance)}";
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

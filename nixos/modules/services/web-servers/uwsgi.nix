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

      json = builtins.toJSON {
        uwsgi =
          if c.type == "normal"
            then {
              inherit plugins;
            } // removeAttrs c [ "type" "pythonPackages" ]
              // optionalAttrs (python != null) {
                pythonpath = "@PYTHONPATH@";
                env = (c.env or {}) // {
                  PATH = optionalString (c ? env.PATH) "${c.env.PATH}:" + "@PATH@";
                };
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

    in
      if python == null || c.type != "normal"
      then pkgs.writeTextDir "${name}.json" json
      else pkgs.stdenv.mkDerivation {
        name = "uwsgi-config";
        inherit json;
        passAsFile = [ "json" ];
        nativeBuildInputs = [ pythonPackages.wrapPython ];
        pythonInputs = (c.pythonPackages or (self: [])) pythonPackages;

        buildCommand = ''
          mkdir $out
          declare -A pythonPathsSeen=()
          program_PYTHONPATH=
          program_PATH=
          if [ -n "$pythonInputs" ]; then
            for i in $pythonInputs; do
              _addToPythonPath $i
            done
          fi
          # A hack to replace "@PYTHONPATH@" with a JSON list
          if [ -n "$program_PYTHONPATH" ]; then
            program_PYTHONPATH="\"''${program_PYTHONPATH//:/\",\"}\""
          fi
          substitute $jsonPath $out/${name}.json \
            --replace '"@PYTHONPATH@"' "[$program_PYTHONPATH]" \
            --subst-var-by PATH "$program_PATH"
        '';
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

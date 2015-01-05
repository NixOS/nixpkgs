{ config, lib, pkgs, ... }:

let
  inherit (builtins) attrNames;
  inherit (lib) mkOption foldl types optionalString;

  su = user: cmd: "${pkgs.su}/bin/su ${user} -s ${pkgs.stdenv.shell} -c \"${cmd}\"";

  initCmd = package: initdb: if initdb != null
    then initdb
    else "${package}/bin/initdb -U root";

  get = config_file: var:
    "eval `${pkgs.gnused}/bin/sed -nr -e '/^\\s*${var}/ s/^\\s*([^ ]+)\\s*=\\s*(.+)/\\1=\\2/p' ${config_file}`";

  initDataDirectory = { config_file, user, package, initdb }: ''
    ${get config_file "data_directory"}
    if [ ! -f "$data_directory/PG_VERSION" ]; then
      mkdir -v -p "$data_directory"
      chown -c "${user}:`id -gn ${user}`" "$data_directory"
      chmod -c 0700 "$data_directory"
      ${su user "${initCmd package initdb} $data_directory"}
      rm -vf $data_directory/*hba.conf
      rm -vf $data_directory/*ident.conf
      rm -vf $data_directory/postgresql.conf
      touch $data_directory/.init
    fi

    if [ x`cat $data_directory/.owner 2>/dev/null` != x${user} ]; then
      chown -c -R "${user}:`id -gn ${user}`" "$data_directory"
      echo ${user} > $data_directory/.owner
    fi
  '';

  initDatabase = { package, config_file, script }: optionalString (script != null) ''
    ${get config_file "data_directory"}
    if [ -f $data_directory/.init ]; then
      sleep 1
      psql="${package}/bin/psql -d postgres -v ON_ERROR_STOP=1"
      ${get config_file "port"}
      if [ -n "$port" ]; then
        psql="$psql -p $port"
      fi
      while ! $psql -c ""; do
        if ! kill -0 $MAINPID; then exit 1; fi
        sleep 1
      done
      $psql -f ${script}
      rm -v $data_directory/.init
    fi
  '';

  postgreSQLService = all: name: {
    "postgresql-${name}" = {
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" "local-fs.target" ];
      preStart = initDataDirectory { inherit (all.${name}) config_file package user initdb; };
      postStart = initDatabase { inherit (all.${name}) config_file package script; };
      serviceConfig = with all.${name}; {
        PermissionsStartOnly = true;
        User = user;
        TimeoutSec = timeout;
        KillSignal = "SIGINT";
        KillMode = "mixed";
        ExecStart = "${package}/bin/postgres -c config_file=${config_file}";
      };
    };
  };

  makeServices = all:
    foldl (a: b: a//b) {} (map (postgreSQLService all) (attrNames all));
in

{
  config.systemd.services = makeServices config.services.postgresqlx;

  options.services.postgresqlx = mkOption {
    default = {};
    description = "PostgreSQL instances.";
    type = types.attrsOf (types.submodule ({
      options = {
        package = mkOption {
          type        = types.package;
          default     = pkgs.postgresql94;
          description = "PostgreSQL package to use.";
        };
        config_file = mkOption {
          type        = types.path;
          description = "Specifies the main server configuration file.";
        };
        user = mkOption {
          type        = types.str;
          description = "User to run service as.";
          default     = "postgres";
        };
        timeout = mkOption {
          type        = types.int;
          description = "Timeout for systemd service to start (seconds)";
          default     = 120;
        };
        initdb = mkOption {
          type        = types.nullOr types.path;
          description = ''
            Specifies the command to initialize data directory.
            This command will be executed after the data directory is created.
            The path to the data directory will be appended to this command.
            Default is initdb from the given PostgreSQL package.
            '';
          example = "\${pkgs.postgresql94}/bin/pg_basebackup ... -R -D";
          default = null;
        };
        script = mkOption {
          type        = types.nullOr types.path;
          description = ''
            Specifies the file containing SQL commands to be
            executed after the data directory is initialized and
            PostgreSQL instance started.
            '';
          default = null;
        };
      }; # options {...}
    })); # type.attrsOf (types.submodule ({...}))
  }; # instances = ...
}


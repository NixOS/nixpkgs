{ config, options, pkgs, lib, ... }:

with lib;

let

  cfg = config.services.rspamd;
  opts = options.services.rspamd;

  bindSocketOpts = {options, config, ... }: {
    options = {
      socket = mkOption {
        type = types.str;
        example = "localhost:11333";
        description = ''
          Socket for this worker to listen on in a format acceptable by rspamd.
        '';
      };
      mode = mkOption {
        type = types.str;
        default = "0644";
        description = "Mode to set on unix socket";
      };
      owner = mkOption {
        type = types.str;
        default = "${cfg.user}";
        description = "Owner to set on unix socket";
      };
      group = mkOption {
        type = types.str;
        default = "${cfg.group}";
        description = "Group to set on unix socket";
      };
      rawEntry = mkOption {
        type = types.str;
        internal = true;
      };
    };
    config.rawEntry = let
      maybeOption = option:
        optionalString options.${option}.isDefined " ${option}=${config.${option}}";
    in
      if (!(hasPrefix "/" config.socket)) then "${config.socket}"
      else "${config.socket}${maybeOption "mode"}${maybeOption "owner"}${maybeOption "group"}";
  };

  workerOpts = { name, ... }: {
    options = {
      enable = mkOption {
        type = types.nullOr types.bool;
        default = null;
        description = "Whether to run the rspamd worker.";
      };
      name = mkOption {
        type = types.nullOr types.str;
        default = name;
        description = "Name of the worker";
      };
      type = mkOption {
        type = types.nullOr (types.enum [
          "normal" "controller" "fuzzy_storage" "proxy" "lua"
        ]);
        description = "The type of this worker";
      };
      bindSockets = mkOption {
        type = types.listOf (types.either types.str (types.submodule bindSocketOpts));
        default = [];
        description = ''
          List of sockets to listen, in format acceptable by rspamd
        '';
        example = [{
          socket = "/run/rspamd.sock";
          mode = "0666";
          owner = "rspamd";
        } "*:11333"];
        apply = value: map (each: if (isString each)
          then if (isUnixSocket each)
            then {socket = each; owner = cfg.user; group = cfg.group; mode = "0644"; rawEntry = "${each}";}
            else {socket = each; rawEntry = "${each}";}
          else each) value;
      };
      count = mkOption {
        type = types.nullOr types.int;
        default = null;
        description = ''
          Number of worker instances to run
        '';
      };
      includes = mkOption {
        type = types.listOf types.str;
        default = [];
        description = ''
          List of files to include in configuration
        '';
      };
      extraConfig = mkOption {
        type = types.lines;
        default = "";
        description = "Additional entries to put verbatim into worker section of rspamd config file.";
      };
    };
    config = mkIf (name == "normal" || name == "controller" || name == "fuzzy") {
      type = mkDefault name;
      includes = mkDefault [ "$CONFDIR/worker-${name}.inc" ];
      bindSockets = mkDefault (if name == "normal"
        then [{
              socket = "/run/rspamd/rspamd.sock";
              mode = "0660";
              owner = cfg.user;
              group = cfg.group;
            }]
        else if name == "controller"
        then [ "localhost:11334" ]
        else [] );
    };
  };

  isUnixSocket = socket: hasPrefix "/" (if (isString socket) then socket else socket.socket);

  mkBindSockets = enabled: socks: concatStringsSep "\n  "
    (flatten (map (each: "bind_socket = \"${each.rawEntry}\";") socks));

  rspamdConfFile = pkgs.writeText "rspamd.conf"
    ''
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

      ${concatStringsSep "\n" (mapAttrsToList (name: value: ''
        worker ${optionalString (value.name != "normal" && value.name != "controller") "${value.name}"} {
          type = "${value.type}";
          ${optionalString (value.enable != null)
            "enabled = ${if value.enable != false then "yes" else "no"};"}
          ${mkBindSockets value.enable value.bindSockets}
          ${optionalString (value.count != null) "count = ${toString value.count};"}
          ${concatStringsSep "\n  " (map (each: ".include \"${each}\"") value.includes)}
          ${value.extraConfig}
        }
      '') cfg.workers)}

      ${cfg.extraConfig}
   '';

  filterFiles = files: filterAttrs (n: v: v.enable) files;
  rspamdDir = pkgs.linkFarm "etc-rspamd-dir" (
    (mapAttrsToList (name: file: { name = "local.d/${name}"; path = file.source; }) (filterFiles cfg.locals)) ++
    (mapAttrsToList (name: file: { name = "override.d/${name}"; path = file.source; }) (filterFiles cfg.overrides)) ++
    (optional (cfg.localLuaRules != null) { name = "rspamd.local.lua"; path = cfg.localLuaRules; }) ++
    [ { name = "rspamd.conf"; path = rspamdConfFile; } ]
  );

  configFileModule = prefix: { name, config, ... }: {
    options = {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = ''
          Whether this file ${prefix} should be generated.  This
          option allows specific ${prefix} files to be disabled.
        '';
      };

      text = mkOption {
        default = null;
        type = types.nullOr types.lines;
        description = "Text of the file.";
      };

      source = mkOption {
        type = types.path;
        description = "Path of the source file.";
      };
    };
    config = {
      source = mkIf (config.text != null) (
        let name' = "rspamd-${prefix}-" + baseNameOf name;
        in mkDefault (pkgs.writeText name' config.text));
    };
  };
in

{

  ###### interface

  options = {

    services.rspamd = {

      enable = mkEnableOption "rspamd, the Rapid spam filtering system";

      debug = mkOption {
        type = types.bool;
        default = false;
        description = "Whether to run the rspamd daemon in debug mode.";
      };

      locals = mkOption {
        type = with types; attrsOf (submodule (configFileModule "locals"));
        default = {};
        description = ''
          Local configuration files, written into <filename>/etc/rspamd/local.d/{name}</filename>.
        '';
        example = literalExample ''
          { "redis.conf".source = "/nix/store/.../etc/dir/redis.conf";
            "arc.conf".text = "allow_envfrom_empty = true;";
          }
        '';
      };

      overrides = mkOption {
        type = with types; attrsOf (submodule (configFileModule "overrides"));
        default = {};
        description = ''
          Overridden configuration files, written into <filename>/etc/rspamd/override.d/{name}</filename>.
        '';
        example = literalExample ''
          { "redis.conf".source = "/nix/store/.../etc/dir/redis.conf";
            "arc.conf".text = "allow_envfrom_empty = true;";
          }
        '';
      };

      localLuaRules = mkOption {
        default = null;
        type = types.nullOr types.path;
        description = ''
          Path of file to link to <filename>/etc/rspamd/rspamd.local.lua</filename> for local
          rules written in Lua
        '';
      };

      workers = mkOption {
        type = with types; attrsOf (submodule workerOpts);
        description = ''
          Attribute set of workers to start.
        '';
        default = {
          normal = {};
          controller = {};
        };
        example = literalExample ''
          {
            normal = {
              includes = [ "$CONFDIR/worker-normal.inc" ];
              bindSockets = [{
                socket = "/run/rspamd/rspamd.sock";
                mode = "0660";
                owner = "${cfg.user}";
                group = "${cfg.group}";
              }];
            };
            controller = {
              includes = [ "$CONFDIR/worker-controller.inc" ];
              bindSockets = [ "[::1]:11334" ];
            };
          }
        '';
      };

      extraConfig = mkOption {
        type = types.lines;
        default = "";
        description = ''
          Extra configuration to add at the end of the rspamd configuration
          file.
        '';
      };

      user = mkOption {
        type = types.string;
        default = "rspamd";
        description = ''
          User to use when no root privileges are required.
        '';
       };

      group = mkOption {
        type = types.string;
        default = "rspamd";
        description = ''
          Group to use when no root privileges are required.
        '';
       };
    };
  };


  ###### implementation

  config = mkIf cfg.enable {

    # Allow users to run 'rspamc' and 'rspamadm'.
    environment.systemPackages = [ pkgs.rspamd ];

    users.users = singleton {
      name = cfg.user;
      description = "rspamd daemon";
      uid = config.ids.uids.rspamd;
      group = cfg.group;
    };

    users.groups = singleton {
      name = cfg.group;
      gid = config.ids.gids.rspamd;
    };

    environment.etc."rspamd".source = rspamdDir;

    systemd.services.rspamd = {
      description = "Rspamd Service";

      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      restartTriggers = [ rspamdDir ];

      serviceConfig = {
        ExecStart = "${pkgs.rspamd}/bin/rspamd ${optionalString cfg.debug "-d"} --user=${cfg.user} --group=${cfg.group} --pid=/run/rspamd.pid -c /etc/rspamd/rspamd.conf -f";
        Restart = "always";
        RuntimeDirectory = "rspamd";
        PrivateTmp = true;
      };

      preStart = ''
        ${pkgs.coreutils}/bin/mkdir -p /var/lib/rspamd
        ${pkgs.coreutils}/bin/chown ${cfg.user}:${cfg.group} /var/lib/rspamd
      '';
    };
  };
  imports = [
    (mkRemovedOptionModule [ "services" "rspamd" "socketActivation" ]
	     "Socket activation never worked correctly and could at this time not be fixed and so was removed")
    (mkRenamedOptionModule [ "services" "rspamd" "bindSocket" ] [ "services" "rspamd" "workers" "normal" "bindSockets" ])
    (mkRenamedOptionModule [ "services" "rspamd" "bindUISocket" ] [ "services" "rspamd" "workers" "controller" "bindSockets" ])
  ];
}

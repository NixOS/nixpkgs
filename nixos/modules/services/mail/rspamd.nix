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
        default = "0660";
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
        default = null;
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
    config = mkIf (name == "normal" || name == "controller" || name == "fuzzy" || name == "rspamd_proxy") {
      includes = mkDefault [ "$CONFDIR/worker-${if name == "rspamd_proxy" then "proxy" else name}.inc" ];
      bindSockets =
        let unixSocket = name: {
          socket = "/run/rspamd/${name}.sock";
          owner = cfg.user;
          group = cfg.group;
        }; in mkDefault (
          if name == "normal" then [ (unixSocket "rspamd") ]
          else if name == "controller" then [ (unixSocket "controller") ]
          else if name == "rspamd_proxy" then [ (unixSocket "proxy") ]
          else [] );
      extraConfig = mkIf (name == "rspamd_proxy") (mkDefault ''
        upstream "local" {
          self_scan = yes;
        }
      '');
    };
  };

  indexOf = default: start: list: e:
    if list == []
    then default
    else if (head list) == e then start
    else (indexOf default (start + (length (listenStreams (head list).socket))) (tail list) e);

  systemdSocket = indexOf (abort "Socket not found") 0 allSockets;

  isUnixSocket = socket: hasPrefix "/" (if (isString socket) then socket else socket.socket);
  isPort = hasPrefix "*:";
  isIPv4Socket = hasPrefix "*v4:";
  isIPv6Socket = hasPrefix "*v6:";
  isLocalHost = hasPrefix "localhost:";
  listenStreams = socket:
    if (isLocalHost socket) then
      let port = (removePrefix "localhost:" socket);
      in [ "127.0.0.1:${port}" ] ++ (if config.networking.enableIPv6 then ["[::1]:${port}"] else [])
    else if (isIPv6Socket socket) then [removePrefix "*v6:" socket]
    else if (isPort socket) then [removePrefix "*:" socket]
    else if (isIPv4Socket socket) then
      throw "error: IPv4 only socket not supported in rspamd with socket activation"
    else if (length (splitString " " socket)) != 1 then
      throw "error: string options not supported in rspamd with socket activation"
    else [socket];

  mkBindSockets = enabled: socks: concatStringsSep "\n  " (flatten (map (each:
    if cfg.socketActivation && enabled != false then
      let systemd = (systemdSocket each);
      in (imap (idx: e: "bind_socket = \"systemd:${toString (systemd + idx - 1)}\";") (listenStreams each.socket))
    else "bind_socket = \"${each.rawEntry}\";") socks));

  rspamdConf = pkgs.symlinkJoin {
    name = "rspamd-conf";
    paths =
      let
        makeConfigs = prefix: attrs: mapAttrsToList (name: text: pkgs.writeTextFile { inherit name text; destination = "/${prefix}/${name}"; }) attrs;
        localFiles = makeConfigs "local.d" cfg.locals;
        overrideFiles = makeConfigs "override.d" cfg.overrides;
      in [ rspamdConfFile ] ++ localFiles ++ overrideFiles;
  };

  rspamdConfFile = pkgs.writeTextDir "rspamd.conf.override"
    ''
      ${concatStringsSep "\n" (mapAttrsToList (name: value: ''
        worker ${optionalString (value.name != null) ''"${value.name}"''} {
          ${optionalString (value.type != null)
            ''type = "${value.type}";''}
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

  allMappedSockets = flatten (mapAttrsToList (name: value:
    if value.enable != false
    then imap (idx: each: {
        name = "${name}";
        index = idx;
        value = each;
      }) value.bindSockets
    else []) cfg.workers);
  allSockets = map (e: e.value) allMappedSockets;

  allSocketNames = map (each: "rspamd-${each.name}-${toString each.index}.socket") allMappedSockets;

in

{

  ###### interface

  options = {

    services.rspamd = {

      enable = mkEnableOption "Whether to run the rspamd daemon.";

      debug = mkOption {
        type = types.bool;
        default = false;
        description = "Whether to run the rspamd daemon in debug mode.";
      };

      socketActivation = mkOption {
        type = types.bool;
        description = ''
          Enable systemd socket activation for rspamd.
        '';
      };

      locals = mkOption {
        type = with types; attrsOf lines;
        default = {};
        description = ''
          Local configuration files, written into <filename>/etc/rspamd/local.d/{name}</filename>.
        '';
      };

      overrides = mkOption {
        type = with types; attrsOf lines;
        default = {};
        description = ''
          Overridden configuration files, written into <filename>/etc/rspamd/override.d/{name}</filename>.
        '';
      };

      workers = mkOption {
        type = with types; attrsOf (submodule workerOpts);
        description = ''
	  Attribute set of workers to start. By default, controller and
          self-scanning proxy worker are started.
        '';
        default = {
          controller = {};
          rspamd_proxy = {};
        };
        example = literalExample ''
          {
            normal = {
              bindSockets = [{
                socket = "/run/rspamd/rspamd.sock";
                mode = "0660";
                owner = "${cfg.user}";
                group = "${cfg.group}";
              }];
            };
            controller = {
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

      postfix = {
        enable = mkOption {
          type = types.bool;
          default = false;
          description = "Add rspamd milter proxy to postfix main.conf";
        };
      };
    };
  };


  ###### implementation

  config = mkIf cfg.enable {

    assertions = [ {
      assertion = !cfg.socketActivation || !(opts.bindSocket.isDefined || opts.bindUISocket.isDefined);
      message = "Can't use socketActivation for rspamd when using renamed bind socket options";
    } ];

    # Allow users to run 'rspamc' and 'rspamadm'.
    environment.systemPackages = [ pkgs.rspamd ];

    users.extraUsers = singleton {
      name = cfg.user;
      description = "rspamd daemon";
      uid = config.ids.uids.rspamd;
      group = cfg.group;
    };

    users.extraGroups = singleton {
      name = cfg.group;
      gid = config.ids.gids.rspamd;
    };

    services.rspamd = {
      socketActivation = mkDefault (!opts.bindSocket.isDefined && !opts.bindUISocket.isDefined);

      workers = mkIf cfg.postfix.enable {
        controller = {};
        rspamd_proxy = {
          bindSockets = [ {
            socket = "/var/lib/postfix/queue/private/rspamd";
            owner = "rspamd";
            group = "postfix";
          } ];
        };
      };

      overrides."logging.inc" = mkDefault ''
        type = "syslog";
      '';
    };

    services.postfix.extraConfig = mkIf cfg.postfix.enable ''
      smtpd_milters = unix:private/rspamd
      non_smtpd_milters = $smtpd_milters
      milter_protocol = 6
    '';

    environment.etc."rspamd".source = rspamdConf;

    systemd.services.rspamd = {
      description = "Rspamd Service";

      wantedBy = mkIf (!cfg.socketActivation) [ "multi-user.target" ];
      after = [ "network.target" ];
      restartTriggers = [ rspamdConf ];

      serviceConfig = {
        ExecStart = "${pkgs.rspamd}/bin/rspamd ${optionalString cfg.debug "-d"} --user=${cfg.user} --group=${cfg.group} --pid=/run/rspamd.pid -f";
        Restart = "on-failure";
        RuntimeDirectory = mkIf (!cfg.socketActivation) "rspamd";
        PrivateTmp = true;
        Sockets = mkIf cfg.socketActivation (concatStringsSep " " allSocketNames);
      };

      preStart = ''
        ${pkgs.coreutils}/bin/mkdir -p /var/lib/rspamd
        ${pkgs.coreutils}/bin/chown ${cfg.user}:${cfg.group} /var/lib/rspamd
      '';
    };
    systemd.sockets = mkIf cfg.socketActivation
      (listToAttrs (map (each: {
        name = "rspamd-${each.name}-${toString each.index}";
        value = {
          description = "Rspamd socket ${toString each.index} for worker ${each.name}";
          wantedBy = [ "sockets.target" ];
          after = optional (each.name == "rspamd_proxy") "postfix.service";
          listenStreams = (listenStreams each.value.socket);
          socketConfig = {
            BindIPv6Only = mkIf (isIPv6Socket each.value.socket) "ipv6-only";
            Service = "rspamd.service";
            SocketUser = mkIf (isUnixSocket each.value.socket) each.value.owner;
            SocketGroup = mkIf (isUnixSocket each.value.socket) each.value.group;
            SocketMode = mkIf (isUnixSocket each.value.socket) each.value.mode;
          };
        };
      }) allMappedSockets));
  };

  imports =
    let mkMappedOptionModule = from: to: changeFn: mkChangedOptionModule from to (config: changeFn config (getAttrFromPath from config));
    in [
      (mkMappedOptionModule [ "services" "rspamd" "bindSocket" ] [ "services" "rspamd" "workers" ] (config: value: { normal.bindSockets = value; }))
      (mkMappedOptionModule [ "services" "rspamd" "bindUISocket" ] [ "services" "rspamd" "workers" ] (config: value: { controller.bindSockets = value; }))
    ];
}

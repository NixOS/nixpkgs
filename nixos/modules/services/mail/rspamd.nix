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

  rspamdConfFile = pkgs.writeText "rspamd.conf"
    ''
      .include "$CONFDIR/common.conf"

      options {
        pidfile = "$RUNDIR/rspamd.pid";
        .include "$CONFDIR/options.inc"
      }

      logging {
        type = "syslog";
        .include "$CONFDIR/logging.inc"
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

    services.rspamd.socketActivation = mkDefault (!opts.bindSocket.isDefined && !opts.bindUISocket.isDefined);

    assertions = [ {
      assertion = !cfg.socketActivation || !(opts.bindSocket.isDefined || opts.bindUISocket.isDefined);
      message = "Can't use socketActivation for rspamd when using renamed bind socket options";
    } ];

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

    environment.etc."rspamd.conf".source = rspamdConfFile;

    systemd.services.rspamd = {
      description = "Rspamd Service";

      wantedBy = mkIf (!cfg.socketActivation) [ "multi-user.target" ];
      after = [ "network.target" ] ++
       (if cfg.socketActivation then allSocketNames else []);
      requires = mkIf cfg.socketActivation allSocketNames;

      serviceConfig = {
        ExecStart = "${pkgs.rspamd}/bin/rspamd ${optionalString cfg.debug "-d"} --user=${cfg.user} --group=${cfg.group} --pid=/run/rspamd.pid -c ${rspamdConfFile} -f";
        Restart = "always";
        RuntimeDirectory = "rspamd";
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
  imports = [
    (mkRenamedOptionModule [ "services" "rspamd" "bindSocket" ] [ "services" "rspamd" "workers" "normal" "bindSockets" ])
    (mkRenamedOptionModule [ "services" "rspamd" "bindUISocket" ] [ "services" "rspamd" "workers" "controller" "bindSockets" ])
  ];
}

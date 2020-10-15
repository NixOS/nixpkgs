{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.kresd;

  # Convert systemd-style address specification to kresd config line(s).
  # On Nix level we don't attempt to precisely validate the address specifications.
  mkListen = kind: addr: let
    al_v4 = builtins.match "([0-9.]\+):([0-9]\+)" addr;
    al_v6 = builtins.match "\\[(.\+)]:([0-9]\+)" addr;
    al_portOnly = builtins.match "([0-9]\+)" addr;
    al = findFirst (a: a != null)
      (throw "services.kresd.*: incorrect address specification '${addr}'")
      [ al_v4 al_v6 al_portOnly ];
    port = last al;
    addrSpec = if al_portOnly == null then "'${head al}'" else "{'::', '127.0.0.1'}";
    in # freebind is set for compatibility with earlier kresd services;
       # it could be configurable, for example.
      ''
        net.listen(${addrSpec}, ${port}, { kind = '${kind}', freebind = true })
      '';

  configFile = pkgs.writeText "kresd.conf" (
    optionalString (cfg.listenDoH != []) ''
      modules.load('http')
    ''
    + concatMapStrings (mkListen "dns") cfg.listenPlain
    + concatMapStrings (mkListen "tls") cfg.listenTLS
    + concatMapStrings (mkListen "doh") cfg.listenDoH
    + cfg.extraConfig
  );

  package = if cfg.listenDoH == []
    then pkgs.knot-resolver # never force `extraFeatures = false`
    else pkgs.knot-resolver.override { extraFeatures = true; };
in {
  meta.maintainers = [ maintainers.vcunat /* upstream developer */ ];

  imports = [
    (mkChangedOptionModule [ "services" "kresd" "interfaces" ] [ "services" "kresd" "listenPlain" ]
      (config:
        let value = getAttrFromPath [ "services" "kresd" "interfaces" ] config;
        in map
          (iface: if elem ":" (stringToCharacters iface) then "[${iface}]:53" else "${iface}:53") # Syntax depends on being IPv6 or IPv4.
          value
      )
    )
    (mkRemovedOptionModule [ "services" "kresd" "cacheDir" ] "Please use (bind-)mounting instead.")
  ];

  ###### interface
  options.services.kresd = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Whether to enable knot-resolver domain name server.
        DNSSEC validation is turned on by default.
        You can run <literal>sudo nc -U /run/knot-resolver/control/1</literal>
        and give commands interactively to kresd@1.service.
      '';
    };
    extraConfig = mkOption {
      type = types.lines;
      default = "";
      description = ''
        Extra lines to be added verbatim to the generated configuration file.
      '';
    };
    listenPlain = mkOption {
      type = with types; listOf str;
      default = [ "[::1]:53" "127.0.0.1:53" ];
      example = [ "53" ];
      description = ''
        What addresses and ports the server should listen on.
        For detailed syntax see ListenStream in man systemd.socket.
      '';
    };
    listenTLS = mkOption {
      type = with types; listOf str;
      default = [];
      example = [ "198.51.100.1:853" "[2001:db8::1]:853" "853" ];
      description = ''
        Addresses and ports on which kresd should provide DNS over TLS (see RFC 7858).
        For detailed syntax see ListenStream in man systemd.socket.
      '';
    };
    listenDoH = mkOption {
      type = with types; listOf str;
      default = [];
      example = [ "198.51.100.1:443" "[2001:db8::1]:443" "443" ];
      description = ''
        Addresses and ports on which kresd should provide DNS over HTTPS (see RFC 8484).
        For detailed syntax see ListenStream in man systemd.socket.
      '';
    };
    instances = mkOption {
      type = types.ints.unsigned;
      default = 1;
      description = ''
        The number of instances to start.  They will be called kresd@{1,2,...}.service.
        Knot Resolver uses no threads, so this is the way to scale.
        You can dynamically start/stop them at will, so this is just system default.
      '';
    };
    # TODO: perhaps options for more common stuff like cache size or forwarding
  };

  ###### implementation
  config = mkIf cfg.enable {
    environment.etc."knot-resolver/kresd.conf".source = configFile; # not required

    users.users.knot-resolver =
      { isSystemUser = true;
        group = "knot-resolver";
        description = "Knot-resolver daemon user";
      };
    users.groups.knot-resolver.gid = null;

    systemd.packages = [ package ]; # the units are patched inside the package a bit

    systemd.targets.kresd = { # configure units started by default
      wantedBy = [ "multi-user.target" ];
      wants = [ "kres-cache-gc.service" ]
        ++ map (i: "kresd@${toString i}.service") (range 1 cfg.instances);
    };
    systemd.services."kresd@".serviceConfig = {
      ExecStart = "${package}/bin/kresd --noninteractive "
        + "-c ${package}/lib/knot-resolver/distro-preconfig.lua -c ${configFile}";
      # Ensure /run/knot-resolver exists
      RuntimeDirectory = "knot-resolver";
      RuntimeDirectoryMode = "0770";
      # Ensure /var/lib/knot-resolver exists
      StateDirectory = "knot-resolver";
      StateDirectoryMode = "0770";
      # Ensure /var/cache/knot-resolver exists
      CacheDirectory = "knot-resolver";
      CacheDirectoryMode = "0770";
    };

    # Try cleaning up the previously default location of cache file.
    # Note that /var/cache/* should always be safe to remove.
    # TODO: remove later, probably between 20.09 and 21.03
    systemd.tmpfiles.rules = [ "R /var/cache/kresd" ];
  };
}

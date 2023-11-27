{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.kresd;

  # Convert systemd-style address specification to kresd config line(s).
  # On Nix level we don't attempt to precisely validate the address specifications.
  # The optional IPv6 scope spec comes *after* port, perhaps surprisingly.
  mkListen = kind: addr: let
    al_v4 = builtins.match "([0-9.]+):([0-9]+)($)" addr;
    al_v6 = builtins.match "\\[(.+)]:([0-9]+)(%.*|$)" addr;
    al_portOnly = builtins.match "([0-9]+)" addr;
    al = findFirst (a: a != null)
      (throw "services.kresd.*: incorrect address specification '${addr}'")
      [ al_v4 al_v6 al_portOnly ];
    port = elemAt al 1;
    addrSpec = if al_portOnly == null then "'${head al}${elemAt al 2}'" else "{'::', '0.0.0.0'}";
    in # freebind is set for compatibility with earlier kresd services;
       # it could be configurable, for example.
      ''
        net.listen(${addrSpec}, ${port}, { kind = '${kind}', freebind = true })
      '';

  configFile = pkgs.writeText "kresd.conf" (
    ""
    + concatMapStrings (mkListen "dns") cfg.listenPlain
    + concatMapStrings (mkListen "tls") cfg.listenTLS
    + concatMapStrings (mkListen "doh2") cfg.listenDoH
    + cfg.extraConfig
  );
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
      description = lib.mdDoc ''
        Whether to enable knot-resolver domain name server.
        DNSSEC validation is turned on by default.
        You can run `sudo nc -U /run/knot-resolver/control/1`
        and give commands interactively to kresd@1.service.
      '';
    };
    package = mkPackageOption pkgs "knot-resolver" {
      example = "knot-resolver.override { extraFeatures = true; }";
    };
    extraConfig = mkOption {
      type = types.lines;
      default = "";
      description = lib.mdDoc ''
        Extra lines to be added verbatim to the generated configuration file.
      '';
    };
    listenPlain = mkOption {
      type = with types; listOf str;
      default = [ "[::1]:53" "127.0.0.1:53" ];
      example = [ "53" ];
      description = lib.mdDoc ''
        What addresses and ports the server should listen on.
        For detailed syntax see ListenStream in {manpage}`systemd.socket(5)`.
      '';
    };
    listenTLS = mkOption {
      type = with types; listOf str;
      default = [];
      example = [ "198.51.100.1:853" "[2001:db8::1]:853" "853" ];
      description = lib.mdDoc ''
        Addresses and ports on which kresd should provide DNS over TLS (see RFC 7858).
        For detailed syntax see ListenStream in {manpage}`systemd.socket(5)`.
      '';
    };
    listenDoH = mkOption {
      type = with types; listOf str;
      default = [];
      example = [ "198.51.100.1:443" "[2001:db8::1]:443" "443" ];
      description = lib.mdDoc ''
        Addresses and ports on which kresd should provide DNS over HTTPS/2 (see RFC 8484).
        For detailed syntax see ListenStream in {manpage}`systemd.socket(5)`.
      '';
    };
    instances = mkOption {
      type = types.ints.unsigned;
      default = 1;
      description = lib.mdDoc ''
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

    networking.resolvconf.useLocalResolver = mkDefault true;

    users.users.knot-resolver =
      { isSystemUser = true;
        group = "knot-resolver";
        description = "Knot-resolver daemon user";
      };
    users.groups.knot-resolver.gid = null;

    systemd.packages = [ cfg.package ]; # the units are patched inside the package a bit

    systemd.targets.kresd = { # configure units started by default
      wantedBy = [ "multi-user.target" ];
      wants = [ "kres-cache-gc.service" ]
        ++ map (i: "kresd@${toString i}.service") (range 1 cfg.instances);
    };
    systemd.services."kresd@".serviceConfig = {
      ExecStart = "${cfg.package}/bin/kresd --noninteractive "
        + "-c ${cfg.package}/lib/knot-resolver/distro-preconfig.lua -c ${configFile}";
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
    # We don't mind running stop phase from wrong version.  It seems less racy.
    systemd.services."kresd@".stopIfChanged = false;
  };
}

{ config, lib, pkgs, ... }:
let
  cfg = config.services.kresd;

  # TODO: partial override of defaults doesn't work,
  # but perhaps it will be OK as empty anyway?
  settings_default = { };

  withManager = true;
  manager = pkgs.knot-resolver-manager;

  # Convert systemd-style address specification to kresd config line(s).
  # On Nix level we don't attempt to precisely validate the address specifications.
  # The optional IPv6 scope spec comes *after* port, perhaps surprisingly.
  mkListen = kind: addr: let
    al_v4 = builtins.match "([0-9.]+):([0-9]+)($)" addr;
    al_v6 = builtins.match "\\[(.+)]:([0-9]+)(%.*|$)" addr;
    al_portOnly = builtins.match "(^)([0-9]+)" addr;
    al = lib.findFirst (a: a != null)
      (throw "services.kresd.*: incorrect address specification '${addr}'")
      [ al_v4 al_v6 al_portOnly ];
    port = lib.elemAt al 1;
    addrSpec = if al_portOnly == null then "'${lib.head al}${lib.elemAt al 2}'" else "{'::', '0.0.0.0'}";
    in # freebind is set for compatibility with earlier kresd services;
       # it could be configurable, for example.
      ''
        net.listen(${addrSpec}, ${port}, { kind = '${kind}', freebind = true })
      '';

    json-oneline = pkgs.writeTextFile {
      name = "kresd-oneline.json";
      text = builtins.toJSON cfg.settings;
    };
    # - use jq to get a pretty JSON
    # - then validate it, so that most errors get found during OS build (not activation)
    json = pkgs.runCommandLocal "kresd.json" {} ''
      '${pkgs.jq}/bin/jq' < '${json-oneline}' > "$out"
      '${manager}/bin/kresctl' validate --no-strict "$out"
    '';
    #*/

  configFile = if cfg.settings == settings_default
    then pkgs.writeText "kresd.lua" (
      ""
      + lib.concatMapStrings (mkListen "dns") cfg.listenPlain
      + lib.concatMapStrings (mkListen "tls") cfg.listenTLS
      + lib.concatMapStrings (mkListen "doh2") cfg.listenDoH
      + cfg.extraConfig
    )
    else let
      checks = cfg.extraConfig == ""; # FIXME: cfg.instances + cfg.listen*
      in assert checks; pkgs.runCommandLocal "kresd.lua" {} ''
        ${manager}/bin/kresctl convert --no-strict '${json}' "$out"
      '';
in {
  meta.maintainers = [ lib.maintainers.vcunat /* upstream developer */ ];

  imports = [
    (lib.mkChangedOptionModule [ "services" "kresd" "interfaces" ] [ "services" "kresd" "listenPlain" ]
      (config:
        let value = lib.getAttrFromPath [ "services" "kresd" "interfaces" ] config;
        in map
          (iface: if lib.elem ":" (lib.stringToCharacters iface) then "[${iface}]:53" else "${iface}:53") # Syntax depends on being IPv6 or IPv4.
          value
      )
    )
    (lib.mkRemovedOptionModule [ "services" "kresd" "cacheDir" ] "Please use (bind-)mounting instead.")
  ];

  ###### interface
  options.services.kresd = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Whether to enable knot-resolver domain name server.
        DNSSEC validation is turned on by default.
        You can run `sudo nc -U /run/knot-resolver/control/1`
        and give commands interactively to kresd@1.service.
      '';
    };
    package = lib.mkPackageOption pkgs "knot-resolver" {
      example = "knot-resolver.override { extraFeatures = true; }";
    };
    settings = lib.mkOption { # see RFC 42
      type = lib.types.submodule { # TODO: avoid regeneration of docs on config changes
        freeformType = (pkgs.formats.yaml {}).type;
      };
      default = settings_default;
      description = ''
        Highly experimental!!!
        Nix-based (RFC 42) configuration for Knot Resolver.

        FIXME many issues, e.g.:
         - old listen{Plain,TLS,DoH} config gets silently ignored

        <link xlink:href="https://example.com/docs/foo"/>
        for supported values.
      '';
    };
    extraConfig = lib.mkOption {
      type = lib.types.lines;
      default = "";
      description = ''
        Extra lines to be added verbatim to the generated configuration file.
      '';
    };
    listenPlain = lib.mkOption {
      type = with lib.types; listOf str;
      default = [ "[::1]:53" "127.0.0.1:53" ];
      example = [ "53" ];
      description = ''
        What addresses and ports the server should listen on.
        For detailed syntax see ListenStream in {manpage}`systemd.socket(5)`.
      '';
    };
    listenTLS = lib.mkOption {
      type = with lib.types; listOf str;
      default = [];
      example = [ "198.51.100.1:853" "[2001:db8::1]:853" "853" ];
      description = ''
        Addresses and ports on which kresd should provide DNS over TLS (see RFC 7858).
        For detailed syntax see ListenStream in {manpage}`systemd.socket(5)`.
      '';
    };
    listenDoH = lib.mkOption {
      type = with lib.types; listOf str;
      default = [];
      example = [ "198.51.100.1:443" "[2001:db8::1]:443" "443" ];
      description = ''
        Addresses and ports on which kresd should provide DNS over HTTPS/2 (see RFC 8484).
        For detailed syntax see ListenStream in {manpage}`systemd.socket(5)`.
      '';
    };
    instances = lib.mkOption {
      type = lib.types.ints.unsigned;
      default = 1;
      description = ''
        The number of instances to start.  They will be called kresd@{1,2,...}.service.
        Knot Resolver uses no threads, so this is the way to scale.
        You can dynamically start/stop them at will, so this is just system default.
      '';
    };
    # TODO: option to create tmpfs for cache?  (It's bad for disk on a busy resolver.)
  };

  ###### implementation
  config = lib.mkIf cfg.enable {
    environment.etc."knot-resolver/kresd.lua".source = configFile; # not required
    environment.etc."knot-resolver/kresd.json".source = json; # not required

    networking.resolvconf.useLocalResolver = lib.mkDefault true;

    users.users.knot-resolver =
      { isSystemUser = true;
        group = "knot-resolver";
        description = "Knot-resolver daemon user";
      };
    users.groups.knot-resolver.gid = null;

    #FIXME: ?conditionalize, reuse upstream unit & clean up, etc.
    systemd.services.knot-resolver.wantedBy = [ "multi-user.target" ]; # TODO: more
    systemd.services.knot-resolver.path = [ (lib.getBin cfg.package) ];
    systemd.services.knot-resolver.serviceConfig = {
      ExecStart = "${manager}/bin/knot-resolver --config=${json}";
      Environment = "KRES_LOGGING_TARGET=syslog";
      # Actually, it's unclear whether reloading will really be useful,
      # but why not fix it anyway.  (We'd need to recognize config-only changes.)
      ExecReload = "${manager}/bin/kresctl reload --config=${json}";

      Type = "notify";
      TimeoutStartSec = "10s";
      KillSignal = "SIGINT";
      WorkingDirectory = "/run/knot-resolver";
      User = "knot-resolver";
      Group = "knot-resolver";
      CapabilityBoundingSet = "CAP_NET_BIND_SERVICE CAP_SETPCAP";
      AmbientCapabilities   = "CAP_NET_BIND_SERVICE CAP_SETPCAP";

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
    systemd.services.knot-resolver.stopIfChanged = false;


    # TODO: also install shell completions, maybe man pages, etc.
    environment.systemPackages = [
      (pkgs.runCommandLocal "knot-resolver-cmds"
        { nativeBuildInputs = [ pkgs.makeWrapper ]; }
        # Wrapping, as config might've changed the location of the management socket.
        ''
          makeWrapper '${manager}/bin/kresctl' "$out/bin/kresctl" \
            --add-flags --config=${json}
        '')
    ];
  };
}

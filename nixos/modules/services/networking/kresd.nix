{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.kresd;

  # Convert systemd-style address specification to kresd config line(s).
  # On Nix level we don't attempt to precisely validate the address specifications.
  # The optional IPv6 scope spec comes *after* port, perhaps surprisingly.
  mkListen =
    kind: addr:
    let
      al_v4 = builtins.match "([0-9.]+):([0-9]+)($)" addr;
      al_v6 = builtins.match "\\[(.+)]:([0-9]+)(%.*|$)" addr;
      al_portOnly = builtins.match "(^)([0-9]+)" addr;
      al =
        lib.findFirst (a: a != null) (throw "services.kresd.*: incorrect address specification '${addr}'")
          [
            al_v4
            al_v6
            al_portOnly
          ];
      port = lib.elemAt al 1;
      addrSpec =
        if al_portOnly == null then "'${lib.head al}${lib.elemAt al 2}'" else "{'::', '0.0.0.0'}";
    in
    # freebind is set for compatibility with earlier kresd services;
    # it could be configurable, for example.
    ''
      net.listen(${addrSpec}, ${port}, { kind = '${kind}', freebind = true })
    '';

  configFile = pkgs.writeText "kresd.conf" (
    ""
    + lib.concatMapStrings (mkListen "dns") cfg.listenPlain
    + lib.concatMapStrings (mkListen "tls") cfg.listenTLS
    + lib.concatMapStrings (mkListen "doh2") cfg.listenDoH
    + cfg.extraConfig
  );
in
{
  meta.maintainers = [
    lib.maintainers.vcunat # upstream developer
  ];

  imports = [
    (lib.mkChangedOptionModule [ "services" "kresd" "interfaces" ] [ "services" "kresd" "listenPlain" ]
      (
        config:
        let
          value = lib.getAttrFromPath [ "services" "kresd" "interfaces" ] config;
        in
        map (iface: if lib.elem ":" (lib.stringToCharacters iface) then "[${iface}]:53" else "${iface}:53") # Syntax depends on being IPv6 or IPv4.
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
        You can run `kresd-cli 1` and give commands interactively to kresd@1.service.
      '';
    };
    package = lib.mkPackageOption pkgs "knot-resolver" {
      example = "knot-resolver.override { extraFeatures = true; }";
    };
    extraConfig = lib.mkOption {
      type = lib.types.lines;
      default = "";
      description = ''
        Extra lines to be added verbatim to the generated configuration file.
        See upstream documentation <https://www.knot-resolver.cz/documentation/stable/config-overview.html> for more details.
      '';
    };
    listenPlain = lib.mkOption {
      type = with lib.types; listOf str;
      default = [
        "[::1]:53"
        "127.0.0.1:53"
      ];
      example = [ "53" ];
      description = ''
        What addresses and ports the server should listen on.
        For detailed syntax see ListenStream in {manpage}`systemd.socket(5)`.
      '';
    };
    listenTLS = lib.mkOption {
      type = with lib.types; listOf str;
      default = [ ];
      example = [
        "198.51.100.1:853"
        "[2001:db8::1]:853"
        "853"
      ];
      description = ''
        Addresses and ports on which kresd should provide DNS over TLS (see RFC 7858).
        For detailed syntax see ListenStream in {manpage}`systemd.socket(5)`.
      '';
    };
    listenDoH = lib.mkOption {
      type = with lib.types; listOf str;
      default = [ ];
      example = [
        "198.51.100.1:443"
        "[2001:db8::1]:443"
        "443"
      ];
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
    # TODO: perhaps options for more common stuff like cache size or forwarding
  };

  ###### implementation
  config = lib.mkIf cfg.enable {
    environment = {
      etc."knot-resolver/kresd.conf".source = configFile; # not required
      systemPackages = [
        (pkgs.writeShellScriptBin "kresd-cli" ''
          if [[ ''${1:-} == -h || ''${1:-} == --help ]]; then
            echo "Usage: $0 [X]"
            echo
            echo "  X is number of the control socket and corresponds to the number of the template unit."
            exit
          fi

          exec=exec
          if [[ "$USER" != knot-resolver ]]; then
            exec='exec /run/wrappers/bin/sudo -u knot-resolver'
          fi
          $exec ${lib.getExe pkgs.socat} - /run/knot-resolver/control/''${1:-1}
        '')
      ];
    };

    networking.resolvconf.useLocalResolver = lib.mkDefault true;

    users.users.knot-resolver = {
      isSystemUser = true;
      group = "knot-resolver";
      description = "Knot-resolver daemon user";
    };
    users.groups.knot-resolver = { };

    systemd.packages = [ cfg.package ]; # the units are patched inside the package a bit

    systemd.targets.kresd = {
      # configure units started by default
      wantedBy = [ "multi-user.target" ];
      wants = [
        "kres-cache-gc.service"
      ]
      ++ map (i: "kresd@${toString i}.service") (lib.range 1 cfg.instances);
    };
    systemd.services."kresd@".serviceConfig = {
      ExecStart =
        "${cfg.package}/bin/kresd --noninteractive "
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

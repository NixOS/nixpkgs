{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib)
    mkEnableOption
    mkPackageOption
    mkIf
    mkOption
    recursiveUpdate
    optionalAttrs
    types
    ;

  cfg = config.networking.wireless.iwd;
  ini = pkgs.formats.ini { };
  defaults =
    with config.networking.networkmanager;
    optionalAttrs (enable && (wifi.backend == "iwd")) {
      # without DefaultInterface, sometimes wlan0 simply goes AWOL with NetworkManager
      # https://iwd.wiki.kernel.org/interface_lifecycle#interface_management_in_iwd
      DriverQuirks.DefaultInterface = "?*";
    };
  configFile = ini.generate "main.conf" (recursiveUpdate defaults cfg.settings);

  # A value as iwd's settings parser (ell) reads it back: backslash, newline and
  # carriage return are escaped anywhere, spaces and tabs only where they lead.
  # escapeSecret in writeKnownNetworks applies the same rules at runtime.
  escapeValue =
    value:
    let
      escaped = lib.replaceStrings [ "\\" "\n" "\r" ] [ "\\\\" "\\n" "\\r" ] value;
      lead = lib.head (builtins.match "([ \t]*).*" escaped);
    in
    lib.replaceStrings [ " " "\t" ] [ "\\s" "\\t" ] lead + lib.removePrefix lead escaped;

  # The values a network reads from a secret file, and the network's file with
  # a placeholder in place of each.
  secretsOf = network: lib.filter lib.isAttrs (lib.concatMap lib.attrValues (lib.attrValues network));
  placeholder = secret: "@secret-${builtins.hashString "sha256" (toString secret._secret)}@";
  networkTemplate =
    network:
    pkgs.writeText "iwd-network" (
      lib.generators.toINI {
        mkKeyValue =
          key: value:
          "${key}=${
            if lib.isAttrs value then
              placeholder value
            else if lib.isString value then
              escapeValue value
            else
              lib.generators.mkValueStringDefault { } value
          }";
      } network
    );

  # iwd's file name for a network, as a shell word: the SSID, or `=` and its
  # hex encoding when it holds anything but alphanumerics, spaces, `_` and `-`,
  # followed by the security type.
  networkFileName =
    ssid: network:
    let
      type =
        if network ? Security."EAP-Method" then
          "8021x"
        else if network ? Security then
          "psk"
        else
          "open";
    in
    if builtins.match "[A-Za-z0-9 _-]+" ssid != null then
      lib.escapeShellArg "${ssid}.${type}"
    # Nix cannot read the value of a non-ASCII byte, so the shell encodes it.
    else
      ''"=$(printf %s ${lib.escapeShellArg ssid} | od -An -v -tx1 | tr -d ' \n').${type}"'';

  writeNetwork =
    ssid: network:
    let
      secrets = secretsOf network;
      path = secret: lib.escapeShellArg (toString secret._secret);
      secretsReadable =
        if secrets == [ ] then
          "true"
        else
          lib.concatMapStringsSep " && " (secret: "[ -r ${path secret} ]") secrets;
    in
    ''
      name=${networkFileName ssid network}
      echo "$name" >>"$declared"
      if ${secretsReadable}; then
        content=$(<${networkTemplate network})
        ${lib.concatMapStrings (secret: ''
          value=$(escapeSecret "$(<${path secret})")
          content=''${content//${placeholder secret}/"$value"}
        '') secrets}
        tmp=$(mktemp /var/lib/iwd/.tmp.XXXXXX)
        printf '%s\n' "$content" >"$tmp"
        mv "$tmp" "/var/lib/iwd/$name"
      else
        echo ${lib.escapeShellArg "${ssid}: a secret file is missing, not written"} >&2
      fi
    '';

  # iwd reads a network's settings, secrets included, only from the network's
  # own file under /var/lib/iwd, so the declared networks are written there
  # before it starts. /var/lib/iwd/.declared lists the files written, so a
  # network removed from knownNetworks loses its file while networks added at
  # runtime are never touched.
  writeKnownNetworks = ''
    escapeSecret() {
      local value=$1 lead
      value=''${value//'\'/'\\'}
      value=''${value//$'\n'/'\n'}
      value=''${value//$'\r'/'\r'}
      lead=''${value%%[!$' \t']*}
      value=''${value#"$lead"}
      lead=''${lead//' '/'\s'}
      lead=''${lead//$'\t'/'\t'}
      printf '%s' "$lead$value"
    }

    trap 'rm -f /var/lib/iwd/.tmp.*' EXIT
    declared=$(mktemp /var/lib/iwd/.tmp.XXXXXX)
    ${lib.concatStrings (lib.mapAttrsToList writeNetwork cfg.knownNetworks)}
    if [ -f /var/lib/iwd/.declared ]; then
      while IFS= read -r name; do
        grep -qxF -- "$name" "$declared" || rm -f -- "/var/lib/iwd/$name"
      done </var/lib/iwd/.declared
    fi
    if [ -s "$declared" ]; then
      mv "$declared" /var/lib/iwd/.declared
    else
      rm -f "$declared" /var/lib/iwd/.declared
    fi
  '';

in
{
  options.networking.wireless.iwd = {
    enable = mkEnableOption "iwd";

    package = mkPackageOption pkgs "iwd" { };

    settings = mkOption {
      type = ini.type;
      default = { };

      example = {
        Settings.AutoConnect = true;

        Network = {
          EnableIPv6 = true;
          RoutePriorityOffset = 300;
        };
      };

      description = ''
        Options passed to iwd.
        See {manpage}`iwd.config(5)` for supported options.
      '';
    };

    knownNetworks = mkOption {
      type =
        let
          secret = types.submodule {
            options._secret = mkOption {
              type = types.pathWith {
                inStore = false;
                absolute = true;
              };
              description = "File holding the value itself, such as a plain passphrase.";
            };
          };
        in
        types.attrsOf (
          types.attrsOf (
            types.attrsOf (
              types.oneOf [
                types.bool
                types.int
                types.str
                secret
              ]
            )
          )
        );
      default = { };
      example = lib.literalExpression ''
        {
          "Home network" = {
            Security.Passphrase._secret = "/run/secrets/home-wifi";
            Settings.Hidden = true;
          };
          "Café".Settings.AutoConnect = false;
        }
      '';
      description = ''
        Networks iwd knows, keyed by SSID. Each takes the sections and keys of
        an iwd network file, see {manpage}`iwd.network(5)`. A `Security` section
        makes a network WPA-PSK or SAE, or 802.1X when it sets `EAP-Method`; a
        network without one is open.

        A value given as `{ _secret = "/path/to/file"; }` is read from that file
        each time iwd starts, so it never enters the Nix store. The file holds
        the value itself, such as the plain passphrase. A network whose secret
        file is missing is not written.

        The networks are written to {file}`/var/lib/iwd` before iwd starts. A
        network removed from this option has its file deleted; networks added at
        runtime, with {command}`iwctl` or a frontend, are left alone. Changes iwd
        makes to a declared network last until it next starts.
      '';
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = !config.networking.wireless.enable;
        message = ''
          Only one wireless daemon is allowed at the time: networking.wireless.enable and networking.wireless.iwd.enable are mutually exclusive.
        '';
      }
      {
        assertion = !(cfg.settings ? General && cfg.settings.General ? UseDefaultInterface);
        message = ''
          `networking.wireless.iwd.settings.General.UseDefaultInterface` has been deprecated. Use `networking.wireless.iwd.settings.DriverQuirks.DefaultInterface` instead.
        '';
      }
    ];

    environment.etc."iwd/${configFile.name}".source = configFile;

    # for iwctl
    environment.systemPackages = [ cfg.package ];

    services.dbus.packages = [ cfg.package ];

    systemd.packages = [ cfg.package ];

    systemd.network.links."80-iwd" = {
      matchConfig.Type = "wlan";
      linkConfig.NamePolicy = "keep kernel";
    };

    systemd.services.iwd = {
      path = [ config.networking.resolvconf.package ];
      wantedBy = [ "multi-user.target" ];
      restartTriggers = [ configFile ];
      preStart = writeKnownNetworks;
      serviceConfig.ReadWritePaths = "-/etc/resolv.conf";
    };
  };

  meta.maintainers = [ ];
}

{ options, config, pkgs, lib, ... }:

let
  inherit (lib) mkOption types mkIf;

  opt = options.services.quicktun;
  cfg = config.services.quicktun;
in
{
  options = {
    services.quicktun = mkOption {
      default = { };
      description = ''
        QuickTun tunnels.

        See <http://wiki.ucis.nl/QuickTun> for more information about available options.
      '';
      type = types.attrsOf (types.submodule ({ name, ... }: let
        qtcfg = cfg.${name};
      in {
        options = {
          tunMode = mkOption {
            type = with types; coercedTo bool (b: if b then 1 else 0) (ints.between 0 1);
            default = false;
            example = true;
            description = "Whether to operate in tun (IP) or tap (Ethernet) mode.";
          };

          remoteAddress = mkOption {
            type = types.str;
            default = "0.0.0.0";
            example = "tunnel.example.com";
            description = ''
              IP address or hostname of the remote end (use `0.0.0.0` for a floating/dynamic remote endpoint).
            '';
          };

          localAddress = mkOption {
            type = with types; nullOr str;
            default = null;
            example = "0.0.0.0";
            description = "IP address or hostname of the local end.";
          };

          localPort = mkOption {
            type = types.port;
            default = 2998;
            description = "Local UDP port.";
          };

          remotePort = mkOption {
            type = types.port;
            default = qtcfg.localPort;
            defaultText = lib.literalExpression "config.services.quicktun.<name>.localPort";
            description = " remote UDP port";
          };

          remoteFloat = mkOption {
            type = with types; coercedTo bool (b: if b then 1 else 0) (ints.between 0 1);
            default = false;
            example = true;
            description = ''
              Whether to allow the remote address and port to change when properly encrypted packets are received.
            '';
          };

          protocol = mkOption {
            type = types.enum [ "raw" "nacl0" "nacltai" "salty" ];
            default = "nacltai";
            description = "Which protocol to use.";
          };

          privateKey = mkOption {
            type = with types; nullOr str;
            default = null;
            description = ''
              Local secret key in hexadecimal form.

              ::: {.warning}
              This option is deprecated. Please use {var}`services.quicktun.<name>.privateKeyFile` instead.
              :::

              ::: {.note}
              Not needed when {var}`services.quicktun.<name>.protocol` is set to `raw`.
              :::
            '';
          };

          privateKeyFile = mkOption {
            type = with types; nullOr path;
            # This is a hack to deprecate `privateKey` without using `mkChangedModuleOption`
            default = if qtcfg.privateKey == null then null else pkgs.writeText "quickttun-key-${name}" qtcfg.privateKey;
            defaultText = "null";
            description = ''
              Path to file containing local secret key in binary or hexadecimal form.

              ::: {.note}
              Not needed when {var}`services.quicktun.<name>.protocol` is set to `raw`.
              :::
            '';
          };

          publicKey = mkOption {
            type = with types; nullOr str;
            default = null;
            description = ''
              Remote public key in hexadecimal form.

              ::: {.note}
              Not needed when {var}`services.quicktun.<name>.protocol` is set to `raw`.
              :::
            '';
          };

          timeWindow = mkOption {
            type = types.ints.unsigned;
            default = 5;
            description = ''
              Allowed time window for first received packet in seconds (positive number allows packets from history)
            '';
          };

          upScript = mkOption {
            type = with types; nullOr lines;
            default = null;
            description = ''
              Run specified command or script after the tunnel device has been opened.
            '';
          };
        };
      }));
    };
  };

  config = {
    warnings = lib.pipe cfg [
      (lib.mapAttrsToList (name: value: if value.privateKey != null then name else null))
      (builtins.filter (n: n != null))
      (map (n: "  - services.quicktun.${n}.privateKey"))
      (services: lib.optional (services != [ ]) ''
        `services.quicktun.<name>.privateKey` is deprecated.
        Please use `services.quicktun.<name>.privateKeyFile` instead.

        Offending options:
        ${lib.concatStringsSep "\n" services}
      '')
    ];

    systemd.services = lib.mkMerge (
      lib.mapAttrsToList (name: qtcfg: {
        "quicktun-${name}" = {
          wantedBy = [ "multi-user.target" ];
          after = [ "network.target" ];
          environment = {
            INTERFACE = name;
            TUN_MODE = toString qtcfg.tunMode;
            REMOTE_ADDRESS = qtcfg.remoteAddress;
            LOCAL_ADDRESS = mkIf (qtcfg.localAddress != null) (qtcfg.localAddress);
            LOCAL_PORT = toString qtcfg.localPort;
            REMOTE_PORT = toString qtcfg.remotePort;
            REMOTE_FLOAT = toString qtcfg.remoteFloat;
            PRIVATE_KEY_FILE = mkIf (qtcfg.privateKeyFile != null) qtcfg.privateKeyFile;
            PUBLIC_KEY = mkIf (qtcfg.publicKey != null) qtcfg.publicKey;
            TIME_WINDOW = toString qtcfg.timeWindow;
            TUN_UP_SCRIPT = mkIf (qtcfg.upScript != null) (pkgs.writeScript "quicktun-${name}-up.sh" qtcfg.upScript);
            SUID = "nobody";
          };
          serviceConfig = {
            Type = "simple";
            ExecStart = "${pkgs.quicktun}/bin/quicktun.${qtcfg.protocol}";
          };
        };
      }) cfg
    );
  };
}

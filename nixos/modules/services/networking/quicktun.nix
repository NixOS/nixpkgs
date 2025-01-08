{
  options,
  config,
  pkgs,
  lib,
  ...
}:

let
  opt = options.services.quicktun;
  cfg = config.services.quicktun;
in
{
  options = {
    services.quicktun = lib.mkOption {
      default = { };
      description = ''
        QuickTun tunnels.

        See <http://wiki.ucis.nl/QuickTun> for more information about available options.
      '';
      type = lib.types.attrsOf (
        lib.types.submodule (
          { name, ... }:
          let
            qtcfg = cfg.${name};
          in
          {
            options = {
              tunMode = lib.mkOption {
                type = with lib.types; coercedTo bool (b: if b then 1 else 0) (ints.between 0 1);
                default = false;
                example = true;
                description = "Whether to operate in tun (IP) or tap (Ethernet) mode.";
              };

              remoteAddress = lib.mkOption {
                type = lib.types.str;
                default = "0.0.0.0";
                example = "tunnel.example.com";
                description = ''
                  IP address or hostname of the remote end (use `0.0.0.0` for a floating/dynamic remote endpoint).
                '';
              };

              localAddress = lib.mkOption {
                type = with lib.types; nullOr str;
                default = null;
                example = "0.0.0.0";
                description = "IP address or hostname of the local end.";
              };

              localPort = lib.mkOption {
                type = lib.types.port;
                default = 2998;
                description = "Local UDP port.";
              };

              remotePort = lib.mkOption {
                type = lib.types.port;
                default = qtcfg.localPort;
                defaultText = lib.literalExpression "config.services.quicktun.<name>.localPort";
                description = " remote UDP port";
              };

              remoteFloat = lib.mkOption {
                type = with lib.types; coercedTo bool (b: if b then 1 else 0) (ints.between 0 1);
                default = false;
                example = true;
                description = ''
                  Whether to allow the remote address and port to change when properly encrypted packets are received.
                '';
              };

              protocol = lib.mkOption {
                type = lib.types.enum [
                  "raw"
                  "nacl0"
                  "nacltai"
                  "salty"
                ];
                default = "nacltai";
                description = "Which protocol to use.";
              };

              privateKey = lib.mkOption {
                type = with lib.types; nullOr str;
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

              privateKeyFile = lib.mkOption {
                type = with lib.types; nullOr path;
                # This is a hack to deprecate `privateKey` without using `mkChangedModuleOption`
                default =
                  if qtcfg.privateKey == null then null else pkgs.writeText "quickttun-key-${name}" qtcfg.privateKey;
                defaultText = "null";
                description = ''
                  Path to file containing local secret key in binary or hexadecimal form.

                  ::: {.note}
                  Not needed when {var}`services.quicktun.<name>.protocol` is set to `raw`.
                  :::
                '';
              };

              publicKey = lib.mkOption {
                type = with lib.types; nullOr str;
                default = null;
                description = ''
                  Remote public key in hexadecimal form.

                  ::: {.note}
                  Not needed when {var}`services.quicktun.<name>.protocol` is set to `raw`.
                  :::
                '';
              };

              timeWindow = lib.mkOption {
                type = lib.types.ints.unsigned;
                default = 5;
                description = ''
                  Allowed time window for first received packet in seconds (positive number allows packets from history)
                '';
              };

              upScript = lib.mkOption {
                type = with lib.types; nullOr lines;
                default = null;
                description = ''
                  Run specified command or script after the tunnel device has been opened.
                '';
              };
            };
          }
        )
      );
    };
  };

  config = {
    warnings = lib.pipe cfg [
      (lib.mapAttrsToList (name: value: if value.privateKey != null then name else null))
      (builtins.filter (n: n != null))
      (map (n: "  - services.quicktun.${n}.privateKey"))
      (
        services:
        lib.optional (services != [ ]) ''
          `services.quicktun.<name>.privateKey` is deprecated.
          Please use `services.quicktun.<name>.privateKeyFile` instead.

          Offending options:
          ${lib.concatStringsSep "\n" services}
        ''
      )
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
            LOCAL_ADDRESS = lib.mkIf (qtcfg.localAddress != null) (qtcfg.localAddress);
            LOCAL_PORT = toString qtcfg.localPort;
            REMOTE_PORT = toString qtcfg.remotePort;
            REMOTE_FLOAT = toString qtcfg.remoteFloat;
            PRIVATE_KEY_FILE = lib.mkIf (qtcfg.privateKeyFile != null) qtcfg.privateKeyFile;
            PUBLIC_KEY = lib.mkIf (qtcfg.publicKey != null) qtcfg.publicKey;
            TIME_WINDOW = toString qtcfg.timeWindow;
            TUN_UP_SCRIPT = lib.mkIf (qtcfg.upScript != null) (
              pkgs.writeScript "quicktun-${name}-up.sh" qtcfg.upScript
            );
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

{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.services.xonotic;

  serverCfg = pkgs.writeText "xonotic-server.cfg" (
    toString cfg.prependConfig
    + "\n"
    + builtins.concatStringsSep "\n" (
      lib.mapAttrsToList (
        key: option:
        let
          escape = s: lib.escape [ "\"" ] s;
          quote = s: "\"${s}\"";

          toValue = x: quote (escape (toString x));

          value = (
            if lib.isList option then
              builtins.concatStringsSep " " (builtins.map (x: toValue x) option)
            else
              toValue option
          );
        in
        "${key} ${value}"
      ) cfg.settings
    )
    + "\n"
    + toString cfg.appendConfig
  );
in

{
  options.services.xonotic = {
    enable = lib.mkEnableOption "Xonotic dedicated server";

    package = lib.mkPackageOption pkgs "xonotic-dedicated" { };

    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Open the firewall for TCP and UDP on the specified port.
      '';
    };

    dataDir = lib.mkOption {
      type = lib.types.path;
      readOnly = true;
      default = "/var/lib/xonotic";
      description = ''
        Data directory.
      '';
    };

    settings = lib.mkOption {
      description = ''
        Generates the `server.cfg` file. Refer to [upstream's example][0] for
        details.

        [0]: https://gitlab.com/xonotic/xonotic/-/blob/master/server/server.cfg
      '';
      default = { };
      type = lib.types.submodule {
        freeformType =
          with lib.types;
          let
            scalars = oneOf [
              singleLineStr
              int
              float
            ];
          in
          attrsOf (oneOf [
            scalars
            (nonEmptyListOf scalars)
          ]);

        options.sv_public = lib.mkOption {
          type = lib.types.int;
          default = 0;
          example = [
            (-1)
            1
          ];
          description = ''
            Controls whether the server will be publicly listed.
          '';
        };

        options.hostname = lib.mkOption {
          type = lib.types.singleLineStr;
          default = "Xonotic $g_xonoticversion Server";
          description = ''
            The name that will appear in the server list. `$g_xonoticversion`
            gets replaced with the current version.
          '';
        };

        options.sv_motd = lib.mkOption {
          type = lib.types.singleLineStr;
          default = "";
          description = ''
            Text displayed when players join the server.
          '';
        };

        options.sv_termsofservice_url = lib.mkOption {
          type = lib.types.singleLineStr;
          default = "";
          description = ''
            URL for the Terms of Service for playing on your server.
          '';
        };

        options.maxplayers = lib.mkOption {
          type = lib.types.int;
          default = 16;
          description = ''
            Number of player slots on the server, including spectators.
          '';
        };

        options.net_address = lib.mkOption {
          type = lib.types.singleLineStr;
          default = "0.0.0.0";
          description = ''
            The address Xonotic will listen on.
          '';
        };

        options.port = lib.mkOption {
          type = lib.types.port;
          default = 26000;
          description = ''
            The port Xonotic will listen on.
          '';
        };
      };
    };

    # Still useful even though we're using RFC 42 settings because *some* keys
    # can be repeated.
    appendConfig = lib.mkOption {
      type = with lib.types; nullOr lines;
      default = null;
      description = ''
        Literal text to insert at the end of `server.cfg`.
      '';
    };

    # Certain changes need to happen at the beginning of the file.
    prependConfig = lib.mkOption {
      type = with lib.types; nullOr lines;
      default = null;
      description = ''
        Literal text to insert at the start of `server.cfg`.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.xonotic = {
      description = "Xonotic server";
      wantedBy = [ "multi-user.target" ];

      environment = {
        # Required or else it tries to write the lock file into the nix store
        HOME = cfg.dataDir;
      };

      serviceConfig = {
        DynamicUser = true;
        User = "xonotic";
        StateDirectory = "xonotic";
        ExecStart = "${cfg.package}/bin/xonotic-dedicated";

        # Symlink the configuration from the nix store to where Xonotic actually
        # looks for it
        ExecStartPre = [
          "${pkgs.coreutils}/bin/mkdir -p ${cfg.dataDir}/.xonotic/data"
          ''
            ${pkgs.coreutils}/bin/ln -sf ${serverCfg} \
              ${cfg.dataDir}/.xonotic/data/server.cfg
          ''
        ];

        # Cargo-culted from search results about writing Xonotic systemd units
        ExecReload = "${pkgs.util-linux}/bin/kill -HUP $MAINPID";

        Restart = "on-failure";
        RestartSec = 10;
      };
      unitConfig = {
        StartLimitBurst = 5;
      };
    };

    networking.firewall.allowedTCPPorts = lib.mkIf cfg.openFirewall [
      cfg.settings.port
    ];
    networking.firewall.allowedUDPPorts = lib.mkIf cfg.openFirewall [
      cfg.settings.port
    ];
  };

  meta.maintainers = with lib.maintainers; [ CobaltCause ];
}

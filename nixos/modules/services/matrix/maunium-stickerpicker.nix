{ pkgs, lib, config, options, ...}:
let
  cfg = config.services.maunium-stickerpicker;

  sticker-import = pkgs.writeShellScriptBin "sticker-import" ''
      ${pkgs.maunium-stickerpicker}/bin/sticker-import $@ \
      --config ${cfg.dataDir}/config.json \
      --output-dir ${cfg.dataDir}/packs \
      --session ${cfg.dataDir}/tgsession.session
  '';

  sticker-pack = pkgs.writeShellScriptBin "sticker-pack" ''
      ${pkgs.maunium-stickerpicker}/bin/sticker-pack $@ \
      --config ${cfg.dataDir}/config.json \
  '';

  sticker-update = pkgs.writeShellScriptBin "sticker-update" ''
      packs=$(${pkgs.jq}/bin/jq -r .packs.[] ${cfg.dataDir}/packs/index.json)
      for pack in $packs
      do
        ${sticker-import}/bin/sticker-import $pack
      done
  '';
in
{
  options.services.maunium-stickerpicker = with lib; {
    enable = mkEnableOption (mdDoc "Maunium sticker picker, a Matrix stickerpicker widget");

    homeserver_url = mkOption {
      type = types.str;
      description = mdDoc ''
        The matrix server to which stickers are uploaded
      '';
    };

    auto_update = mkOption {
      type = types.bool;
      description = mdDoc ''
        Enables a systemd service which periodically updates the imported packs
      '';
      default = false;
    };

    auto_update_interval = mkOption {
      type = types.str;
      description = mdDoc ''
        The how often imported stickerpacks are refreshed.
      '';
      default = "7d";
    };

    access_token_path = mkOption {
      type = types.path;
      description = mdDoc ''
        File containing the app access token for your matrix account
      '';
    };

    dataDir = mkOption {
      type = types.str;
      default = "/var/lib/maunium-stickerpicker";
      description = mdDoc ''
        The directory where stickerpicker stores its stateful data
      '';
    };

    user = mkOption {
      type = types.str;
      default = "maunium-stickerpicker";
      description = mdDoc ''
        The user which under which the service runs
      '';
    };

    addr = mkOption {
      type = types.str;
      default = "[::1]";
      description = mdDoc ''
        Address where the stickerpicker widget listens for connections
      '';
    };

    port = mkOption {
      type = types.int;
      default = 8009;
      description = mdDoc ''
        Port where the stickerpicker widget listens for connections
      '';
    };

    http_server = mkOption {
      type = types.bool;
      default = true;
      description = mdDoc ''
        Enables a http server for hosting the widget
      '';
    };
  };

  config = lib.mkIf config.services.maunium-stickerpicker.enable ( lib.mkMerge [
    # Check if the user we want to run as already exists
    (lib.mkIf (!builtins.hasAttr cfg.user options.users.users) {
      users.users."${cfg.user}" = {
        group = cfg.user;
        home = cfg.dataDir;
        isSystemUser = true;
      };
      users.groups."${cfg.user}" = { };
    })
    # Periodically fetch new stickers from the telegram servers
    (lib.mkIf cfg.auto_update {
      systemd.timers."maunium-stickerpicker-update" = {
        wantedBy = [ "timers.target" ];
        timerConfig = {
          OnBootSec = cfg.auto_update_interval;
          OnUnitActiveSec = cfg.auto_update_interval;
          Unit = "maunium-stickerpicker-update.service";
        };
      };

      systemd.services."maunium-stickerpicker-update" = {
        serviceConfig = {
          Type = "oneshot";
          User = cfg.user;
          ExecStart = "${sticker-update}/bin/sticker-update";
        };
      };
    })
    (lib.mkIf cfg.http_server {
      services.nginx = {
        enable = true;
        user = cfg.user;
        recommendedOptimisation = true;
        virtualHosts."maunium-stickerpicker" = {
          root = "${cfg.dataDir}/web";
          listen = [{port = cfg.port; addr = cfg.addr;}];
        };
      };
    })
    ({
      environment.systemPackages = [ sticker-import sticker-update sticker-pack ];

      systemd.services.maunium-stickerpicker = {
        wantedBy = [ "multi-user.target" ];
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = "yes";

          ProtectSystem = "strict";
          ProtectHome = true;
          ProtectKernelTunables = true;
          ProtectKernelModules = true;
          ProtectControlGroups = true;

          User = cfg.user;
          Group = cfg.user;
          WorkingDirectory = cfg.dataDir;
          StateDirectory = baseNameOf cfg.dataDir;
          StateDirectoryMode = "770";
          UMask = "007";
        };

        script = ''
          mkdir -p ${cfg.dataDir}/{web,packs}
          ln -sf ${pkgs.maunium-stickerpicker}/web/* ${cfg.dataDir}/web

          chmod g+s ${cfg.dataDir}/packs

          # Maintain a stateful directory containing the sticker json index
          rm ${cfg.dataDir}/web/packs
          ln -sf ${cfg.dataDir}/packs ${cfg.dataDir}/web/packs

          # Ensures that the telethon session db has the correct permissions
          touch ${cfg.dataDir}/tgsession.session

          # We do not want secrets in the nix store
          ${pkgs.nix}/bin/nix-instantiate --eval --json --strict --expr \
          '{
            access_token = (builtins.readFile ${cfg.access_token_path});
            homeserver = ${cfg.homeserver_url};
          }' > ${cfg.dataDir}/config.json
        '';
      };
    })
]);
}

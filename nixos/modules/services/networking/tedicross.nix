{ config, pkgs, lib, ... }:

with lib;

let
  dataDir = "/var/lib/tedicross";
  cfg = config.services.tedicross;
  configJSON = pkgs.writeText "tedicross-settings.json" (builtins.toJSON cfg.config);
  configYAML = pkgs.runCommand "tedicross-settings.yaml" { preferLocalBuild = true; } ''
    ${pkgs.remarshal}/bin/json2yaml -i ${configJSON} -o $out
  '';

in {
  options = {
    services.tedicross = {
      enable = mkEnableOption "the TediCross Telegram-Discord bridge service";

      config = mkOption {
        type = types.attrs;
        # from https://github.com/TediCross/TediCross/blob/master/example.settings.yaml
        example = literalExample ''
          {
            telegram = {
              useFirstNameInsteadOfUsername = false;
              colonAfterSenderName = false;
              skipOldMessages = true;
              sendEmojiWithStickers = true;
            };
            discord = {
              useNickname = false;
              skipOldMessages = true;
              displayTelegramReplies = "embed";
              replyLength = 100;
            };
            bridges = [
              {
                name = "Default bridge";
                direction = "both";
                telegram = {
                  chatId = -123456789;
                  relayJoinMessages = true;
                  relayLeaveMessages = true;
                  sendUsernames = true;
                  ignoreCommands = true;
                };
                discord = {
                  serverId = "DISCORD_SERVER_ID";
                  channelId = "DISCORD_CHANNEL_ID";
                  relayJoinMessages = true;
                  relayLeaveMessages = true;
                  sendUsernames = true;
                  crossDeleteOnTelegram = true;
                };
              }
            ];

            debug = false;
          }
        '';
        description = ''
          <filename>settings.yaml</filename> configuration as a Nix attribute set.
          Secret tokens should be specified using <option>environmentFile</option>
          instead of this world-readable file.
        '';
      };

      environmentFile = mkOption {
        type = types.nullOr types.path;
        default = null;
        description = ''
          File containing environment variables to be passed to the TediCross service,
          in which secret tokens can be specified securely using the
          <literal>TELEGRAM_BOT_TOKEN</literal> and <literal>DISCORD_BOT_TOKEN</literal>
          keys.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    # from https://github.com/TediCross/TediCross/blob/master/guides/autostart/Linux.md
    systemd.services.tedicross = {
      description = "TediCross Telegram-Discord bridge service";
      wantedBy = [ "multi-user.target" ];
      wants = [ "network-online.target" ];
      after = [ "network-online.target" ];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.nodePackages.tedicross}/bin/tedicross --config='${configYAML}' --data-dir='${dataDir}'";
        Restart = "always";
        DynamicUser = true;
        StateDirectory = baseNameOf dataDir;
        EnvironmentFile = cfg.environmentFile;
      };
    };
  };

  meta.maintainers = with maintainers; [ pacien ];
}


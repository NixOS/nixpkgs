{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.smtp-to-telegram;

in

{
  meta = {
    maintainers = with maintainers; [ patryk27 ];
  };

  ###### interface

  options = {
    services.smtp-to-telegram = {
      enable = mkEnableOption "SMTP server that forwards messages to Telegram";

      package = mkOption {
        type = types.package;
        default = pkgs.smtp-to-telegram;
        defaultText = "pkgs.smtp-to-telegram";
        description = "Which smtp-to-telegram derivation to use.";
      };

      messageTemplate = mkOption {
        type = types.str;
        default = "From: {from}\\nTo: {to}\\nSubject: {subject}\\n\\n{body}";
        description = ''
          Template used to convert e-mails into Telegram messages.

          Available variables:
          <literal>from</literal>,
          <literal>to</literal>,
          <literal>subject</literal>,
          <literal>body</literal>.
        '';
      };

      smtpListen = mkOption {
        type = types.str;
        default = "127.0.0.1:2525";
        description = "Address at which the SMTP server will be listening.";
      };

      smtpPrimaryHost = mkOption {
        type = types.str;
        default = config.networking.hostName;
        description = "Hostname at which the SMTP server will be listening.";
      };

      telegramApiPrefix = mkOption {
        type = types.str;
        default = "https://api.telegram.org/";
        description = "Telegram API's URL; must end with a slash.";
      };

      telegramBotToken = mkOption {
        type = types.str;
        default = "";
        description = ''
          Your bot's token; required.

          Please see <link xlink:href="https://core.telegram.org/bots">https://core.telegram.org/bots</link> for more details.
        '';
      };

      telegramChatIds = mkOption {
        type = types.listOf types.str;
        default = [];
        description = ''
          Your chat's id; required.

          Please see <link xlink:href="https://core.telegram.org/bots">https://core.telegram.org/bots</link> for more details.
        '';
      };
    };
  };

  ###### implementation

  config = mkIf config.services.smtp-to-telegram.enable {
    assertions = [
      {
        assertion = cfg.telegramBotToken != "";
        message = "`config.services.smtp-to-telegram.telegramBotToken` cannot be empty";
      }
      {
        assertion = cfg.telegramChatIds != [];
        message = "`config.services.smtp-to-telegram.telegramChatIds` cannot be empty";
      }
    ];

    systemd.services.smtp-to-telegram = {
      description = "smtp-to-telegram server";

      script = ''
        ${cfg.package}/bin/smtp_to_telegram \
          --message-template "${cfg.messageTemplate}" \
          --smtp-listen "${cfg.smtpListen}" \
          --smtp-primary-host "${cfg.smtpPrimaryHost}" \
          --telegram-api-prefix "${cfg.telegramApiPrefix}" \
          --telegram-bot-token "${cfg.telegramBotToken}" \
          --telegram-chat-ids "${concatStringsSep "," cfg.telegramChatIds}"
      '';

      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
    };
  };
}

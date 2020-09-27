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
      enable = mkEnableOption (lib.mdDoc "SMTP server that forwards messages to Telegram");

      package = mkOption {
        type = types.package;
        default = pkgs.smtp-to-telegram;
        defaultText = lib.literalMD "pkgs.smtp-to-telegram";
        description = lib.mdDoc "Which smtp-to-telegram derivation to use.";
      };

      messageTemplate = mkOption {
        type = types.str;
        default = "From: {from}\\nTo: {to}\\nSubject: {subject}\\n\\n{body}\\n\\n{attachments_details}";
        description = lib.mdDoc ''
          Template used to convert e-mails into Telegram messages.

          Available variables: `from`, `to`, `subject`, `body`, `attachments_details`.
        '';
      };

      smtpListen = mkOption {
        type = types.str;
        default = "127.0.0.1:2525";
        description = lib.mdDoc "Address at which the SMTP server will be listening.";
      };

      smtpPrimaryHost = mkOption {
        type = types.str;
        default = config.networking.hostName;
        defaultText = literalExpression "config.networking.hostName";
        description = lib.mdDoc "Hostname at which the SMTP server will be listening.";
      };

      telegramApiPrefix = mkOption {
        type = types.str;
        default = "https://api.telegram.org/";
        description = lib.mdDoc "Telegram API's URL; must end with a slash.";
      };

      telegramBotTokenFile = mkOption {
        type = types.str;
        default = "";
        description = lib.mdDoc ''
          An absolute file path (outside of Nix-store) to a secret file containing your bot's token; required.

          Please see <https://core.telegram.org> for more details.
        '';
      };

      telegramChatIds = mkOption {
        type = types.listOf types.str;
        default = [ ];
        description = lib.mdDoc ''
          Your chat's id; required.

          Please see <https://core.telegram.org> for more details.
        '';
      };
    };
  };

  ###### implementation

  config = mkIf config.services.smtp-to-telegram.enable {
    assertions = [
      {
        assertion = cfg.telegramBotTokenFile != "";
        message = "`config.services.smtp-to-telegram.telegramBotTokenFile` cannot be empty";
      }
      {
        assertion = cfg.telegramChatIds != [ ];
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
          --telegram-bot-token "$(${pkgs.coreutils}/bin/cat ${cfg.telegramBotTokenFile})" \
          --telegram-chat-ids "${concatStringsSep "," cfg.telegramChatIds}"
      '';

      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
    };
  };
}

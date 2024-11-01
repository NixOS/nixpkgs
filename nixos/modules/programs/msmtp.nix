{ config, lib, pkgs, ... }:

let
  cfg = config.programs.msmtp;

in {
  meta.maintainers = with lib.maintainers; [ pacien ];

  options = {
    programs.msmtp = {
      enable = lib.mkEnableOption "msmtp - an SMTP client";

      setSendmail = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = ''
          Whether to set the system sendmail to msmtp's.
        '';
      };

      defaults = lib.mkOption {
        type = lib.types.attrs;
        default = {};
        example = {
          aliases = "/etc/aliases";
          port = 587;
          tls = true;
        };
        description = ''
          Default values applied to all accounts.
          See msmtp(1) for the available options.
        '';
      };

      accounts = lib.mkOption {
        type = with lib.types; attrsOf attrs;
        default = {};
        example = {
          "default" = {
            host = "smtp.example";
            auth = true;
            user = "someone";
            passwordeval = "cat /secrets/password.txt";
          };
        };
        description = ''
          Named accounts and their respective configurations.
          The special name "default" allows a default account to be defined.
          See msmtp(1) for the available options.

          Use `programs.msmtp.extraConfig` instead of this attribute set-based
          option if ordered account inheritance is needed.

          It is advised to use the `passwordeval` setting to read the password
          from a secret file to avoid having it written in the world-readable
          nix store. The password file must end with a newline (`\n`).
        '';
      };

      extraConfig = lib.mkOption {
        type = lib.types.lines;
        default = "";
        description = ''
          Extra lines to add to the msmtp configuration verbatim.
          See msmtp(1) for the syntax and available options.
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ pkgs.msmtp ];

    services.mail.sendmailSetuidWrapper = lib.mkIf cfg.setSendmail {
      program = "sendmail";
      source = "${pkgs.msmtp}/bin/sendmail";
      setuid = false;
      setgid = false;
      owner = "root";
      group = "root";
    };

    environment.etc."msmtprc".text = let
      mkValueString = v:
        if v == true then "on"
        else if v == false then "off"
        else lib.generators.mkValueStringDefault {} v;
      mkKeyValueString = k: v: "${k} ${mkValueString v}";
      mkInnerSectionString =
        attrs: builtins.concatStringsSep "\n" (lib.mapAttrsToList mkKeyValueString attrs);
      mkAccountString = name: attrs: ''
        account ${name}
        ${mkInnerSectionString attrs}
      '';
    in ''
      defaults
      ${mkInnerSectionString cfg.defaults}

      ${builtins.concatStringsSep "\n" (lib.mapAttrsToList mkAccountString cfg.accounts)}

      ${cfg.extraConfig}
    '';
  };
}

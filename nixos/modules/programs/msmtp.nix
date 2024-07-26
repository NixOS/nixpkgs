{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.programs.msmtp;

in {
  meta.maintainers = with maintainers; [ pacien ];

  options = {
    programs.msmtp = {
      enable = mkEnableOption (lib.mdDoc "msmtp - an SMTP client");

      setSendmail = mkOption {
        type = types.bool;
        default = true;
        description = lib.mdDoc ''
          Whether to set the system sendmail to msmtp's.
        '';
      };

      defaults = mkOption {
        type = types.attrs;
        default = {};
        example = {
          aliases = "/etc/aliases";
          port = 587;
          tls = true;
        };
        description = lib.mdDoc ''
          Default values applied to all accounts.
          See msmtp(1) for the available options.
        '';
      };

      accounts = mkOption {
        type = with types; attrsOf attrs;
        default = {};
        example = {
          "default" = {
            host = "smtp.example";
            auth = true;
            user = "someone";
            passwordeval = "cat /secrets/password.txt";
          };
        };
        description = lib.mdDoc ''
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

      extraConfig = mkOption {
        type = types.lines;
        default = "";
        description = lib.mdDoc ''
          Extra lines to add to the msmtp configuration verbatim.
          See msmtp(1) for the syntax and available options.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.msmtp ];

    services.mail.sendmailSetuidWrapper = mkIf cfg.setSendmail {
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
        else generators.mkValueStringDefault {} v;
      mkKeyValueString = k: v: "${k} ${mkValueString v}";
      mkInnerSectionString =
        attrs: concatStringsSep "\n" (mapAttrsToList mkKeyValueString attrs);
      mkAccountString = name: attrs: ''
        account ${name}
        ${mkInnerSectionString attrs}
      '';
    in ''
      defaults
      ${mkInnerSectionString cfg.defaults}

      ${concatStringsSep "\n" (mapAttrsToList mkAccountString cfg.accounts)}

      ${cfg.extraConfig}
    '';
  };
}

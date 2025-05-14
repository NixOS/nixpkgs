{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.certspotter;

  configDir = pkgs.linkFarm "certspotter-config" (
    lib.toList {
      name = "watchlist";
      path = pkgs.writeText "certspotter-watchlist" (builtins.concatStringsSep "\n" cfg.watchlist);
    }
    ++ lib.optional (cfg.emailRecipients != [ ]) {
      name = "email_recipients";
      path = pkgs.writeText "certspotter-email_recipients" (
        builtins.concatStringsSep "\n" cfg.emailRecipients
      );
    }
    # always generate hooks dir when no emails are provided to allow running cert spotter with no hooks/emails
    ++ lib.optional (cfg.emailRecipients == [ ] || cfg.hooks != [ ]) {
      name = "hooks.d";
      path = pkgs.linkFarm "certspotter-hooks" (
        lib.imap1 (i: path: {
          inherit path;
          name = "hook${toString i}";
        }) cfg.hooks
      );
    }
  );
in
{
  options.services.certspotter = {
    enable = lib.mkEnableOption "Cert Spotter, a Certificate Transparency log monitor";

    package = lib.mkPackageOption pkgs "certspotter" { };

    startAtEnd = lib.mkOption {
      type = lib.types.bool;
      description = ''
        Whether to skip certificates issued before the first launch of Cert Spotter.
        Setting this to `false` will cause Cert Spotter to download tens of terabytes of data.
      '';
      default = true;
    };

    sendmailPath = lib.mkOption {
      type = with lib.types; nullOr path;
      description = ''
        Path to the `sendmail` binary. By default, the local sendmail wrapper is used
        (see {option}`services.mail.sendmailSetuidWrapper`}).
      '';
      example = lib.literalExpression ''"''${pkgs.system-sendmail}/bin/sendmail"'';
    };

    watchlist = lib.mkOption {
      type = with lib.types; listOf str;
      description = "Domain names to watch. To monitor a domain with all subdomains, prefix its name with `.` (e.g. `.example.org`).";
      default = [ ];
      example = [
        ".example.org"
        "another.example.com"
      ];
    };

    emailRecipients = lib.mkOption {
      type = with lib.types; listOf str;
      description = "A list of email addresses to send certificate updates to.";
      default = [ ];
    };

    hooks = lib.mkOption {
      type = with lib.types; listOf path;
      description = ''
        Scripts to run upon the detection of a new certificate. See `man 8 certspotter-script` or
        [the GitHub page](https://github.com/SSLMate/certspotter/blob/${
          pkgs.certspotter.src.rev or "master"
        }/man/certspotter-script.md)
        for more info.
      '';
      default = [ ];
      example = lib.literalExpression ''
        [
          (pkgs.writeShellScript "certspotter-hook" '''
            echo "Event summary: $SUMMARY."
          ''')
        ]
      '';
    };

    extraFlags = lib.mkOption {
      type = with lib.types; listOf str;
      description = "Extra command-line arguments to pass to Cert Spotter";
      example = [ "-no_save" ];
      default = [ ];
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = (cfg.emailRecipients != [ ]) -> (cfg.sendmailPath != null);
        message = ''
          You must configure the sendmail setuid wrapper (services.mail.sendmailSetuidWrapper)
          or services.certspotter.sendmailPath
        '';
      }
    ];

    services.certspotter.sendmailPath =
      let
        inherit (config.security) wrapperDir;
        inherit (config.services.mail) sendmailSetuidWrapper;
      in
      lib.mkMerge [
        (lib.mkIf (sendmailSetuidWrapper != null) (
          lib.mkOptionDefault "${wrapperDir}/${sendmailSetuidWrapper.program}"
        ))
        (lib.mkIf (sendmailSetuidWrapper == null) (lib.mkOptionDefault null))
      ];

    users.users.certspotter = {
      description = "Cert Spotter user";
      group = "certspotter";
      home = "/var/lib/certspotter";
      isSystemUser = true;
    };
    users.groups.certspotter = { };

    systemd.services.certspotter = {
      description = "Cert Spotter - Certificate Transparency Monitor";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      environment.CERTSPOTTER_CONFIG_DIR = configDir;
      environment.SENDMAIL_PATH =
        if cfg.sendmailPath != null then cfg.sendmailPath else "/run/current-system/sw/bin/false";
      script = ''
        export CERTSPOTTER_STATE_DIR="$STATE_DIRECTORY"
        cd "$CERTSPOTTER_STATE_DIR"
        ${lib.optionalString cfg.startAtEnd ''
          if [[ ! -d logs ]]; then
            # Don't download certificates issued before the first launch
            exec ${cfg.package}/bin/certspotter -start_at_end ${lib.escapeShellArgs cfg.extraFlags}
          fi
        ''}
        exec ${cfg.package}/bin/certspotter ${lib.escapeShellArgs cfg.extraFlags}
      '';
      serviceConfig = {
        User = "certspotter";
        Group = "certspotter";
        StateDirectory = "certspotter";
      };
    };
  };

  meta.maintainers = with lib.maintainers; [ chayleaf ];
  meta.doc = ./certspotter.md;
}

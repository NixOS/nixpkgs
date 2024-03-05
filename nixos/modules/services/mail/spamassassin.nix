{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.spamassassin;
  spamassassin-local-cf = pkgs.writeText "local.cf" cfg.config;

in

{
  options = {

    services.spamassassin = {
      enable = mkEnableOption (lib.mdDoc "the SpamAssassin daemon");

      debug = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc "Whether to run the SpamAssassin daemon in debug mode";
      };

      config = mkOption {
        type = types.lines;
        description = lib.mdDoc ''
          The SpamAssassin local.cf config

          If you are using this configuration:

              add_header all Status _YESNO_, score=_SCORE_ required=_REQD_ tests=_TESTS_ autolearn=_AUTOLEARN_ version=_VERSION_

          Then you can Use this sieve filter:

              require ["fileinto", "reject", "envelope"];

              if header :contains "X-Spam-Flag" "YES" {
                fileinto "spam";
              }

          Or this procmail filter:

              :0:
              * ^X-Spam-Flag: YES
              /var/vpopmail/domains/lastlog.de/js/.maildir/.spam/new

          To filter your messages based on the additional mail headers added by spamassassin.
        '';
        example = ''
          #rewrite_header Subject [***** SPAM _SCORE_ *****]
          required_score          5.0
          use_bayes               1
          bayes_auto_learn        1
          add_header all Status _YESNO_, score=_SCORE_ required=_REQD_ tests=_TESTS_ autolearn=_AUTOLEARN_ version=_VERSION_
        '';
        default = "";
      };

      initPreConf = mkOption {
        type = with types; either str path;
        description = lib.mdDoc "The SpamAssassin init.pre config.";
        apply = val: if builtins.isPath val then val else pkgs.writeText "init.pre" val;
        default =
        ''
          #
          # to update this list, run this command in the rules directory:
          # grep 'loadplugin.*Mail::SpamAssassin::Plugin::.*' -o -h * | sort | uniq
          #

          #loadplugin Mail::SpamAssassin::Plugin::AccessDB
          #loadplugin Mail::SpamAssassin::Plugin::AntiVirus
          loadplugin Mail::SpamAssassin::Plugin::AskDNS
          # loadplugin Mail::SpamAssassin::Plugin::ASN
          loadplugin Mail::SpamAssassin::Plugin::AutoLearnThreshold
          #loadplugin Mail::SpamAssassin::Plugin::AWL
          loadplugin Mail::SpamAssassin::Plugin::Bayes
          loadplugin Mail::SpamAssassin::Plugin::BodyEval
          loadplugin Mail::SpamAssassin::Plugin::Check
          #loadplugin Mail::SpamAssassin::Plugin::DCC
          loadplugin Mail::SpamAssassin::Plugin::DKIM
          loadplugin Mail::SpamAssassin::Plugin::DMARC
          loadplugin Mail::SpamAssassin::Plugin::DNSEval
          loadplugin Mail::SpamAssassin::Plugin::FreeMail
          loadplugin Mail::SpamAssassin::Plugin::HeaderEval
          loadplugin Mail::SpamAssassin::Plugin::HTMLEval
          loadplugin Mail::SpamAssassin::Plugin::HTTPSMismatch
          loadplugin Mail::SpamAssassin::Plugin::ImageInfo
          loadplugin Mail::SpamAssassin::Plugin::MIMEEval
          loadplugin Mail::SpamAssassin::Plugin::MIMEHeader
          # loadplugin Mail::SpamAssassin::Plugin::PDFInfo
          #loadplugin Mail::SpamAssassin::Plugin::PhishTag
          loadplugin Mail::SpamAssassin::Plugin::Pyzor
          loadplugin Mail::SpamAssassin::Plugin::Razor2
          # loadplugin Mail::SpamAssassin::Plugin::RelayCountry
          loadplugin Mail::SpamAssassin::Plugin::RelayEval
          loadplugin Mail::SpamAssassin::Plugin::ReplaceTags
          # loadplugin Mail::SpamAssassin::Plugin::Rule2XSBody
          # loadplugin Mail::SpamAssassin::Plugin::Shortcircuit
          loadplugin Mail::SpamAssassin::Plugin::SpamCop
          loadplugin Mail::SpamAssassin::Plugin::SPF
          #loadplugin Mail::SpamAssassin::Plugin::TextCat
          # loadplugin Mail::SpamAssassin::Plugin::TxRep
          loadplugin Mail::SpamAssassin::Plugin::URIDetail
          loadplugin Mail::SpamAssassin::Plugin::URIDNSBL
          loadplugin Mail::SpamAssassin::Plugin::URIEval
          # loadplugin Mail::SpamAssassin::Plugin::URILocalBL
          loadplugin Mail::SpamAssassin::Plugin::VBounce
          loadplugin Mail::SpamAssassin::Plugin::WhiteListSubject
          loadplugin Mail::SpamAssassin::Plugin::WLBLEval
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    environment.etc."mail/spamassassin/init.pre".source = cfg.initPreConf;
    environment.etc."mail/spamassassin/local.cf".source = spamassassin-local-cf;

    # Allow users to run 'spamc'.
    environment.systemPackages = [ pkgs.spamassassin ];

    users.users.spamd = {
      description = "Spam Assassin Daemon";
      uid = config.ids.uids.spamd;
      group = "spamd";
    };

    users.groups.spamd = {
      gid = config.ids.gids.spamd;
    };

    systemd.services.sa-update = {
      # Needs to be able to contact the update server.
      wants = [ "network-online.target" ];
      after = [ "network-online.target" ];

      serviceConfig = {
        Type = "oneshot";
        User = "spamd";
        Group = "spamd";
        StateDirectory = "spamassassin";
        ExecStartPost = "+${config.systemd.package}/bin/systemctl -q --no-block try-reload-or-restart spamd.service";
      };

      script = ''
        set +e
        ${pkgs.spamassassin}/bin/sa-update --verbose --gpghomedir=/var/lib/spamassassin/sa-update-keys/
        rc=$?
        set -e

        if [[ $rc -gt 1 ]]; then
          # sa-update failed.
          exit $rc
        fi

        if [[ $rc -eq 1 ]]; then
          # No update was available, exit successfully.
          exit 0
        fi

        # An update was available and installed. Compile the rules.
        ${pkgs.spamassassin}/bin/sa-compile
      '';
    };

    systemd.timers.sa-update = {
      description = "sa-update-service";
      partOf      = [ "sa-update.service" ];
      wantedBy    = [ "timers.target" ];
      timerConfig = {
        OnCalendar = "1:*";
        Persistent = true;
      };
    };

    systemd.services.spamd = {
      description = "SpamAssassin Server";

      wantedBy = [ "multi-user.target" ];
      wants = [ "sa-update.service" ];
      after = [
        "network.target"
        "sa-update.service"
      ];

      serviceConfig = {
        User = "spamd";
        Group = "spamd";
        ExecStart = "+${pkgs.spamassassin}/bin/spamd ${optionalString cfg.debug "-D"} --username=spamd --groupname=spamd --virtual-config-dir=%S/spamassassin/user-%u --allow-tell --pidfile=/run/spamd.pid";
        ExecReload = "+${pkgs.coreutils}/bin/kill -HUP $MAINPID";
        StateDirectory = "spamassassin";
      };
    };
  };
}

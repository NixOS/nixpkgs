{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.spamassassin;
  spamassassin-local-cf = pkgs.writeText "local.cf" cfg.config;

  spamdEnv = pkgs.buildEnv {
    name = "spamd-env";
    paths = [];
    postBuild = ''
      ln -sf ${spamassassin-init-pre} $out/init.pre
      ln -sf ${spamassassin-local-cf} $out/local.cf
    '';
  };

in

{
  options = {

    services.spamassassin = {
      enable = mkOption {
        default = false;
        description = "Whether to run the SpamAssassin daemon";
      };

      debug = mkOption {
        default = false;
        description = "Whether to run the SpamAssassin daemon in debug mode";
      };

      config = mkOption {
        type = types.lines;
        description = ''
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
        description = "The SpamAssassin init.pre config.";
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
          loadplugin Mail::SpamAssassin::Plugin::DNSEval
          loadplugin Mail::SpamAssassin::Plugin::FreeMail
          loadplugin Mail::SpamAssassin::Plugin::Hashcash
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

    # Allow users to run 'spamc'.

    environment = {
      etc.spamassassin.source = spamdEnv;
      systemPackages = [ pkgs.spamassassin ];
    };

    users.users.spamd = {
      description = "Spam Assassin Daemon";
      uid = config.ids.uids.spamd;
      group = "spamd";
    };

    users.groups.spamd = {
      gid = config.ids.gids.spamd;
    };

    systemd.services.sa-update = {
      script = ''
        set +e
        ${pkgs.su}/bin/su -s "${pkgs.bash}/bin/bash" -c "${pkgs.spamassassin}/bin/sa-update --gpghomedir=/var/lib/spamassassin/sa-update-keys/ --siteconfigpath=${spamdEnv}/" spamd

        v=$?
        set -e
        if [ $v -gt 1 ]; then
          echo "sa-update execution error"
          exit $v
        fi
        if [ $v -eq 0 ]; then
          systemctl reload spamd.service
        fi
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
      description = "Spam Assassin Server";

      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];

      serviceConfig = {
        ExecStart = "${pkgs.spamassassin}/bin/spamd ${optionalString cfg.debug "-D"} --username=spamd --groupname=spamd --siteconfigpath=${spamdEnv} --virtual-config-dir=/var/lib/spamassassin/user-%u --allow-tell --pidfile=/run/spamd.pid";
        ExecReload = "${pkgs.coreutils}/bin/kill -HUP $MAINPID";
      };

      # 0 and 1 no error, exitcode > 1 means error:
      # https://spamassassin.apache.org/full/3.1.x/doc/sa-update.html#exit_codes
      preStart = ''
        echo "Recreating '/var/lib/spamasassin' with creating '3.004001' (or similar) and 'sa-update-keys'"
        mkdir -p /var/lib/spamassassin
        chown spamd:spamd /var/lib/spamassassin -R
        set +e
        ${pkgs.su}/bin/su -s "${pkgs.bash}/bin/bash" -c "${pkgs.spamassassin}/bin/sa-update --gpghomedir=/var/lib/spamassassin/sa-update-keys/ --siteconfigpath=${spamdEnv}/" spamd
        v=$?
        set -e
        if [ $v -gt 1 ]; then
          echo "sa-update execution error"
          exit $v
        fi
        chown spamd:spamd /var/lib/spamassassin -R
      '';
    };
  };
}

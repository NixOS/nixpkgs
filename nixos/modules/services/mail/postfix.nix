{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.postfix;
  user = cfg.user;
  group = cfg.group;
  setgidGroup = cfg.setgidGroup;

  haveAliases = cfg.postmasterAlias != "" || cfg.rootAlias != "" || cfg.extraAliases != "";
  haveTransport = cfg.transport != "";
  haveVirtual = cfg.virtual != "";

  mainCf =
    ''
      compatibility_level = 2

      mail_owner = ${user}
      default_privs = nobody

    ''
    + optionalString config.networking.enableIPv6 ''
      inet_protocols = all
    ''
    + (if cfg.networks != null then
        ''
          mynetworks = ${concatStringsSep ", " cfg.networks}
        ''
      else if cfg.networksStyle != "" then
        ''
          mynetworks_style = ${cfg.networksStyle}
        ''
      else
        "")
    + optionalString (cfg.hostname != "") ''
      myhostname = ${cfg.hostname}
    ''
    + optionalString (cfg.domain != "") ''
      mydomain = ${cfg.domain}
    ''
    + optionalString (cfg.origin != "") ''
      myorigin = ${cfg.origin}
    ''
    + optionalString (cfg.destination != null) ''
      mydestination = ${concatStringsSep ", " cfg.destination}
    ''
    + optionalString (cfg.relayDomains != null) ''
      relay_domains = ${concatStringsSep ", " cfg.relayDomains}
    ''
    + ''
      local_recipient_maps =

      relayhost = ${if cfg.lookupMX || cfg.relayHost == "" then
          cfg.relayHost
        else
          "[" + cfg.relayHost + "]"}

      mail_spool_directory = /var/spool/mail/

      setgid_group = ${setgidGroup}
    ''
    + optionalString (cfg.sslCert != "") ''

      smtp_tls_CAfile = ${cfg.sslCACert}
      smtp_tls_cert_file = ${cfg.sslCert}
      smtp_tls_key_file = ${cfg.sslKey}

      smtp_use_tls = yes

      smtpd_tls_CAfile = ${cfg.sslCACert}
      smtpd_tls_cert_file = ${cfg.sslCert}
      smtpd_tls_key_file = ${cfg.sslKey}

      smtpd_use_tls = yes
    ''
    + optionalString (cfg.recipientDelimiter != "") ''
      recipient_delimiter = ${cfg.recipientDelimiter}
    ''
    + optionalString haveAliases ''
      alias_maps = hash:/etc/postfix/aliases
    ''
    + optionalString haveTransport ''
      transport_maps = hash:/etc/postfix/transport
    ''
    + optionalString haveVirtual ''
      virtual_alias_maps = hash:/etc/postfix/virtual
    ''
    + cfg.extraConfig;

  masterCf = ''
    # ==========================================================================
    # service type  private unpriv  chroot  wakeup  maxproc command + args
    #               (yes)   (yes)   (no)    (never) (100)
    # ==========================================================================
    smtp      inet  n       -       n       -       -       smtpd
    #submission inet n       -       n       -       -       smtpd
    #  -o smtpd_tls_security_level=encrypt
    #  -o smtpd_sasl_auth_enable=yes
    #  -o smtpd_client_restrictions=permit_sasl_authenticated,reject
    #  -o milter_macro_daemon_name=ORIGINATING
    pickup    unix  n       -       n       60      1       pickup
    cleanup   unix  n       -       n       -       0       cleanup
    qmgr      unix  n       -       n       300     1       qmgr
    tlsmgr    unix  -       -       n       1000?   1       tlsmgr
    rewrite   unix  -       -       n       -       -       trivial-rewrite
    bounce    unix  -       -       n       -       0       bounce
    defer     unix  -       -       n       -       0       bounce
    trace     unix  -       -       n       -       0       bounce
    verify    unix  -       -       n       -       1       verify
    flush     unix  n       -       n       1000?   0       flush
    proxymap  unix  -       -       n       -       -       proxymap
    proxywrite unix -       -       n       -       1       proxymap
  ''
  + optionalString cfg.enableSmtp ''
    smtp      unix  -       -       n       -       -       smtp
    relay     unix  -       -       n       -       -       smtp
    	      -o smtp_fallback_relay=
    #       -o smtp_helo_timeout=5 -o smtp_connect_timeout=5
  ''
  + ''
    showq     unix  n       -       n       -       -       showq
    error     unix  -       -       n       -       -       error
    retry     unix  -       -       n       -       -       error
    discard   unix  -       -       n       -       -       discard
    local     unix  -       n       n       -       -       local
    virtual   unix  -       n       n       -       -       virtual
    lmtp      unix  -       -       n       -       -       lmtp
    anvil     unix  -       -       n       -       1       anvil
    scache    unix  -       -       n       -       1       scache
    ${cfg.extraMasterConf}
  '';

  aliases =
    optionalString (cfg.postmasterAlias != "") ''
      postmaster: ${cfg.postmasterAlias}
    ''
    + optionalString (cfg.rootAlias != "") ''
      root: ${cfg.rootAlias}
    ''
    + cfg.extraAliases
  ;

  aliasesFile = pkgs.writeText "postfix-aliases" aliases;
  virtualFile = pkgs.writeText "postfix-virtual" cfg.virtual;
  mainCfFile = pkgs.writeText "postfix-main.cf" mainCf;
  masterCfFile = pkgs.writeText "postfix-master.cf" masterCf;
  transportFile = pkgs.writeText "postfix-transport" cfg.transport;

in

{

  ###### interface

  options = {

    services.postfix = {

      enable = mkOption {
        type = types.bool;
        default = false;
        description = "Whether to run the Postfix mail server.";
      };

      enableSmtp = mkOption {
        default = true;
        description = "Whether to enable smtp in master.cf.";
      };

      setSendmail = mkOption {
        type = types.bool;
        default = true;
        description = "Whether to set the system sendmail to postfix's.";
      };

      user = mkOption {
        type = types.str;
        default = "postfix";
        description = "What to call the Postfix user (must be used only for postfix).";
      };

      group = mkOption {
        type = types.str;
        default = "postfix";
        description = "What to call the Postfix group (must be used only for postfix).";
      };

      setgidGroup = mkOption {
        type = types.str;
        default = "postdrop";
        description = "
          How to call postfix setgid group (for postdrop). Should
          be uniquely used group.
        ";
      };

      networks = mkOption {
        type = types.nullOr (types.listOf types.str);
        default = null;
        example = ["192.168.0.1/24"];
        description = "
          Net masks for trusted - allowed to relay mail to third parties -
          hosts. Leave empty to use mynetworks_style configuration or use
          default (localhost-only).
        ";
      };

      networksStyle = mkOption {
        type = types.str;
        default = "";
        description = "
          Name of standard way of trusted network specification to use,
          leave blank if you specify it explicitly or if you want to use
          default (localhost-only).
        ";
      };

      hostname = mkOption {
        type = types.str;
        default = "";
        description ="
          Hostname to use. Leave blank to use just the hostname of machine.
          It should be FQDN.
        ";
      };

      domain = mkOption {
        type = types.str;
        default = "";
        description ="
          Domain to use. Leave blank to use hostname minus first component.
        ";
      };

      origin = mkOption {
        type = types.str;
        default = "";
        description ="
          Origin to use in outgoing e-mail. Leave blank to use hostname.
        ";
      };

      destination = mkOption {
        type = types.nullOr (types.listOf types.str);
        default = null;
        example = ["localhost"];
        description = "
          Full (!) list of domains we deliver locally. Leave blank for
          acceptable Postfix default.
        ";
      };

      relayDomains = mkOption {
        type = types.nullOr (types.listOf types.str);
        default = null;
        example = ["localdomain"];
        description = "
          List of domains we agree to relay to. Default is empty.
        ";
      };

      relayHost = mkOption {
        type = types.str;
        default = "";
        description = "
          Mail relay for outbound mail.
        ";
      };

      lookupMX = mkOption {
        type = types.bool;
        default = false;
        description = "
          Whether relay specified is just domain whose MX must be used.
        ";
      };

      postmasterAlias = mkOption {
        type = types.str;
        default = "root";
        description = "Who should receive postmaster e-mail.";
      };

      rootAlias = mkOption {
        type = types.str;
        default = "";
        description = "
          Who should receive root e-mail. Blank for no redirection.
        ";
      };

      extraAliases = mkOption {
        type = types.lines;
        default = "";
        description = "
          Additional entries to put verbatim into aliases file, cf. man-page aliases(8).
        ";
      };

      extraConfig = mkOption {
        type = types.str;
        default = "";
        description = "
          Extra lines to be added verbatim to the main.cf configuration file.
        ";
      };

      sslCert = mkOption {
        type = types.str;
        default = "";
        description = "SSL certificate to use.";
      };

      sslCACert = mkOption {
        type = types.str;
        default = "";
        description = "SSL certificate of CA.";
      };

      sslKey = mkOption {
        type = types.str;
        default = "";
        description = "SSL key to use.";
      };

      recipientDelimiter = mkOption {
        type = types.str;
        default = "";
        example = "+";
        description = "
          Delimiter for address extension: so mail to user+test can be handled by ~user/.forward+test
        ";
      };

      virtual = mkOption {
        type = types.lines;
        default = "";
        description = "
          Entries for the virtual alias map, cf. man-page virtual(8).
        ";
      };

      transport = mkOption {
        default = "";
        description = "
          Entries for the transport map, cf. man-page transport(8).
        ";
      };

      extraMasterConf = mkOption {
        type = types.lines;
        default = "";
        example = "submission inet n - n - - smtpd";
        description = "Extra lines to append to the generated master.cf file.";
      };

      aliasFiles = mkOption {
        type = types.attrsOf types.path;
        default = {};
        description = "Aliases' tables to be compiled and placed into /var/lib/postfix/conf.";
      };

      mapFiles = mkOption {
        type = types.attrsOf types.path;
        default = {};
        description = "Maps to be compiled and placed into /var/lib/postfix/conf.";
      };

    };

  };


  ###### implementation

  config = mkIf config.services.postfix.enable (mkMerge [
    {

      environment = {
        etc = singleton
          { source = "/var/lib/postfix/conf";
            target = "postfix";
          };

        # This makes comfortable for root to run 'postqueue' for example.
        systemPackages = [ pkgs.postfix ];
      };

      services.mail.sendmailSetuidWrapper = mkIf config.services.postfix.setSendmail {
        program = "sendmail";
        source = "${pkgs.postfix}/bin/sendmail";
        group = setgidGroup;
        setuid = false;
        setgid = true;
      };

      users.extraUsers = optional (user == "postfix")
        { name = "postfix";
          description = "Postfix mail server user";
          uid = config.ids.uids.postfix;
          group = group;
        };

      users.extraGroups =
        optional (group == "postfix")
        { name = group;
          gid = config.ids.gids.postfix;
        }
        ++ optional (setgidGroup == "postdrop")
        { name = setgidGroup;
          gid = config.ids.gids.postdrop;
        };

      systemd.services.postfix =
        { description = "Postfix mail server";

          wantedBy = [ "multi-user.target" ];
          after = [ "network.target" ];
          path = [ pkgs.postfix ];

          serviceConfig = {
            Type = "forking";
            Restart = "always";
            PIDFile = "/var/lib/postfix/queue/pid/master.pid";
            ExecStart = "${pkgs.postfix}/bin/postfix start";
            ExecStop = "${pkgs.postfix}/bin/postfix stop";
            ExecReload = "${pkgs.postfix}/bin/postfix reload";
          };

          preStart = ''
            # Backwards compatibility
            if [ ! -d /var/lib/postfix ] && [ -d /var/postfix ]; then
              mkdir -p /var/lib
              mv /var/postfix /var/lib/postfix
            fi
            mkdir -p /var/lib/postfix/data /var/lib/postfix/queue/{pid,public,maildrop}

            chown -R ${user}:${group} /var/lib/postfix
            chown root /var/lib/postfix/queue
            chown root /var/lib/postfix/queue/pid
            chgrp -R ${setgidGroup} /var/lib/postfix/queue/{public,maildrop}
            chmod 770 /var/lib/postfix/queue/{public,maildrop}

            rm -rf /var/lib/postfix/conf
            mkdir -p /var/lib/postfix/conf
            ln -sf ${mainCfFile} /var/lib/postfix/conf/main.cf
            ln -sf ${masterCfFile} /var/lib/postfix/conf/master.cf
            ${concatStringsSep "\n" (mapAttrsToList (to: from: ''
              ln -sf ${from} /var/lib/postfix/conf/${to}
              postalias /var/lib/postfix/conf/${to}
            '') cfg.aliasFiles)}
            ${concatStringsSep "\n" (mapAttrsToList (to: from: ''
              ln -sf ${from} /var/lib/postfix/conf/${to}
              postmap /var/lib/postfix/conf/${to}
            '') cfg.mapFiles)}

            mkdir -p /var/spool/mail
            chown root:root /var/spool/mail
            chmod a+rwxt /var/spool/mail
            ln -sf /var/spool/mail /var/
          '';
        };
    }

    (mkIf haveAliases {
      services.postfix.aliasFiles."aliases" = aliasesFile;
    })
    (mkIf haveTransport {
      services.postfix.mapFiles."transport" = transportFile;
    })
    (mkIf haveVirtual {
      services.postfix.mapFiles."virtual" = virtualFile;
    })
  ]);

}

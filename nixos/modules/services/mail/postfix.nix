{
  config,
  lib,
  pkgs,
  ...
}:
let

  cfg = config.services.postfix;
  user = cfg.user;
  group = cfg.group;
  setgidGroup = cfg.setgidGroup;

  haveAliases = cfg.postmasterAlias != "" || cfg.rootAlias != "" || cfg.extraAliases != "";
  haveCanonical = cfg.canonical != "";
  haveTransport = cfg.transport != "";
  haveVirtual = cfg.virtual != "";
  haveLocalRecipients = cfg.localRecipients != null;

  clientAccess = lib.optional (
    cfg.dnsBlacklistOverrides != ""
  ) "check_client_access hash:/etc/postfix/client_access";

  dnsBl = lib.optionals (cfg.dnsBlacklists != [ ]) (
    map (s: "reject_rbl_client " + s) cfg.dnsBlacklists
  );

  clientRestrictions = lib.concatStringsSep ", " (clientAccess ++ dnsBl);

  mainCf =
    let
      escape = lib.replaceStrings [ "$" ] [ "$$" ];
      mkList = items: "\n  " + lib.concatStringsSep ",\n  " items;
      mkVal =
        value:
        if lib.isList value then
          mkList value
        else
          " "
          + (
            if value == true then
              "yes"
            else if value == false then
              "no"
            else
              toString value
          );
      mkEntry = name: value: "${escape name} =${mkVal value}";
    in
    lib.concatStringsSep "\n" (lib.mapAttrsToList mkEntry cfg.config) + "\n" + cfg.extraConfig;

  masterCfOptions =
    {
      options,
      config,
      name,
      ...
    }:
    {
      options = {
        name = lib.mkOption {
          type = lib.types.str;
          default = name;
          example = "smtp";
          description = ''
            The name of the service to run. Defaults to the attribute set key.
          '';
        };

        type = lib.mkOption {
          type = lib.types.enum [
            "inet"
            "unix"
            "unix-dgram"
            "fifo"
            "pass"
          ];
          default = "unix";
          example = "inet";
          description = "The type of the service";
        };

        private = lib.mkOption {
          type = lib.types.bool;
          example = false;
          description = ''
            Whether the service's sockets and storage directory is restricted to
            be only available via the mail system. If `null` is
            given it uses the postfix default `true`.
          '';
        };

        privileged = lib.mkOption {
          type = lib.types.bool;
          example = true;
          description = "";
        };

        chroot = lib.mkOption {
          type = lib.types.bool;
          example = true;
          description = ''
            Whether the service is chrooted to have only access to the
            {option}`services.postfix.queueDir` and the closure of
            store paths specified by the {option}`program` option.
          '';
        };

        wakeup = lib.mkOption {
          type = lib.types.int;
          example = 60;
          description = ''
            Automatically wake up the service after the specified number of
            seconds. If `0` is given, never wake the service
            up.
          '';
        };

        wakeupUnusedComponent = lib.mkOption {
          type = lib.types.bool;
          example = false;
          description = ''
            If set to `false` the component will only be woken
            up if it is used. This is equivalent to postfix' notion of adding a
            question mark behind the wakeup time in
            {file}`master.cf`
          '';
        };

        maxproc = lib.mkOption {
          type = lib.types.int;
          example = 1;
          description = ''
            The maximum number of processes to spawn for this service. If the
            value is `0` it doesn't have any limit. If
            `null` is given it uses the postfix default of
            `100`.
          '';
        };

        command = lib.mkOption {
          type = lib.types.str;
          default = name;
          example = "smtpd";
          description = ''
            A program name specifying a Postfix service/daemon process.
            By default it's the attribute {option}`name`.
          '';
        };

        args = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [ ];
          example = [
            "-o"
            "smtp_helo_timeout=5"
          ];
          description = ''
            Arguments to pass to the {option}`command`. There is no shell
            processing involved and shell syntax is passed verbatim to the
            process.
          '';
        };

        rawEntry = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [ ];
          internal = true;
          description = ''
            The raw configuration line for the {file}`master.cf`.
          '';
        };
      };

      config.rawEntry =
        let
          mkBool = bool: if bool then "y" else "n";
          mkArg = arg: "${lib.optionalString (lib.hasPrefix "-" arg) "\n  "}${arg}";

          maybeOption = fun: option: if options.${option}.isDefined then fun config.${option} else "-";

          # This is special, because we have two options for this value.
          wakeup =
            let
              wakeupDefined = options.wakeup.isDefined;
              wakeupUCDefined = options.wakeupUnusedComponent.isDefined;
              finalValue =
                toString config.wakeup + lib.optionalString (wakeupUCDefined && !config.wakeupUnusedComponent) "?";
            in
            if wakeupDefined then finalValue else "-";

        in
        [
          config.name
          config.type
          (maybeOption mkBool "private")
          (maybeOption (b: mkBool (!b)) "privileged")
          (maybeOption mkBool "chroot")
          wakeup
          (maybeOption toString "maxproc")
          (config.command + " " + lib.concatMapStringsSep " " mkArg config.args)
        ];
    };

  masterCfContent =
    let

      labels = [
        "# service"
        "type"
        "private"
        "unpriv"
        "chroot"
        "wakeup"
        "maxproc"
        "command + args"
      ];

      labelDefaults = [
        "# "
        ""
        "(yes)"
        "(yes)"
        "(no)"
        "(never)"
        "(100)"
        ""
        ""
      ];

      masterCf = lib.mapAttrsToList (lib.const (lib.getAttr "rawEntry")) cfg.masterConfig;

      # A list of the maximum width of the columns across all lines and labels
      maxWidths =
        let
          foldLine =
            line: acc:
            let
              columnLengths = map lib.stringLength line;
            in
            lib.zipListsWith lib.max acc columnLengths;
          # We need to handle the last column specially here, because it's
          # open-ended (command + args).
          lines = [
            labels
            labelDefaults
          ] ++ (map (l: lib.init l ++ [ "" ]) masterCf);
        in
        lib.foldr foldLine (lib.genList (lib.const 0) (lib.length labels)) lines;

      # Pad a string with spaces from the right (opposite of fixedWidthString).
      pad =
        width: str:
        let
          padWidth = width - lib.stringLength str;
          padding = lib.concatStrings (lib.genList (lib.const " ") padWidth);
        in
        str + lib.optionalString (padWidth > 0) padding;

      # It's + 2 here, because that's the amount of spacing between columns.
      fullWidth = lib.foldr (width: acc: acc + width + 2) 0 maxWidths;

      formatLine = line: lib.concatStringsSep "  " (lib.zipListsWith pad maxWidths line);

      formattedLabels =
        let
          sep = "# " + lib.concatStrings (lib.genList (lib.const "=") (fullWidth + 5));
          lines = [
            sep
            (formatLine labels)
            (formatLine labelDefaults)
            sep
          ];
        in
        lib.concatStringsSep "\n" lines;

    in
    formattedLabels
    + "\n"
    + lib.concatMapStringsSep "\n" formatLine masterCf
    + "\n"
    + cfg.extraMasterConf;

  headerCheckOptions =
    { ... }:
    {
      options = {
        pattern = lib.mkOption {
          type = lib.types.str;
          default = "/^.*/";
          example = "/^X-Mailer:/";
          description = "A regexp pattern matching the header";
        };
        action = lib.mkOption {
          type = lib.types.str;
          default = "DUNNO";
          example = "BCC mail@example.com";
          description = "The action to be executed when the pattern is matched";
        };
      };
    };

  headerChecks =
    lib.concatStringsSep "\n" (map (x: "${x.pattern} ${x.action}") cfg.headerChecks)
    + cfg.extraHeaderChecks;

  aliases =
    let
      separator = lib.optionalString (cfg.aliasMapType == "hash") ":";
    in
    lib.optionalString (cfg.postmasterAlias != "") ''
      postmaster${separator} ${cfg.postmasterAlias}
    ''
    + lib.optionalString (cfg.rootAlias != "") ''
      root${separator} ${cfg.rootAlias}
    ''
    + cfg.extraAliases;

  aliasesFile = pkgs.writeText "postfix-aliases" aliases;
  canonicalFile = pkgs.writeText "postfix-canonical" cfg.canonical;
  virtualFile = pkgs.writeText "postfix-virtual" cfg.virtual;
  localRecipientMapFile = pkgs.writeText "postfix-local-recipient-map" (
    lib.concatMapStrings (x: x + " ACCEPT\n") cfg.localRecipients
  );
  checkClientAccessFile = pkgs.writeText "postfix-check-client-access" cfg.dnsBlacklistOverrides;
  mainCfFile = pkgs.writeText "postfix-main.cf" mainCf;
  masterCfFile = pkgs.writeText "postfix-master.cf" masterCfContent;
  transportFile = pkgs.writeText "postfix-transport" cfg.transport;
  headerChecksFile = pkgs.writeText "postfix-header-checks" headerChecks;

in

{

  ###### interface

  options = {

    services.postfix = {

      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Whether to run the Postfix mail server.";
      };

      enableSmtp = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Whether to enable smtp in master.cf.";
      };

      enableSubmission = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Whether to enable smtp submission.";
      };

      enableSubmissions = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Whether to enable smtp submission via smtps.

          According to RFC 8314 this should be preferred
          over STARTTLS for submission of messages by end user clients.
        '';
      };

      submissionOptions = lib.mkOption {
        type = with lib.types; attrsOf str;
        default = {
          smtpd_tls_security_level = "encrypt";
          smtpd_sasl_auth_enable = "yes";
          smtpd_client_restrictions = "permit_sasl_authenticated,reject";
          milter_macro_daemon_name = "ORIGINATING";
        };
        example = {
          smtpd_tls_security_level = "encrypt";
          smtpd_sasl_auth_enable = "yes";
          smtpd_sasl_type = "dovecot";
          smtpd_client_restrictions = "permit_sasl_authenticated,reject";
          milter_macro_daemon_name = "ORIGINATING";
        };
        description = "Options for the submission config in master.cf";
      };

      submissionsOptions = lib.mkOption {
        type = with lib.types; attrsOf str;
        default = {
          smtpd_sasl_auth_enable = "yes";
          smtpd_client_restrictions = "permit_sasl_authenticated,reject";
          milter_macro_daemon_name = "ORIGINATING";
        };
        example = {
          smtpd_sasl_auth_enable = "yes";
          smtpd_sasl_type = "dovecot";
          smtpd_client_restrictions = "permit_sasl_authenticated,reject";
          milter_macro_daemon_name = "ORIGINATING";
        };
        description = ''
          Options for the submission config via smtps in master.cf.

          smtpd_tls_security_level will be set to encrypt, if it is missing
          or has one of the values "may" or "none".

          smtpd_tls_wrappermode with value "yes" will be added automatically.
        '';
      };

      setSendmail = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Whether to set the system sendmail to postfix's.";
      };

      user = lib.mkOption {
        type = lib.types.str;
        default = "postfix";
        description = "What to call the Postfix user (must be used only for postfix).";
      };

      group = lib.mkOption {
        type = lib.types.str;
        default = "postfix";
        description = "What to call the Postfix group (must be used only for postfix).";
      };

      setgidGroup = lib.mkOption {
        type = lib.types.str;
        default = "postdrop";
        description = ''
          How to call postfix setgid group (for postdrop). Should
          be uniquely used group.
        '';
      };

      networks = lib.mkOption {
        type = lib.types.nullOr (lib.types.listOf lib.types.str);
        default = null;
        example = [ "192.168.0.1/24" ];
        description = ''
          Net masks for trusted - allowed to relay mail to third parties -
          hosts. Leave empty to use mynetworks_style configuration or use
          default (localhost-only).
        '';
      };

      networksStyle = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = ''
          Name of standard way of trusted network specification to use,
          leave blank if you specify it explicitly or if you want to use
          default (localhost-only).
        '';
      };

      hostname = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = ''
          Hostname to use. Leave blank to use just the hostname of machine.
          It should be FQDN.
        '';
      };

      domain = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = ''
          Domain to use. Leave blank to use hostname minus first component.
        '';
      };

      origin = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = ''
          Origin to use in outgoing e-mail. Leave blank to use hostname.
        '';
      };

      destination = lib.mkOption {
        type = lib.types.nullOr (lib.types.listOf lib.types.str);
        default = null;
        example = [ "localhost" ];
        description = ''
          Full (!) list of domains we deliver locally. Leave blank for
          acceptable Postfix default.
        '';
      };

      relayDomains = lib.mkOption {
        type = lib.types.nullOr (lib.types.listOf lib.types.str);
        default = null;
        example = [ "localdomain" ];
        description = ''
          List of domains we agree to relay to. Default is empty.
        '';
      };

      relayHost = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = ''
          Mail relay for outbound mail.
        '';
      };

      relayPort = lib.mkOption {
        type = lib.types.int;
        default = 25;
        description = ''
          SMTP port for relay mail relay.
        '';
      };

      lookupMX = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Whether relay specified is just domain whose MX must be used.
        '';
      };

      postmasterAlias = lib.mkOption {
        type = lib.types.str;
        default = "root";
        description = ''
          Who should receive postmaster e-mail. Multiple values can be added by
          separating values with comma.
        '';
      };

      rootAlias = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = ''
          Who should receive root e-mail. Blank for no redirection.
          Multiple values can be added by separating values with comma.
        '';
      };

      extraAliases = lib.mkOption {
        type = lib.types.lines;
        default = "";
        description = ''
          Additional entries to put verbatim into aliases file, cf. man-page aliases(8).
        '';
      };

      aliasMapType = lib.mkOption {
        type =
          with lib.types;
          enum [
            "hash"
            "regexp"
            "pcre"
          ];
        default = "hash";
        example = "regexp";
        description = "The format the alias map should have. Use regexp if you want to use regular expressions.";
      };

      config = lib.mkOption {
        type =
          with lib.types;
          attrsOf (oneOf [
            bool
            int
            str
            (listOf str)
          ]);
        description = ''
          The main.cf configuration file as key value set.
        '';
        example = {
          mail_owner = "postfix";
          smtp_tls_security_level = "may";
        };
      };

      extraConfig = lib.mkOption {
        type = lib.types.lines;
        default = "";
        description = ''
          Extra lines to be added verbatim to the main.cf configuration file.
        '';
      };

      tlsTrustedAuthorities = lib.mkOption {
        type = lib.types.str;
        default = "${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt";
        defaultText = lib.literalExpression ''"''${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt"'';
        description = ''
          File containing trusted certification authorities (CA) to verify certificates of mailservers contacted for mail delivery. This basically sets smtp_tls_CAfile and enables opportunistic tls. Defaults to NixOS trusted certification authorities.
        '';
      };

      sslCert = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = "SSL certificate to use.";
      };

      sslKey = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = "SSL key to use.";
      };

      recipientDelimiter = lib.mkOption {
        type = lib.types.str;
        default = "";
        example = "+";
        description = ''
          Delimiter for address extension: so mail to user+test can be handled by ~user/.forward+test
        '';
      };

      canonical = lib.mkOption {
        type = lib.types.lines;
        default = "";
        description = ''
          Entries for the {manpage}`canonical(5)` table.
        '';
      };

      virtual = lib.mkOption {
        type = lib.types.lines;
        default = "";
        description = ''
          Entries for the virtual alias map, cf. man-page virtual(5).
        '';
      };

      virtualMapType = lib.mkOption {
        type = lib.types.enum [
          "hash"
          "regexp"
          "pcre"
        ];
        default = "hash";
        description = ''
          What type of virtual alias map file to use. Use `"regexp"` for regular expressions.
        '';
      };

      localRecipients = lib.mkOption {
        type = with lib.types; nullOr (listOf str);
        default = null;
        description = ''
          List of accepted local users. Specify a bare username, an
          `"@domain.tld"` wild-card, or a complete
          `"user@domain.tld"` address. If set, these names end
          up in the local recipient map -- see the local(8) man-page -- and
          effectively replace the system user database lookup that's otherwise
          used by default.
        '';
      };

      transport = lib.mkOption {
        default = "";
        type = lib.types.lines;
        description = ''
          Entries for the transport map, cf. man-page transport(8).
        '';
      };

      dnsBlacklists = lib.mkOption {
        default = [ ];
        type = with lib.types; listOf str;
        description = "dns blacklist servers to use with smtpd_client_restrictions";
      };

      dnsBlacklistOverrides = lib.mkOption {
        default = "";
        type = lib.types.lines;
        description = "contents of check_client_access for overriding dnsBlacklists";
      };

      masterConfig = lib.mkOption {
        type = lib.types.attrsOf (lib.types.submodule masterCfOptions);
        default = { };
        example = {
          submission = {
            type = "inet";
            args = [
              "-o"
              "smtpd_tls_security_level=encrypt"
            ];
          };
        };
        description = ''
          An attribute set of service options, which correspond to the service
          definitions usually done within the Postfix
          {file}`master.cf` file.
        '';
      };

      extraMasterConf = lib.mkOption {
        type = lib.types.lines;
        default = "";
        example = "submission inet n - n - - smtpd";
        description = "Extra lines to append to the generated master.cf file.";
      };

      enableHeaderChecks = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Whether to enable postfix header checks";
      };

      headerChecks = lib.mkOption {
        type = lib.types.listOf (lib.types.submodule headerCheckOptions);
        default = [ ];
        example = [
          {
            pattern = "/^X-Spam-Flag:/";
            action = "REDIRECT spam@example.com";
          }
        ];
        description = "Postfix header checks.";
      };

      extraHeaderChecks = lib.mkOption {
        type = lib.types.lines;
        default = "";
        example = "/^X-Spam-Flag:/ REDIRECT spam@example.com";
        description = "Extra lines to /etc/postfix/header_checks file.";
      };

      aliasFiles = lib.mkOption {
        type = lib.types.attrsOf lib.types.path;
        default = { };
        description = "Aliases' tables to be compiled and placed into /var/lib/postfix/conf.";
      };

      mapFiles = lib.mkOption {
        type = lib.types.attrsOf lib.types.path;
        default = { };
        description = "Maps to be compiled and placed into /var/lib/postfix/conf.";
      };

      useSrs = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Whether to enable sender rewriting scheme";
      };

    };

  };

  ###### implementation

  config = lib.mkIf config.services.postfix.enable (
    lib.mkMerge [
      {

        environment = {
          etc.postfix.source = "/var/lib/postfix/conf";

          # This makes it comfortable to run 'postqueue/postdrop' for example.
          systemPackages = [ pkgs.postfix ];
        };

        services.pfix-srsd.enable = config.services.postfix.useSrs;

        services.mail.sendmailSetuidWrapper = lib.mkIf config.services.postfix.setSendmail {
          program = "sendmail";
          source = "${pkgs.postfix}/bin/sendmail";
          owner = "root";
          group = setgidGroup;
          setuid = false;
          setgid = true;
        };

        security.wrappers.mailq = {
          program = "mailq";
          source = "${pkgs.postfix}/bin/mailq";
          owner = "root";
          group = setgidGroup;
          setuid = false;
          setgid = true;
        };

        security.wrappers.postqueue = {
          program = "postqueue";
          source = "${pkgs.postfix}/bin/postqueue";
          owner = "root";
          group = setgidGroup;
          setuid = false;
          setgid = true;
        };

        security.wrappers.postdrop = {
          program = "postdrop";
          source = "${pkgs.postfix}/bin/postdrop";
          owner = "root";
          group = setgidGroup;
          setuid = false;
          setgid = true;
        };

        users.users = lib.optionalAttrs (user == "postfix") {
          postfix = {
            description = "Postfix mail server user";
            uid = config.ids.uids.postfix;
            group = group;
          };
        };

        users.groups =
          lib.optionalAttrs (group == "postfix") {
            ${group}.gid = config.ids.gids.postfix;
          }
          // lib.optionalAttrs (setgidGroup == "postdrop") {
            ${setgidGroup}.gid = config.ids.gids.postdrop;
          };

        systemd.services.postfix-setup = {
          description = "Setup for Postfix mail server";
          serviceConfig.RemainAfterExit = true;
          serviceConfig.Type = "oneshot";
          script = ''
            # Backwards compatibility
            if [ ! -d /var/lib/postfix ] && [ -d /var/postfix ]; then
              mkdir -p /var/lib
              mv /var/postfix /var/lib/postfix
            fi

            # All permissions set according ${pkgs.postfix}/etc/postfix/postfix-files script
            mkdir -p /var/lib/postfix /var/lib/postfix/queue/{pid,public,maildrop}
            chmod 0755 /var/lib/postfix
            chown root:root /var/lib/postfix

            rm -rf /var/lib/postfix/conf
            mkdir -p /var/lib/postfix/conf
            chmod 0755 /var/lib/postfix/conf
            ln -sf ${pkgs.postfix}/etc/postfix/postfix-files /var/lib/postfix/conf/postfix-files
            ln -sf ${mainCfFile} /var/lib/postfix/conf/main.cf
            ln -sf ${masterCfFile} /var/lib/postfix/conf/master.cf

            ${lib.concatStringsSep "\n" (
              lib.mapAttrsToList (to: from: ''
                ln -sf ${from} /var/lib/postfix/conf/${to}
                ${pkgs.postfix}/bin/postalias -o -p /var/lib/postfix/conf/${to}
              '') cfg.aliasFiles
            )}
            ${lib.concatStringsSep "\n" (
              lib.mapAttrsToList (to: from: ''
                ln -sf ${from} /var/lib/postfix/conf/${to}
                ${pkgs.postfix}/bin/postmap /var/lib/postfix/conf/${to}
              '') cfg.mapFiles
            )}

            mkdir -p /var/spool/mail
            chown root:root /var/spool/mail
            chmod a+rwxt /var/spool/mail
            ln -sf /var/spool/mail /var/

            #Finally delegate to postfix checking remain directories in /var/lib/postfix and set permissions on them
            ${pkgs.postfix}/bin/postfix set-permissions config_directory=/var/lib/postfix/conf
          '';
        };

        systemd.services.postfix = {
          description = "Postfix mail server";

          wantedBy = [ "multi-user.target" ];
          after = [
            "network.target"
            "postfix-setup.service"
          ];
          requires = [ "postfix-setup.service" ];
          path = [ pkgs.postfix ];

          serviceConfig = {
            Type = "forking";
            Restart = "always";
            PIDFile = "/var/lib/postfix/queue/pid/master.pid";
            ExecStart = "${pkgs.postfix}/bin/postfix start";
            ExecStop = "${pkgs.postfix}/bin/postfix stop";
            ExecReload = "${pkgs.postfix}/bin/postfix reload";

            # Hardening
            PrivateTmp = true;
            PrivateDevices = true;
            ProtectSystem = "full";
            CapabilityBoundingSet = [ "~CAP_NET_ADMIN CAP_SYS_ADMIN CAP_SYS_BOOT CAP_SYS_MODULE" ];
            MemoryDenyWriteExecute = true;
            ProtectKernelModules = true;
            ProtectKernelTunables = true;
            ProtectControlGroups = true;
            RestrictAddressFamilies = [
              "AF_INET"
              "AF_INET6"
              "AF_NETLINK"
              "AF_UNIX"
            ];
            RestrictNamespaces = true;
            RestrictRealtime = true;
          };
        };

        services.postfix.config =
          (lib.mapAttrs (_: v: lib.mkDefault v) {
            compatibility_level = pkgs.postfix.version;
            mail_owner = cfg.user;
            default_privs = "nobody";

            # NixOS specific locations
            data_directory = "/var/lib/postfix/data";
            queue_directory = "/var/lib/postfix/queue";

            # Default location of everything in package
            meta_directory = "${pkgs.postfix}/etc/postfix";
            command_directory = "${pkgs.postfix}/bin";
            sample_directory = "/etc/postfix";
            newaliases_path = "${pkgs.postfix}/bin/newaliases";
            mailq_path = "${pkgs.postfix}/bin/mailq";
            readme_directory = false;
            sendmail_path = "${pkgs.postfix}/bin/sendmail";
            daemon_directory = "${pkgs.postfix}/libexec/postfix";
            manpage_directory = "${pkgs.postfix}/share/man";
            html_directory = "${pkgs.postfix}/share/postfix/doc/html";
            shlib_directory = false;
            mail_spool_directory = "/var/spool/mail/";
            setgid_group = cfg.setgidGroup;
          })
          // lib.optionalAttrs (cfg.relayHost != "") {
            relayhost =
              if cfg.lookupMX then
                "${cfg.relayHost}:${toString cfg.relayPort}"
              else
                "[${cfg.relayHost}]:${toString cfg.relayPort}";
          }
          // lib.optionalAttrs (!config.networking.enableIPv6) { inet_protocols = lib.mkDefault "ipv4"; }
          // lib.optionalAttrs (cfg.networks != null) { mynetworks = cfg.networks; }
          // lib.optionalAttrs (cfg.networksStyle != "") { mynetworks_style = cfg.networksStyle; }
          // lib.optionalAttrs (cfg.hostname != "") { myhostname = cfg.hostname; }
          // lib.optionalAttrs (cfg.domain != "") { mydomain = cfg.domain; }
          // lib.optionalAttrs (cfg.origin != "") { myorigin = cfg.origin; }
          // lib.optionalAttrs (cfg.destination != null) { mydestination = cfg.destination; }
          // lib.optionalAttrs (cfg.relayDomains != null) { relay_domains = cfg.relayDomains; }
          // lib.optionalAttrs (cfg.recipientDelimiter != "") {
            recipient_delimiter = cfg.recipientDelimiter;
          }
          // lib.optionalAttrs haveAliases { alias_maps = [ "${cfg.aliasMapType}:/etc/postfix/aliases" ]; }
          // lib.optionalAttrs haveTransport { transport_maps = [ "hash:/etc/postfix/transport" ]; }
          // lib.optionalAttrs haveVirtual {
            virtual_alias_maps = [ "${cfg.virtualMapType}:/etc/postfix/virtual" ];
          }
          // lib.optionalAttrs haveLocalRecipients {
            local_recipient_maps = [
              "hash:/etc/postfix/local_recipients"
            ] ++ lib.optional haveAliases "$alias_maps";
          }
          // lib.optionalAttrs (cfg.dnsBlacklists != [ ]) { smtpd_client_restrictions = clientRestrictions; }
          // lib.optionalAttrs cfg.useSrs {
            sender_canonical_maps = [ "tcp:127.0.0.1:10001" ];
            sender_canonical_classes = [ "envelope_sender" ];
            recipient_canonical_maps = [ "tcp:127.0.0.1:10002" ];
            recipient_canonical_classes = [ "envelope_recipient" ];
          }
          // lib.optionalAttrs cfg.enableHeaderChecks {
            header_checks = [ "regexp:/etc/postfix/header_checks" ];
          }
          // lib.optionalAttrs (cfg.tlsTrustedAuthorities != "") {
            smtp_tls_CAfile = cfg.tlsTrustedAuthorities;
            smtp_tls_security_level = lib.mkDefault "may";
          }
          // lib.optionalAttrs (cfg.sslCert != "") {
            smtp_tls_cert_file = cfg.sslCert;
            smtp_tls_key_file = cfg.sslKey;

            smtp_tls_security_level = lib.mkDefault "may";

            smtpd_tls_cert_file = cfg.sslCert;
            smtpd_tls_key_file = cfg.sslKey;

            smtpd_tls_security_level = "may";
          };

        services.postfix.masterConfig =
          {
            pickup = {
              private = false;
              wakeup = 60;
              maxproc = 1;
            };
            cleanup = {
              private = false;
              maxproc = 0;
            };
            qmgr = {
              private = false;
              wakeup = 300;
              maxproc = 1;
            };
            tlsmgr = {
              wakeup = 1000;
              wakeupUnusedComponent = false;
              maxproc = 1;
            };
            rewrite = {
              command = "trivial-rewrite";
            };
            bounce = {
              maxproc = 0;
            };
            defer = {
              maxproc = 0;
              command = "bounce";
            };
            trace = {
              maxproc = 0;
              command = "bounce";
            };
            verify = {
              maxproc = 1;
            };
            flush = {
              private = false;
              wakeup = 1000;
              wakeupUnusedComponent = false;
              maxproc = 0;
            };
            proxymap = {
              command = "proxymap";
            };
            proxywrite = {
              maxproc = 1;
              command = "proxymap";
            };
            showq = {
              private = false;
            };
            error = { };
            retry = {
              command = "error";
            };
            discard = { };
            local = {
              privileged = true;
            };
            virtual = {
              privileged = true;
            };
            lmtp = {
            };
            anvil = {
              maxproc = 1;
            };
            scache = {
              maxproc = 1;
            };
          }
          // lib.optionalAttrs cfg.enableSubmission {
            submission = {
              type = "inet";
              private = false;
              command = "smtpd";
              args =
                let
                  mkKeyVal = opt: val: [
                    "-o"
                    (opt + "=" + val)
                  ];
                in
                lib.concatLists (lib.mapAttrsToList mkKeyVal cfg.submissionOptions);
            };
          }
          // lib.optionalAttrs cfg.enableSmtp {
            smtp_inet = {
              name = "smtp";
              type = "inet";
              private = false;
              command = "smtpd";
            };
            smtp = { };
            relay = {
              command = "smtp";
              args = [
                "-o"
                "smtp_fallback_relay="
              ];
            };
          }
          // lib.optionalAttrs cfg.enableSubmissions {
            submissions = {
              type = "inet";
              private = false;
              command = "smtpd";
              args =
                let
                  mkKeyVal = opt: val: [
                    "-o"
                    (opt + "=" + val)
                  ];
                  adjustSmtpTlsSecurityLevel =
                    !(cfg.submissionsOptions ? smtpd_tls_security_level)
                    || cfg.submissionsOptions.smtpd_tls_security_level == "none"
                    || cfg.submissionsOptions.smtpd_tls_security_level == "may";
                  submissionsOptions =
                    cfg.submissionsOptions
                    // {
                      smtpd_tls_wrappermode = "yes";
                    }
                    // lib.optionalAttrs adjustSmtpTlsSecurityLevel {
                      smtpd_tls_security_level = "encrypt";
                    };
                in
                lib.concatLists (lib.mapAttrsToList mkKeyVal submissionsOptions);
            };
          };
      }

      (lib.mkIf haveAliases {
        services.postfix.aliasFiles.aliases = aliasesFile;
      })
      (lib.mkIf haveCanonical {
        services.postfix.mapFiles.canonical = canonicalFile;
      })
      (lib.mkIf haveTransport {
        services.postfix.mapFiles.transport = transportFile;
      })
      (lib.mkIf haveVirtual {
        services.postfix.mapFiles.virtual = virtualFile;
      })
      (lib.mkIf haveLocalRecipients {
        services.postfix.mapFiles.local_recipients = localRecipientMapFile;
      })
      (lib.mkIf cfg.enableHeaderChecks {
        services.postfix.mapFiles.header_checks = headerChecksFile;
      })
      (lib.mkIf (cfg.dnsBlacklists != [ ]) {
        services.postfix.mapFiles.client_access = checkClientAccessFile;
      })
    ]
  );

  imports = [
    (lib.mkRemovedOptionModule [ "services" "postfix" "sslCACert" ]
      "services.postfix.sslCACert was replaced by services.postfix.tlsTrustedAuthorities. In case you intend that your server should validate requested client certificates use services.postfix.extraConfig."
    )

    (lib.mkChangedOptionModule
      [ "services" "postfix" "useDane" ]
      [ "services" "postfix" "config" "smtp_tls_security_level" ]
      (config: lib.mkIf config.services.postfix.useDane "dane")
    )
  ];
}

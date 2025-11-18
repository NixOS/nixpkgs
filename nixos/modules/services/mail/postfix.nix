{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    literalExpression
    mkOption
    types
    ;

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
    lib.concatStringsSep "\n" (
      lib.mapAttrsToList mkEntry (lib.filterAttrsRecursive (_: value: value != null) cfg.settings.main)
    );

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

      masterCf = lib.mapAttrsToList (lib.const (lib.getAttr "rawEntry")) cfg.settings.master;

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
          ]
          ++ (map (l: lib.init l ++ [ "" ]) masterCf);
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

  meta.maintainers = with lib.maintainers; [
    dotlambda
    hexa
  ];

  ###### interface

  options = {

    services.postfix = {

      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Whether to run the Postfix mail server.";
      };

      package = lib.mkPackageOption pkgs "postfix" { };

      enableSmtp = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = ''
          Whether to enable the `smtp` service configured in the master.cf.

          This service listens for plain text SMTP connections on port 25
          and supports explicit TLS via StartTLS.

          It is the primary port used by SMTP servers to exchange mail.
        '';
      };

      enableSubmission = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "
          Whether to enable the `submission` service configured in master.cf.

          This service listens for plain text SMTP connections on port 587
          and supports explicit TLS via StartTLS.

          It is a way for clients to login and submit mails after an inband
          connection upgrade using StartTLS.

          ::: {.warning}
          [RFC 8314](https://www.rfc-editor.org/rfc/rfc8314) discourages the use
          of explicit TLS for mail submissionn.
          :::
        ";
      };

      enableSubmissions = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Whether to enable the `submissions` service configured in master.cf.

          This service listen for implicit TLS connections on port 465.

          ::: {.info}
          Per [RFC 8314](https://www.rfc-editor.org/rfc/rfc8314) implicit TLS
          is recommended for mail submission.
          :::
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
          Additional entries to put verbatim into aliases file, cf. man-page {manpage}`aliases(8)`.
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

      settings = {
        main = lib.mkOption {
          type = lib.types.submodule {
            freeformType =
              with types;
              attrsOf (
                nullOr (oneOf [
                  bool
                  int
                  path
                  str
                  (listOf str)
                ])
              );
            options = {
              message_size_limit = mkOption {
                type = with types; nullOr int;
                default = 10240000; # 10 MiB
                example = 52428800; # 50 MiB
                description = ''
                  Maximum size of an email message in bytes.

                  <https://www.postfix.org/postconf.5.html#message_size_limit>
                '';
              };

              mydestination = mkOption {
                type =
                  with types;
                  nullOr (oneOf [
                    str
                    (listOf str)
                  ]);
                default = [
                  "$myhostname"
                  "localhost.$mydomain"
                  "localhost"
                ];
                description = ''
                  List of domain names intended for local delivery using /etc/passwd and /etc/aliases.

                  ::: {.warning}
                  Do not include [virtual](https://www.postfix.org/VIRTUAL_README.html) domains in this list.
                  :::

                  <https://www.postfix.org/postconf.5.html#mydestination>
                '';
              };

              myhostname = mkOption {
                type = with types; nullOr types.str;
                default = null;
                example = "mail.example.com";
                description = ''
                  The internet hostname of this mail system.

                  Leave unset to default to the system hostname with the {option}`mydomain` suffix.

                  <https://www.postfix.org/postconf.5.html#myhostname>
                '';
              };

              mynetworks = mkOption {
                type = with types; nullOr (listOf str);
                default = null;
                example = [
                  "127.0.0.0/8"
                  "::1"
                ];
                description = ''
                  List of trusted remote SMTP clients, that are allowed to relay mail.

                  Leave unset to let Postfix populate this list based on the {option}`mynetworks_style` setting.

                  <https://www.postfix.org/postconf.5.html#mynetworks>
                '';
              };

              mynetworks_style = mkOption {
                type =
                  with types;
                  nullOr (enum [
                    "host"
                    "subnet"
                    "class"
                  ]);
                default = "host";
                description = ''
                  The method used for generating the default value for {option}`mynetworks`, if that option is unset.

                  <https://www.postfix.org/postconf.5.html#mynetworks_style>
                '';
              };

              recipient_delimiter = lib.mkOption {
                type = with types; nullOr str;
                default = "";
                example = "+";
                description = ''
                  Set of characters used as the delimiters for address extensions.

                  This allows creating different forwarding rules per extension.

                  <https://www.postfix.org/postconf.5.html#recipient_delimiter>
                '';
              };

              relayhost = mkOption {
                type = with types; nullOr (listOf str);
                default = [ ];
                example = [ "[relay.example.com]:587" ];
                description = ''
                  List of hosts to use for relaying outbound mail.

                  ::: {.note}
                  Putting the hostname in angled brackets, e.g. `[relay.example.com]`, turns off MX and SRV lookups for the hostname.
                  :::

                  <https://www.postfix.org/postconf.5.html#relayhost>
                '';
              };

              relay_domains = mkOption {
                type = with types; nullOr (listOf str);
                default = [ ];
                example = [ "lists.example.com" ];
                description = ''
                  List of domains delivered via the relay transport.

                  <https://www.postfix.org/postconf.5.html#relay_domains>
                '';
              };

              smtp_tls_CAfile = mkOption {
                type = types.path;
                default = config.security.pki.caBundle;
                defaultText = literalExpression ''
                  config.security.pki.caBundle
                '';
                example = literalExpression ''
                  ''${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt
                '';
                description = ''
                  File containing CA certificates of root CAs trusted to sign either remote SMTP server certificates or intermediate CA certificates.

                  Defaults to the system CA bundle that is managed through the `security.pki` options.

                  <https://www.postfix.org/postconf.5.html#smtp_tls_CAfile>
                '';
              };

              smtp_tls_security_level = mkOption {
                type = types.enum [
                  "none"
                  "may"
                  "encrypt"
                  "dane"
                  "dane-only"
                  "fingerprint"
                  "verify"
                  "secure"
                ];
                default = "may";
                description = ''
                  The client TLS security level.

                  ::: {.tip}
                  Use `dane` with a local DNSSEC validating DNS resolver enabled.
                  :::

                  <https://www.postfix.org/postconf.5.html#smtp_tls_security_level>
                '';
              };

              smtpd_tls_chain_files = mkOption {
                type = with types; listOf path;
                default = [ ];
                example = [
                  "/var/lib/acme/mail.example.com/privkey.pem"
                  "/var/lib/acme/mail.example.com/fullchain.pem"
                ];
                description = ''
                  List of paths to the server private keys and certificates.

                  ::: {.caution}
                  The order of items matters and a private key must always be followed by the corresponding certificate.
                  :::

                  <https://www.postfix.org/postconf.5.html#smtpd_tls_chain_files>
                '';
              };

              smtpd_tls_security_level = mkOption {
                type = types.enum [
                  "none"
                  "may"
                  "encrypt"
                ];
                default =
                  if config.services.postfix.settings.main.smtpd_tls_chain_files != [ ] then "may" else "none";
                defaultText = lib.literalExpression ''
                  if config.services.postfix.settings.main.smtpd_tls_chain_files != [ ] then "may" else "none"
                '';
                example = "may";
                description = ''
                  The server TLS security level. Enable TLS by configuring at least `may`.

                  <https://www.postfix.org/postconf.5.html#smtpd_tls_security_level>
                '';
              };
            };
          };

          description = ''
            The main.cf configuration file as key value set.

            Null values will not be rendered.

            ::: {.tip}
            Check `postconf -d` for the default values of all settings.
            :::
          '';
          example = {
            mail_owner = "postfix";
            smtp_tls_security_level = "may";
          };
        };

        master = lib.mkOption {
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
            The {file}`master.cf` configuration file as an attribute set of service
            defitions

            ::: {.tip}
            Check <https://www.postfix.org/master.5.html> for possible settings.
            :::
          '';
        };

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
          Entries for the virtual alias map, cf. man-page {manpage}`virtual(5)`.
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
          up in the local recipient map -- see the {manpage}`local(8)` man-page -- and
          effectively replace the system user database lookup that's otherwise
          used by default.
        '';
      };

      transport = lib.mkOption {
        default = "";
        type = lib.types.lines;
        description = ''
          Entries for the transport map, cf. man-page {manpage}`transport(5)`.
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

    };

  };

  ###### implementation

  config = lib.mkIf config.services.postfix.enable (
    lib.mkMerge [
      {

        environment = {
          etc.postfix.source = "/var/lib/postfix/conf";

          # This makes it comfortable to run 'postqueue/postdrop' for example.
          systemPackages = [ cfg.package ];
        };

        services.mail.sendmailSetuidWrapper = lib.mkIf config.services.postfix.setSendmail {
          program = "sendmail";
          source = lib.getExe' cfg.package "sendmail";
          owner = "root";
          group = setgidGroup;
          setuid = false;
          setgid = true;
        };

        security.wrappers.mailq = {
          program = "mailq";
          source = lib.getExe' cfg.package "mailq";
          owner = "root";
          group = setgidGroup;
          setuid = false;
          setgid = true;
        };

        security.wrappers.postqueue = {
          program = "postqueue";
          source = lib.getExe' cfg.package "postqueue";
          owner = "root";
          group = setgidGroup;
          setuid = false;
          setgid = true;
        };

        security.wrappers.postdrop = {
          program = "postdrop";
          source = lib.getExe' cfg.package "postdrop";
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

            # All permissions set according ${cfg.package}/etc/postfix/postfix-files script
            mkdir -p /var/lib/postfix /var/lib/postfix/queue/{pid,public,maildrop}
            chmod 0755 /var/lib/postfix
            chown root:root /var/lib/postfix

            rm -rf /var/lib/postfix/conf
            mkdir -p /var/lib/postfix/conf
            chmod 0755 /var/lib/postfix/conf
            ln -sf ${cfg.package}/etc/postfix/postfix-files /var/lib/postfix/conf/postfix-files
            ln -sf ${mainCfFile} /var/lib/postfix/conf/main.cf
            ln -sf ${masterCfFile} /var/lib/postfix/conf/master.cf

            ${lib.concatStringsSep "\n" (
              lib.mapAttrsToList (to: from: ''
                ln -sf ${from} /var/lib/postfix/conf/${to}
                ${lib.getExe' cfg.package "postalias"} -o -p /var/lib/postfix/conf/${to}
              '') cfg.aliasFiles
            )}
            ${lib.concatStringsSep "\n" (
              lib.mapAttrsToList (to: from: ''
                ln -sf ${from} /var/lib/postfix/conf/${to}
                ${lib.getExe' cfg.package "postmap"} /var/lib/postfix/conf/${to}
              '') cfg.mapFiles
            )}

            mkdir -p /var/spool/mail
            chown root:root /var/spool/mail
            chmod a+rwxt /var/spool/mail
            ln -sf /var/spool/mail /var/

            #Finally delegate to postfix checking remain directories in /var/lib/postfix and set permissions on them
            ${lib.getExe' cfg.package "postfix"} set-permissions config_directory=/var/lib/postfix/conf
          '';
        };

        systemd.services.postfix = {
          description = "Postfix mail server";

          documentation = [ "man:postfix(1)" ];
          wantedBy = [ "multi-user.target" ];
          after = [
            "network.target"
            "postfix-setup.service"
          ];
          requires = [ "postfix-setup.service" ];
          path = [ cfg.package ];

          serviceConfig = {
            Type = "forking";
            Restart = "always";
            PIDFile = "/var/lib/postfix/queue/pid/master.pid";
            ExecStart = "${lib.getExe' cfg.package "postfix"} start";
            ExecStop = "${lib.getExe' cfg.package "postfix"} stop";
            ExecReload = "${lib.getExe' cfg.package "postfix"} reload";

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

        services.postfix.settings.main =
          (lib.mapAttrs (_: v: lib.mkDefault v) {
            compatibility_level = cfg.package.version;
            mail_owner = cfg.user;
            default_privs = "nobody";

            # NixOS specific locations
            data_directory = "/var/lib/postfix/data";
            queue_directory = "/var/lib/postfix/queue";

            # Default location of everything in package
            meta_directory = "${cfg.package}/etc/postfix";
            command_directory = "${cfg.package}/bin";
            sample_directory = "/etc/postfix";
            newaliases_path = lib.getExe' cfg.package "newaliases";
            mailq_path = lib.getExe' cfg.package "mailq";
            readme_directory = false;
            sendmail_path = lib.getExe' cfg.package "sendmail";
            daemon_directory = "${cfg.package}/libexec/postfix";
            manpage_directory = "${cfg.package}/share/man";
            html_directory = "${cfg.package}/share/postfix/doc/html";
            shlib_directory = false;
            mail_spool_directory = "/var/spool/mail/";
            setgid_group = cfg.setgidGroup;
          })
          // lib.optionalAttrs haveAliases { alias_maps = [ "${cfg.aliasMapType}:/etc/postfix/aliases" ]; }
          // lib.optionalAttrs haveTransport { transport_maps = [ "hash:/etc/postfix/transport" ]; }
          // lib.optionalAttrs haveVirtual {
            virtual_alias_maps = [ "${cfg.virtualMapType}:/etc/postfix/virtual" ];
          }
          // lib.optionalAttrs haveLocalRecipients {
            local_recipient_maps = [
              "hash:/etc/postfix/local_recipients"
            ]
            ++ lib.optional haveAliases "$alias_maps";
          }
          // lib.optionalAttrs (cfg.dnsBlacklists != [ ]) { smtpd_client_restrictions = clientRestrictions; }
          // lib.optionalAttrs cfg.enableHeaderChecks {
            header_checks = [ "regexp:/etc/postfix/header_checks" ];
          };

        services.postfix.settings.master = {
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
      "services.postfix.sslCACert was replaced by services.postfix.tlsTrustedAuthorities. In case you intend that your server should validate requested client certificates use services.postfix.settings.main.smtp_tls_CAfile."
    )
    (lib.mkRemovedOptionModule [ "services" "postfix" "sslCert" ]
      "services.postfix.sslCert was removed. Use services.postfix.settings.main.smtpd_tls_chain_files for the server certificate, or services.postfix.settings.main.smtp_tls_chain_files for the client certificate."
    )
    (lib.mkRemovedOptionModule [ "services" "postfix" "sslKey" ]
      "services.postfix.sslKey was removed. Use services.postfix.settings.main.smtpd_tls_chain_files for server private key, or services.postfix.settings.main.smtp_tls_chain_files for the client private key."
    )
    (lib.mkRemovedOptionModule [ "services" "postfix" "lookupMX" ]
      "services.postfix.lookupMX was removed. Use services.postfix.settings.main.relayhost and put the hostname in angled brackets, if you need to turn off MX and SRV lookups."
    )
    (lib.mkRemovedOptionModule [ "services" "postfix" "relayHost" ]
      "services.postfix.relayHost was removed in favor of services.postfix.settings.main.relayhost, which now takes a list of host:port."
    )
    (lib.mkRemovedOptionModule [ "services" "postfix" "relayPort" ]
      "services.postfix.relayPort was removed in favor of services.postfix.settings.main.relayhost, which now takes a list of host:port."
    )
    (lib.mkRemovedOptionModule [ "services" "postfix" "extraConfig" ]
      "services.postfix.extraConfig was replaced by the structured freeform services.postfix.settings.main option."
    )
    (lib.mkRenamedOptionModule
      [ "services" "postfix" "networks" ]
      [ "services" "postfix" "settings" "main" "mynetworks" ]
    )
    (lib.mkRenamedOptionModule
      [ "services" "postfix" "networksStyle" ]
      [ "services" "postfix" "settings" "main" "mynetworks_style" ]
    )
    (lib.mkRenamedOptionModule
      [ "services" "postfix" "hostname" ]
      [ "services" "postfix" "settings" "main" "myhostname" ]
    )
    (lib.mkRenamedOptionModule
      [ "services" "postfix" "domain" ]
      [ "services" "postfix" "settings" "main" "mydomain" ]
    )
    (lib.mkRenamedOptionModule
      [ "services" "postfix" "origin" ]
      [ "services" "postfix" "settings" "main" "myorigin" ]
    )
    (lib.mkRenamedOptionModule
      [ "services" "postfix" "destination" ]
      [ "services" "postfix" "settings" "main" "mydestination" ]
    )
    (lib.mkRenamedOptionModule
      [ "services" "postfix" "relayDomains" ]
      [ "services" "postfix" "settings" "main" "relay_domains" ]
    )
    (lib.mkRenamedOptionModule
      [ "services" "postfix" "recipientDelimiter" ]
      [ "services" "postfix" "settings" "main" "recipient_delimiter" ]
    )
    (lib.mkRenamedOptionModule
      [ "services" "postfix" "tlsTrustedAuthoriies" ]
      [ "services" "postfix" "settings" "main" "smtp_tls_CAfile" ]
    )
    (lib.mkRenamedOptionModule
      [ "services" "postfix" "config" ]
      [ "services" "postfix" "settings" "main" ]
    )
    (lib.mkRenamedOptionModule
      [ "services" "postfix" "masterConfig" ]
      [ "services" "postfix" "settings" "master" ]
    )

    (lib.mkChangedOptionModule
      [ "services" "postfix" "useDane" ]
      [ "services" "postfix" "settings" "main" "smtp_tls_security_level" ]
      (config: lib.mkIf config.services.postfix.useDane "dane")
    )
    (lib.mkRenamedOptionModule [ "services" "postfix" "useSrs" ] [ "services" "pfix-srsd" "enable" ])
  ];
}

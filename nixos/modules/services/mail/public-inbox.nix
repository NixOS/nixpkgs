{ lib, pkgs, config, ... }:

with lib;

let
  cfg = config.services.public-inbox;

  inboxesDir = "/var/lib/public-inbox/inboxes";
  inboxPath = name: "${inboxesDir}/${name}";
  gitPath = name: "${inboxPath name}/all.git";

  inboxes = mapAttrs (name: inbox:
    (recursiveUpdate {
      inherit (inbox) address url newsgroup watch;
      mainrepo = inboxPath name;
      watchheader = inbox.watchHeader;
    } inbox.config))
    cfg.inboxes;

  concat = concatMap id;

  configToList = attrs:
    concat (mapAttrsToList (name': value':
      if isAttrs value' then
        map ({ name, value }: nameValuePair "${name'}.${name}" value)
          (configToList value')
      else if isList value' then map (nameValuePair name') value'
      else if value' == null then []
      else [ (nameValuePair name' value') ]) attrs);

  configFull = recursiveUpdate {
    publicinbox = inboxes // {
      nntpserver = cfg.nntpServer;
      wwwlisting = cfg.wwwListing;
    };
    publicinboxmda.spamcheck = cfg.mda.spamCheck;
    publicinboxwatch.spamcheck = cfg.watch.spamCheck;
    publicinboxwatch.watchspam = cfg.watch.watchSpam;
  } cfg.config;

  configList = configToList configFull;

  gitConfig = key: val: ''
    ${pkgs.git}/bin/git config --add --file $out ${escapeShellArgs [ key val ]}
  '';

  configFile = pkgs.runCommand "public-inbox-config" {}
    (concatStrings (map ({ name, value }: gitConfig name value) configList));

  environment = {
    PI_EMERGENCY = "/var/lib/public-inbox/emergency";
    PI_CONFIG = configFile;
  };

  envList = mapAttrsToList (n: v: "${n}=${v}") environment;

  # Can't use pkgs.linkFarm,
  # because Postfix rejects .forward if it's a symlink.
  home = pkgs.runCommand "public-inbox-home" {
    forward = ''
      |"env ${concatStringsSep " " envList} PATH=\"${makeBinPath cfg.path}:$PATH\" ${cfg.package}/bin/public-inbox-mda
    '';
    passAsFile = [ "forward" ];
  } ''
    mkdir $out
    ln -s /var/lib/public-inbox/spamassassin $out/.spamassassin
    cp $forwardPath $out/.forward
  '';

  psgi = pkgs.writeText "public-inbox.psgi" ''
    #!${cfg.package.fullperl} -w
    # Copyright (C) 2014-2019 all contributors <meta@public-inbox.org>
    # License: GPL-3.0+ <https://www.gnu.org/licenses/gpl-3.0.txt>
    use strict;
    use PublicInbox::WWW;
    use Plack::Builder;

    my $www = PublicInbox::WWW->new;
    $www->preload;

    builder {
      enable 'Head';
      enable 'ReverseProxy';
      ${concatMapStrings (path: ''
      mount q(${path}) => sub { $www->call(@_); };
      '') cfg.http.mounts}
    }
  '';

  descriptionFile = { description, ... }:
    pkgs.writeText "description" description;

  enableWatch = (any (i: i.watch != []) (attrValues cfg.inboxes))
                || (cfg.watch.watchSpam != null);

  useSpamAssassin = cfg.mda.spamCheck == "spamc" ||
                    cfg.watch.spamCheck == "spamc";

in

{
  options = {
    services.public-inbox = {
      enable = mkEnableOption "the public-inbox mail archiver";

      package = mkOption {
        type = types.package;
        default = pkgs.public-inbox;
        description = ''
          public-inbox package to use with the public-inbox module
        '';
      };

      path = mkOption {
        type = with types; listOf package;
        default = [];
        example = literalExample "with pkgs; [ spamassassin ]";
        description = ''
          Additional packages to place in the path of public-inbox-mda,
          public-inbox-watch, etc.
        '';
      };

      inboxes = mkOption {
        description = ''
          Inboxes to configure, where attribute names are inbox names
        '';
        type = with types; loaOf (submodule {
          options = {
            address = mkOption {
              type = listOf str;
              example = singleton "example-discuss@example.org";
              description = ''
                Email address(es) of the inbox
              '';
            };

            url = mkOption {
              type = nullOr str;
              default = null;
              example = "https://example.org/lists/example-discuss";
              description = ''
                URL where this inbox can be accessed over HTTP
              '';
            };

            description = mkOption {
              type = str;
              example = "user/dev discussion of public-inbox itself";
              description = ''
                User-visible description for the repository
              '';
            };

            config = mkOption {
              type = attrs;
              default = {};
              description = ''
                Additional structured config for the inbox
              '';
            };

            newsgroup = mkOption {
              type = nullOr str;
              default = null;
              description = ''
                NNTP group name for the inbox
              '';
            };

            watch = mkOption {
              type = listOf str;
              default = [];
              description = ''
                Paths for public-inbox-watch(1) to monitor for new mail
              '';
              example = [ "maildir:/path/to/test.example.com.git" ];
            };

            watchHeader = mkOption {
              type = nullOr str;
              default = null;
              example = "List-Id:<test@example.com>";
              description = ''
                If specified, public-inbox-watch(1) will only process
                mail containing a matching header.
              '';
            };
          };
        });
      };

      mda = {
        spamCheck = mkOption {
          type = with types; nullOr (enum [ "spamc" ]);
          default = "spamc";
          description = ''
            If set to spamc, public-inbox-mda(1) will filter spam
            using SpamAssassin
          '';
        };
      };

      watch = {
        spamCheck = mkOption {
          type = with types; nullOr (enum [ "spamc" ]);
          default = "spamc";
          description = ''
            If set to spamc, public-inbox-watch(1) will filter spam
            using SpamAssassin
          '';
        };

        watchSpam = mkOption {
          type = with types; nullOr str;
          default = null;
          example = "maildir:/path/to/spam";
          description = ''
            If set, mail in this maildir will be trained as spam and
            deleted from all watched inboxes
          '';
        };
      };

      http = {
        mounts = mkOption {
          type = with types; listOf str;
          default = [ "/" ];
          example = [ "/lists/archives" ];
          description = ''
            Root paths or URLs that public-inbox will be served on.
            If domain parts are present, only requests to those
            domains will be accepted.
          '';
        };

        listenStreams = mkOption {
          type = with types; listOf str;
          default = [ "/run/public-inbox-httpd.sock" ];
          description = ''
            systemd.socket(5) ListenStream values for the
            public-inbox-httpd service to listen on
          '';
        };
      };

      nntp = {
        listenStreams = mkOption {
          type = with types; listOf str;
          default = [ "0.0.0.0:119" "0.0.0.0:563" ];
          description = ''
            systemd.socket(5) ListenStream values for the
            public-inbox-nntpd service to listen on
          '';
        };

        cert = mkOption {
          type = with types; nullOr str;
          default = null;
          example = "/path/to/fullchain.pem";
          description = ''
            Path to TLS certificate to use for public-inbox NNTP connections
          '';
        };

        key = mkOption {
          type = with types; nullOr str;
          default = null;
          example = "/path/to/key.pem";
          description = ''
            Path to TLS key to use for public-inbox NNTP connections
          '';
        };

        extraGroups = mkOption {
          type = with types; listOf str;
          default = [];
          example = [ "tls" ];
          description = ''
            Secondary groups to assign to the systemd DynamicUser
            running public-inbox-nntpd, in addition to the
            public-inbox group.  This is useful for giving
            public-inbox-nntpd access to a TLS certificate / key, for
            example.
          '';
        };
      };

      nntpServer = mkOption {
        type = with types; listOf str;
        default = [];
        example = [ "nntp://news.public-inbox.org" "nntps://news.public-inbox.org" ];
        description = ''
          NNTP URLs to this public-inbox instance
        '';
      };

      wwwListing = mkOption {
        type = with types; enum [ "all" "404" "match=domain" ];
        default = "404";
        description = ''
          Controls which lists (if any) are listed for when the root
          public-inbox URL is accessed over HTTP.
        '';
      };

      spamAssassinRules = mkOption {
        type = with types; nullOr path;
        default = "${cfg.package.sa_config}/user/.spamassassin/user_prefs";
        description = ''
          SpamAssassin configuration specific to public-inbox
        '';
      };

      config = mkOption {
        type = types.attrs;
        default = {};
        description = ''
          Additional structured config for the public-inbox config file
        '';
      };
    };
  };

  config = mkIf cfg.enable {

    assertions = [
      { assertion = config.services.spamassassin.enable || !useSpamAssassin;
        message = ''
          public-inbox is configured to use SpamAssassin, but
          services.spamassassin.enable is false.  If you don't need
          spam checking, set services.public-inbox.mda.spamCheck and
          services.public-inbox.watch.spamCheck to null.
        '';
      }
      { assertion = cfg.path != [] || !useSpamAssassin;
        message = ''
          public-inbox is configured to use SpamAssassin, but there is
          no spamc executable in services.public-inbox.path.  If you
          don't need spam checking, set
          services.public-inbox.mda.spamCheck and
          services.public-inbox.watch.spamCheck to null.
        '';
      }
    ];

    users.users.public-inbox = {
      inherit home;
      group = "public-inbox";
      isSystemUser = true;
    };

    users.groups.public-inbox = {};

    systemd.sockets.public-inbox-httpd = {
      inherit (cfg.http) listenStreams;
      wantedBy = [ "sockets.target" ];
    };

    systemd.sockets.public-inbox-nntpd = {
      inherit (cfg.nntp) listenStreams;
      wantedBy = [ "sockets.target" ];
    };

    systemd.services.public-inbox-httpd = {
      inherit environment;
      serviceConfig.ExecStart = "${cfg.package}/bin/public-inbox-httpd ${psgi}";
      serviceConfig.NonBlocking = true;
      serviceConfig.DynamicUser = true;
      serviceConfig.SupplementaryGroups = [ "public-inbox" ];
    };

    systemd.services.public-inbox-nntpd = {
      inherit environment;
      serviceConfig.ExecStart = escapeShellArgs (
        [ "${cfg.package}/bin/public-inbox-nntpd" ] ++
        (optionals (cfg.nntp.cert != null) [ "--cert" cfg.nntp.cert ]) ++
        (optionals (cfg.nntp.key != null) [ "--key" cfg.nntp.key ])
      );
      serviceConfig.NonBlocking = true;
      serviceConfig.DynamicUser = true;
      serviceConfig.SupplementaryGroups = [ "public-inbox" ] ++ cfg.nntp.extraGroups;
    };

    systemd.services.public-inbox-watch = {
      inherit environment;
      inherit (cfg) path;
      after = optional (cfg.watch.spamCheck == "spamc") "spamassassin.service";
      wantedBy = optional enableWatch "multi-user.target";
      serviceConfig.ExecStart = "${cfg.package}/bin/public-inbox-watch";
      serviceConfig.ExecReload = "${pkgs.coreutils}/bin/kill -HUP $MAINPID";
      serviceConfig.User = "public-inbox";
    };

    system.activationScripts.public-inbox = stringAfter [ "users" ] ''
      install -m 0755 -o public-inbox -g public-inbox -d /var/lib/public-inbox
      install -m 0750 -o public-inbox -g public-inbox -d ${inboxesDir}
      install -m 0700 -o public-inbox -g public-inbox -d /var/lib/public-inbox/emergency

      ${optionalString useSpamAssassin ''
        install -m 0700 -o spamd -d /var/lib/public-inbox/spamassassin
        ${optionalString (cfg.spamAssassinRules != null) ''
          ln -sf ${cfg.spamAssassinRules} /var/lib/public-inbox/spamassassin/user_prefs
        ''}
      ''}

      ${concatStrings (mapAttrsToList (name: { address, url, ... } @ inbox: ''
        if [ ! -e ${escapeShellArg (inboxPath name)} ]; then
            # public-inbox-init creates an inbox and adds it to a config file.
            # It tries to atomically write the config file by creating
            # another file in the same directory, and renaming it.
            # This has the sad consequence that we can't use
            # /dev/null, or it would try to create a file in /dev.
            conf_dir="$(${pkgs.sudo}/bin/sudo -u public-inbox mktemp -d)"

            ${pkgs.sudo}/bin/sudo -u public-inbox \
                env PI_CONFIG=$conf_dir/conf \
                ${cfg.package}/bin/public-inbox-init -V2 \
                ${escapeShellArgs ([ name (inboxPath name) url ] ++ address)}

            rm -rf $conf_dir
        fi

        ln -sf ${descriptionFile inbox} ${inboxPath name}/description

        if [ -d ${escapeShellArg (gitPath name)} ]; then
            # Config is inherited by each epoch repository,
            # so just needs to be set for all.git.
            ${pkgs.git}/bin/git --git-dir ${gitPath name} \
                config core.sharedRepository 0640
        fi
      '') cfg.inboxes)}

      for inbox in /var/lib/public-inbox/inboxes/*/; do
          ls -1 "$inbox" | grep -q '^xap' && continue

          # This should be idempotent, but only do it for new
          # inboxes anyway because it's only needed once, and could
          # be slow for large pre-existing inboxes.
          ${pkgs.sudo}/bin/sudo -u public-inbox \
              env ${concatStringsSep " " envList} \
              ${cfg.package}/bin/public-inbox-index "$inbox"
      done

    '';

    environment.systemPackages = with pkgs; [ cfg.package ];

  };
}

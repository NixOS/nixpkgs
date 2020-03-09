{ config, lib, pkgs, ... }:
with lib;

let
  cfg = config.services.moinmoin;
  python = pkgs.python27;
  pkg = python.pkgs.moinmoin;
  dataDir = "/var/lib/moin";
  usingGunicorn = cfg.webServer == "nginx-gunicorn" || cfg.webServer == "gunicorn";
  usingNginx = cfg.webServer == "nginx-gunicorn";
  user = "moin";
  group = "moin";

  uLit = s: ''u"${s}"'';
  indentLines = n: str: concatMapStrings (line: "${fixedWidthString n " " " "}${line}\n") (splitString "\n" str);

  moinCliWrapper = wikiIdent: pkgs.writeShellScriptBin "moin-${wikiIdent}" ''
    ${pkgs.su}/bin/su -s ${pkgs.runtimeShell} -c "${pkg}/bin/moin --config-dir=/var/lib/moin/${wikiIdent}/config $*" ${user}
  '';

  wikiConfig = wikiIdent: w: ''
    # -*- coding: utf-8 -*-

    from MoinMoin.config import multiconfig, url_prefix_static

    class Config(multiconfig.DefaultConfig):
        ${optionalString (w.webLocation != "/") ''
          url_prefix_static = '${w.webLocation}' + url_prefix_static
        ''}

        sitename = u'${w.siteName}'
        page_front_page = u'${w.frontPage}'

        data_dir = '${dataDir}/${wikiIdent}/data'
        data_underlay_dir = '${dataDir}/${wikiIdent}/underlay'

        language_default = u'${w.languageDefault}'
        ${optionalString (w.superUsers != []) ''
          superuser = [${concatMapStringsSep ", " uLit w.superUsers}]
        ''}

    ${indentLines 4 w.extraConfig}
  '';
  wikiConfigFile = name: wiki: pkgs.writeText "${name}.py" (wikiConfig name wiki);

in
{
  options.services.moinmoin = with types; {
    enable = mkEnableOption "MoinMoin Wiki Engine";

    webServer = mkOption {
      type = enum [ "nginx-gunicorn" "gunicorn" "none" ];
      default = "nginx-gunicorn";
      example = "none";
      description = ''
        Which web server to use to serve the wiki.
        Use <literal>none</literal> if you want to configure this yourself.
      '';
    };

    gunicorn.workers = mkOption {
      type = ints.positive;
      default = 3;
      example = 10;
      description = ''
        The number of worker processes for handling requests.
      '';
    };

    wikis = mkOption {
      type = attrsOf (submodule ({ name, ... }: {
        options = {
          siteName = mkOption {
            type = str;
            default = "Untitled Wiki";
            example = "ExampleWiki";
            description = ''
              Short description of your wiki site, displayed below the logo on each page, and
              used in RSS documents as the channel title.
            '';
          };

          webHost = mkOption {
            type = str;
            description = "Host part of the wiki URL. If undefined, the name of the attribute set will be used.";
            example = "wiki.example.org";
          };

          webLocation = mkOption {
            type = str;
            default = "/";
            example = "/moin";
            description = "Location part of the wiki URL.";
          };

          frontPage = mkOption {
            type = str;
            default = "LanguageSetup";
            example = "FrontPage";
            description = ''
              Front page name. Set this to something like <literal>FrontPage</literal> once languages are
              configured.
            '';
          };

          superUsers = mkOption {
            type = listOf str;
            default = [];
            example = [ "elvis" ];
            description = ''
              List of trusted user names with wiki system administration super powers.

              Please note that accounts for these users need to be created using the <command>moin</command> command-line utility, e.g.:
              <command>moin-<replaceable>WIKINAME</replaceable> account create --name=<replaceable>NAME</replaceable> --email=<replaceable>EMAIL</replaceable> --password=<replaceable>PASSWORD</replaceable></command>.
            '';
          };

          languageDefault = mkOption {
            type = str;
            default = "en";
            example = "de";
            description = "The ISO-639-1 name of the main wiki language. Languages that MoinMoin does not support are ignored.";
          };

          extraConfig = mkOption {
            type = lines;
            default = "";
            example = ''
              show_hosts = True
              search_results_per_page = 100
              acl_rights_default = u"Known:read,write,delete,revert All:read"
              logo_string = u"<h2>\U0001f639</h2>"
              theme_default = u"modernized"

              user_checkbox_defaults = {'show_page_trail': 0, 'edit_on_doubleclick': 0}
              navi_bar = [u'SomePage'] + multiconfig.DefaultConfig.navi_bar
              actions_excluded = multiconfig.DefaultConfig.actions_excluded + ['newaccount']

              mail_smarthost = "mail.example.org"
              mail_from = u"Example.Org Wiki <wiki@example.org>"
            '';
            description = ''
              Additional configuration to be appended verbatim to this wiki's config.

              See <link xlink:href='http://moinmo.in/HelpOnConfiguration' /> for documentation.
            '';
          };

        };
        config = {
          webHost = mkDefault name;
        };
      }));
      example = literalExample ''
        {
          "mywiki" = {
            siteName = "Example Wiki";
            webHost = "wiki.example.org";
            superUsers = [ "admin" ];
            frontPage = "Index";
            extraConfig = "page_category_regex = ur'(?P<all>(Category|Kategorie)(?P<key>(?!Template)\S+))'"
          };
        }
      '';
      description = ''
        Configurations of the individual wikis. Attribute names must be valid Python
        identifiers of the form <literal>[A-Za-z_][A-Za-z0-9_]*</literal>.

        For every attribute <replaceable>WIKINAME</replaceable>, a helper script
        moin-<replaceable>WIKINAME</replaceable> is created which runs the
        <command>moin</command> command under the <literal>moin</literal> user (to avoid
        file ownership issues) and with the right configuration directory passed to it.
      '';
    };
  };

  config = mkIf cfg.enable {
    assertions = forEach (attrNames cfg.wikis) (wname:
      { assertion = builtins.match "[A-Za-z_][A-Za-z0-9_]*" wname != null;
        message = "${wname} is not valid Python identifier";
      }
    );

    users.users = {
      moin = {
        description = "MoinMoin wiki";
        home = dataDir;
        group = group;
        isSystemUser = true;
      };
    };

    users.groups = {
      moin = {
        members = mkIf usingNginx [ config.services.nginx.user ];
      };
    };

    environment.systemPackages = [ pkg ] ++ map moinCliWrapper (attrNames cfg.wikis);

    systemd.services = mkIf usingGunicorn
      (flip mapAttrs' cfg.wikis (wikiIdent: wiki:
        nameValuePair "moin-${wikiIdent}"
          {
            description = "MoinMoin wiki ${wikiIdent} - gunicorn process";
            wantedBy = [ "multi-user.target" ];
            after = [ "network.target" ];
            restartIfChanged = true;
            restartTriggers = [ (wikiConfigFile wikiIdent wiki) ];

            environment = let
              penv = python.buildEnv.override {
                # setuptools: https://github.com/benoitc/gunicorn/issues/1716
                extraLibs = [ python.pkgs.gevent python.pkgs.setuptools pkg ];
              };
            in {
              PYTHONPATH = "${dataDir}/${wikiIdent}/config:${penv}/${python.sitePackages}";
            };

            preStart = ''
              umask 0007
              rm -rf ${dataDir}/${wikiIdent}/underlay
              cp -r ${pkg}/share/moin/underlay ${dataDir}/${wikiIdent}/
              chmod -R u+w ${dataDir}/${wikiIdent}/underlay
            '';

            serviceConfig = {
              User = user;
              Group = group;
              WorkingDirectory = "${dataDir}/${wikiIdent}";
              ExecStart = ''${python.pkgs.gunicorn}/bin/gunicorn moin_wsgi \
                --name gunicorn-${wikiIdent} \
                --workers ${toString cfg.gunicorn.workers} \
                --worker-class gevent \
                --bind unix:/run/moin/${wikiIdent}/gunicorn.sock
              '';

              Restart = "on-failure";
              RestartSec = "2s";
              StartLimitIntervalSec = "30s";

              StateDirectory = "moin/${wikiIdent}";
              StateDirectoryMode = "0750";
              RuntimeDirectory = "moin/${wikiIdent}";
              RuntimeDirectoryMode = "0750";

              NoNewPrivileges = true;
              ProtectSystem = "strict";
              ProtectHome = true;
              PrivateTmp = true;
              PrivateDevices = true;
              PrivateNetwork = true;
              ProtectKernelTunables = true;
              ProtectKernelModules = true;
              ProtectControlGroups = true;
              RestrictAddressFamilies = [ "AF_UNIX" "AF_INET" "AF_INET6" ];
              RestrictNamespaces = true;
              LockPersonality = true;
              MemoryDenyWriteExecute = true;
              RestrictRealtime = true;
            };
          }
      ));

    services.nginx = mkIf usingNginx {
      enable = true;
      virtualHosts = flip mapAttrs' cfg.wikis (name: w: nameValuePair w.webHost {
        forceSSL = mkDefault true;
        enableACME = mkDefault true;
        locations."${w.webLocation}" = {
          extraConfig = ''
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
            proxy_set_header X-Forwarded-Host $host;
            proxy_set_header X-Forwarded-Server $host;

            proxy_pass http://unix:/run/moin/${name}/gunicorn.sock;
          '';
        };
      });
    };

    systemd.tmpfiles.rules = [
      "d  /run/moin            0750 ${user} ${group} - -"
      "d  ${dataDir}           0550 ${user} ${group} - -"
    ]
    ++ (concatLists (flip mapAttrsToList cfg.wikis (wikiIdent: wiki: [
      "d  ${dataDir}/${wikiIdent}                      0750 ${user} ${group} - -"
      "d  ${dataDir}/${wikiIdent}/config               0550 ${user} ${group} - -"
      "L+ ${dataDir}/${wikiIdent}/config/wikiconfig.py -    -       -        - ${wikiConfigFile wikiIdent wiki}"
      # needed in order to pass module name to gunicorn
      "L+ ${dataDir}/${wikiIdent}/config/moin_wsgi.py  -    -       -        - ${pkg}/share/moin/server/moin.wsgi"
      # seed data files
      "C  ${dataDir}/${wikiIdent}/data                 0770 ${user} ${group} - ${pkg}/share/moin/data"
      # fix nix store permissions
      "Z  ${dataDir}/${wikiIdent}/data                 0770 ${user} ${group} - -"
    ])));
  };

  meta.maintainers = with lib.maintainers; [ b42 ];
}

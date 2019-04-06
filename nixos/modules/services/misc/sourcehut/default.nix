{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.sourcehut;

  bcfg = cfg.builds;
  dcfg = cfg.dispatch;
  gcfg = cfg.git;
  hcfg = cfg.hg;
  lcfg = cfg.lists;
  macfg = cfg.man;
  mecfg = cfg.meta;
  tcfg = cfg.todo;

  inherit (import ./helpers.nix { inherit lib; }) oauthOpts databaseOpts;

  baseSrHtServiceOpts = service: port: user: ({
    enable = mkOption {
      type = types.bool;
      default = cfg.enable && elem service cfg.services;
      description = ''
        Whether or not to implement the sub service so that it actually functions.
      '';
    };

    statePath = mkOption {
      type = types.path;
      default = "/var/sourcehut/${service}/state";
      description = ''
        ${service}.sr.ht state directory.
      '';
    };

    package = mkOption {
      type = types.package;
      default = pkgs.sourcehut."${service}";
      description = ''
        The package for ${service}.sr.ht.
      '';
    };

    domain = mkOption {
      type = types.str;
      default = "${service}.sr.ht.local";
      description = ''
        Domain ${service}.sr.ht is being served at.
      '';
    };

    port = mkOption {
      type = types.port;
      default = port;
      description = ''
        Port to host ${service}.sr.ht on.
      '';
    };

    user = mkOption {
      type = types.str;
      default = user;
      description = ''
        ${service}.sr.ht user.
      '';
    };

    debug.host = mkOption {
      type = types.str;
      default = "0.0.0.0";
      description = ''
        Address to bind the debug server to.
      '';
    };

    debug.port = mkOption {
      type = types.port;
      default = port;
      description = ''
        Port to bind the debug server to.
      '';
    };

    database = mkOption {
      type = types.submodule databaseOpts;
      default = { dbname = "${service}.sr.ht"; };
      description = ''
        ${service}.sr.ht database configuration.
      '';
    };

    extraConfig = mkOption {
      type = types.lines;
      default = "";
      description = ''
        Extra configuration for ${service}.sr.ht.
      '';
    };
  } // (optionalAttrs (service != "hg") { # NOTE: hg currently doesn't support alembic
    migrateOnUpgrade = mkOption {
      type = types.enum [ "yes" "no" ];
      default = "yes";
      description = ''
        Automatically run migrations on package upgrades.
      '';
    };
  }) // (optionalAttrs (service != "meta") {
    oauth = mkOption {
      type = types.submodule oauthOpts;
      default = {};
      description = ''
        OAuth client secret for ${service}.sr.ht from meta.sr.ht, register
        your client at meta.example.org/oauth.
      '';
    };
  }));

  srhtSource = if (cfg.config != null)
    then cfg.config
    else (import ./generate-config.nix { inherit lib; }) cfg;

  srhtConfig = if (cfg.configFile != null)
    then cfg.configFile
    else pkgs.writeText "config.ini" srhtSource;
in {
  imports =
    [
      ./builds.nix
      ./dispatch.nix
      ./git.nix
      ./hg.nix
      ./lists.nix
      ./man.nix
      ./meta.nix
      ./todo.nix
    ];

  options = {
    services.sourcehut = {
      builds = baseSrHtServiceOpts "builds" 5002 "buildsrht";
      dispatch = baseSrHtServiceOpts "dispatch" 5005 "dispatchsrht";
      git = baseSrHtServiceOpts "git" 5001 "gitsrht";
      hg = baseSrHtServiceOpts "hg" 5010 "hgsrht";
      lists = baseSrHtServiceOpts "lists" 5006 "listssrht";
      man = baseSrHtServiceOpts "man" 5004 "mansrht";
      meta = baseSrHtServiceOpts "meta" 5000 "metasrht";
      todo = baseSrHtServiceOpts "todo" 5003 "todosrht";

      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Enable sourcehut - git hosting, continuous integration, mailing list, ticket tracking,
          task dispatching, wiki and account management services.
        '';
      };

      services = mkOption {
        type = types.nonEmptyListOf (types.enum [ "builds" "dispatch" "git" "hg" "lists" "man" "meta" "todo" ]);
        default = [ "builds" "dispatch" "git" "hg" "lists" "man" "meta" "todo" ];
        description = ''
          Services to enable on the sourcehut network.
        '';
      };

      config = mkOption {
        type = types.nullOr types.lines;
        default = null;
        description = ''
          The configuration for the sourcehut network. This takes precedence over
          NixOS configuration but is overrided by configFile.

          Note: user and port will still need to be specified for each service if the defaults are
          not followed.
        '';
      };

      configFile = mkOption {
        type = types.nullOr types.path;
        default = null;
        description = ''
          The configuration file for the sourcehut network. This takes precedence
          over any other way configuration is specified.

          Note: user and port will still need to be specified for each service if the defaults are
          not followed.
        '';
      };

      python = mkOption {
        type = types.package;
        default = pkgs.sourcehut.python.withPackages (ps: (singleton ps.gunicorn)
          ++ map
            (service: ps."${cfg."${service}".package.pname}")
            (lib.filter (service: cfg."${service}".enable) cfg.services));
        description = ''
          The python package to use. It should contain references to the buildsrht, dispatchsrht,
          gitsrht, listssrht, mansrht, metasrht, and todosrht modules. Should also include the
          gunicorn module.
        '';
      };

      address = mkOption {
        type = types.str;
        default = "127.0.0.1";
        description = ''
          Where the sourcehut network should be hosted.
        '';
      };

      site.name = mkOption {
        type = types.str;
        default = "sourcehut";
        description = ''
          The name of your network of sourcehut-based sites.
        '';
      };

      site.info = mkOption {
        type = types.str;
        default = "https://sourcehut.org";
        description = ''
          The top-level info page for your site.
        '';
      };

      # TODO: Make a better description
      site.blurb = mkOption {
        type = types.str;
        default = "the hacker's forge";
        description = ''
          {{ site-name }}, {{ site-blurb }}
        '';
      };

      owner.name = mkOption {
        type = types.str;
        default = "";
        description = ''
          The site owner's name.
        '';
      };

      owner.email = mkOption {
        type = types.str;
        default = "";
        description = ''
          The site owner's email
        '';
      };

      source = mkOption {
        type = types.str;
        default = "https://git.sr.ht/~sircmpwn/srht";
        description = ''
          The source code for your fork of sourcehut.
        '';
      };

      secretKey = mkOption {
        # TODO: Assertion, make it required?
        type = types.nullOr types.str;
        default = "CHANGEME";
        description = ''
          A secret key to encrypt session cookies with.
        '';
      };

      extraConfig = mkOption {
        type = types.lines;
        default = "";
        description = ''
          Extra configuration for sourcehut.
        '';
      };

      # @tomberek
      # "server.protocol is very handy. Otherwise things like the login/register links are the wrong
      # protocol (yes, the redirect works, but why constantly redirect if it’s not needed?). This
      # has particular impact during OAuth flows. I was stuck for a while unable to finish the
      # authorization of the todo service because the underlying /oauth/exchange route expects it’s
      # POST calls to return a 200, rather than a 302. Perhaps there are some upstream changes that
      # can be done to also mitigate this, but i like being able to specify it."
      server.protocol = mkOption {
        type = types.enum [ "http" "https" ];
        default = "http";
        description = ''
        '';
      };

      mail.host = mkOption {
        type = types.str;
        default = "";
        description = ''
          SMTP host.
        '';
      };

      mail.port = mkOption {
        type = types.either types.str types.port;
        default = "";
        description = ''
          SMTP port.
        '';
      };

      mail.user = mkOption {
        type = types.str;
        default = "";
        description = ''
          SMTP user.
        '';
      };

      mail.password = mkOption {
        type = types.str;
        default = "";
        description = ''
          SMTP password.
        '';
      };

      mail.from = mkOption {
        type = types.str;
        default = "";
        description = ''
          SMTP from.
        '';
      };

      mail.error.to = mkOption {
        type = types.str;
        default = "";
        description = ''
          Application exceptions are emailed to this address.
        '';
      };

      mail.error.from = mkOption {
        type = types.str;
        default = "";
        # TODO: Wait what
        description = ''
          Application exceptions are emailed from this address.
        '';
      };

      mail.pgp.privateKey = mkOption {
        type = types.str;
        default = "";
        description = ''
          PGP private key.
        '';
      };

      mail.pgp.publicKey = mkOption {
        type = types.str;
        default = "";
        description = ''
          PGP public key
        '';
      };

      mail.pgp.keyId = mkOption {
        type = types.str;
        default = "";
        description = ''
          PGP key id.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    assertions =
      [
        # NOTE: Assertions must be true, errors if false
        # NOTE: These are false if services are hosted separately
        # { assertion = cfg.enable -> elem "meta" cfg.services;
        #   message = "The sourcehut network needs at least the meta service."; }

        # { assertion = cfg.enable -> elem "dispatch" cfg.services -> elem "builds" cfg.services;
        #   message = "The dispatch service depends on the builds service."; }

        # # TODO: Implement
        # { assertion = true;
        #   message = "Sourcehut services can't be hosted on conflicting port."; }

        # # NOTE: Not really...?
        # { assertion = cfg.configFile == null && cfg.secretKey != null;
        #   message = "The secret key needs to be specified."; }
      ];

    environment.etc."sr.ht/config.ini".source = srhtConfig;

    services = {
      # Cron daemon
      cron.enable = true;
      # Redis server
      redis = {
        enable = true;
        port = 6379;
        # TODO: localhost
        bind = "127.0.0.1";
        # TODO: More like 2?
        databases = 8;
      };
      # Mail server
      postfix.enable = true;
      # PostgreSQL server
      postgresql.enable = true;
    };

    systemd = {
      # 0750 default dir
      # 2770 /repos
      # 0700 /uploads
      tmpfiles.rules = let
        implementedServices = lib.filter (service: cfg."${service}".enable) cfg.services;
      in (map # Generate the $HOME directories for each subservice
        (subService: with cfg."${subService}"; "d ${statePath}/home 0750 ${user} ${user} -")
        implementedServices)
      ++ (map # Generate the directories which will contain the directories for git, hg, and man
        (subService: with cfg."${subService}".repos; "d ${path} 2770 ${user} ${user} -")
        (lib.filter (subService: builtins.hasAttr "repos" cfg."${subService}") implementedServices));

      services = let
        baseServiceConfig = serviceConfig: {
          path = with pkgs; [
            git
            sudo
            cfg.python
            config.services.postgresql.package
          ];

          environment = {
            HOME = "${serviceConfig.statePath}/home";
          };
          serviceConfig = {
            Type = "simple";
            User = serviceConfig.user;
            Group = serviceConfig.user;
            Restart = "always";
            WorkingDirectory = "${serviceConfig.statePath}/home";
            # NOTE: preStart only works as root - at least through nixops libvirtd
            PermissionsStartOnly = true;
          };

          preStart = let
            pgSuperUser = config.services.postgresql.superUser;

            setupDB = pkgs.writeScript "${serviceConfig.user}-gen-db" ''
              #! ${cfg.python}/bin/python
              from ${serviceConfig.user}.app import db
              db.create()
            '';
          in ''
            if ! test -e ${serviceConfig.statePath}/db; then
              # Setup the initial database
              sudo -u ${pgSuperUser} psql postgres -c "CREATE ROLE ${serviceConfig.user} WITH LOGIN NOCREATEDB NOCREATEROLE"
              sudo -u ${pgSuperUser} createdb --owner ${serviceConfig.user} ${serviceConfig.database.dbname}
              sudo -u ${serviceConfig.user} ${setupDB}

              ${optionalString (builtins.hasAttr "migrateOnUpgrade" serviceConfig) ''
                # Run alembic stamp head once to tell alembic the schema is up-to-date
                sudo -u ${serviceConfig.user} ${cfg.python}/bin/${serviceConfig.package.pname}-migrate stamp head
              ''}

              # Mark down current package version
              printf "%s" "${serviceConfig.package.version}" > ${serviceConfig.statePath}/db
            fi

            ${optionalString (builtins.hasAttr "migrateOnUpgrade" serviceConfig && serviceConfig.migrateOnUpgrade == "yes") ''
              if [ "$(cat ${serviceConfig.statePath}/db)" != "${serviceConfig.package.version}" ]; then
                # Manage schema migrations using alembic
                sudo -u ${serviceConfig.user} ${cfg.python}/bin/${serviceConfig.package.pname}-migrate -a upgrade head

                # Mark down current package version
                printf "%s" "${serviceConfig.package.version}" > ${serviceConfig.statePath}/db
              fi
            ''}
          '';
        };
      in builtins.listToAttrs (map
        (service: nameValuePair "${service}.sr.ht" (baseServiceConfig cfg."${service}"))
        (lib.filter (service: cfg."${service}".enable) cfg.services));
    };
  };
}

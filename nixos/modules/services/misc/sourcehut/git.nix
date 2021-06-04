{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.services.sourcehut;
  scfg = cfg.git;
  iniKey = "git.sr.ht";

  rcfg = config.services.redis;
  drv = pkgs.sourcehut.gitsrht;
in
{
  options.services.sourcehut.git = {
    user = mkOption {
      type = types.str;
      visible = false;
      internal = true;
      readOnly = true;
      default = "git";
      description = ''
        User for git.sr.ht.
      '';
    };

    port = mkOption {
      type = types.port;
      default = 5001;
      description = ''
        Port on which the "git" module should listen.
      '';
    };

    database = mkOption {
      type = types.str;
      default = "git.sr.ht";
      description = ''
        PostgreSQL database name for git.sr.ht.
      '';
    };

    statePath = mkOption {
      type = types.path;
      default = "${cfg.statePath}/gitsrht";
      description = ''
        State path for git.sr.ht.
      '';
    };

    package = mkOption {
      type = types.package;
      default = pkgs.git;
      example = literalExample "pkgs.gitFull";
      description = ''
        Git package for git.sr.ht. This can help silence collisions.
      '';
    };
  };

  config = with scfg; lib.mkIf (cfg.enable && elem "git" cfg.services) {
    # sshd refuses to run with `Unsafe AuthorizedKeysCommand ... bad ownership or modes for directory /nix/store`
    environment.etc."ssh/gitsrht-dispatch" = {
      mode = "0755";
      text = ''
        #! ${pkgs.stdenv.shell}
        ${cfg.python}/bin/gitsrht-dispatch "$@"
      '';
    };

    # Needs this in the $PATH when sshing into the server
    environment.systemPackages = [ cfg.git.package ];

    users = {
      users = {
        "${user}" = {
          isSystemUser = true;
          group = user;
          # https://stackoverflow.com/questions/22314298/git-push-results-in-fatal-protocol-error-bad-line-length-character-this
          # Probably could use gitsrht-shell if output is restricted to just parameters...
          shell = pkgs.bash;
          description = "git.sr.ht user";
        };
      };

      groups = {
        "${user}" = { };
      };
    };

    services = {
      cron.systemCronJobs = [ "*/20 * * * * ${cfg.python}/bin/gitsrht-periodic" ];
      fcgiwrap.enable = true;

      openssh.authorizedKeysCommand = ''/etc/ssh/gitsrht-dispatch "%u" "%h" "%t" "%k"'';
      openssh.authorizedKeysCommandUser = "root";
      openssh.extraConfig = ''
        PermitUserEnvironment SRHT_*
      '';

      postgresql = {
        authentication = ''
          local ${database} ${user} trust
        '';
        ensureDatabases = [ database ];
        ensureUsers = [
          {
            name = user;
            ensurePermissions = { "DATABASE \"${database}\"" = "ALL PRIVILEGES"; };
          }
        ];
      };
    };

    systemd = {
      tmpfiles.rules = [
        # /var/log is owned by root
        "f /var/log/git-srht-shell 0644 ${user} ${user} -"

        "d ${statePath} 0750 ${user} ${user} -"
        "d ${cfg.settings."${iniKey}".repos} 2755 ${user} ${user} -"
      ];

      services = {
        gitsrht = import ./service.nix { inherit config pkgs lib; } scfg drv iniKey {
          after = [ "redis.service" "postgresql.service" "network.target" ];
          requires = [ "redis.service" "postgresql.service" ];
          wantedBy = [ "multi-user.target" ];

          # Needs internally to create repos at the very least
          path = [ pkgs.git ];
          description = "git.sr.ht website service";

          serviceConfig.ExecStart = "${cfg.python}/bin/gunicorn ${drv.pname}.app:app -b ${cfg.address}:${toString port}";
        };

        gitsrht-webhooks = {
          after = [ "postgresql.service" "network.target" ];
          requires = [ "postgresql.service" ];
          wantedBy = [ "multi-user.target" ];

          description = "git.sr.ht webhooks service";
          serviceConfig = {
            Type = "simple";
            User = user;
            Restart = "always";
          };

          serviceConfig.ExecStart = "${cfg.python}/bin/celery -A ${drv.pname}.webhooks worker --loglevel=info";
        };
      };
    };

    services.sourcehut.settings = {
      # URL git.sr.ht is being served at (protocol://domain)
      "git.sr.ht".origin = mkDefault "http://git.${cfg.originBase}";
      # Address and port to bind the debug server to
      "git.sr.ht".debug-host = mkDefault "0.0.0.0";
      "git.sr.ht".debug-port = mkDefault port;
      # Configures the SQLAlchemy connection string for the database.
      "git.sr.ht".connection-string = mkDefault "postgresql:///${database}?user=${user}&host=/var/run/postgresql";
      # Set to "yes" to automatically run migrations on package upgrade.
      "git.sr.ht".migrate-on-upgrade = mkDefault "yes";
      # The redis connection used for the webhooks worker
      "git.sr.ht".webhooks = mkDefault "redis://${rcfg.bind}:${toString rcfg.port}/1";

      # A post-update script which is installed in every git repo.
      "git.sr.ht".post-update-script = mkDefault "${pkgs.sourcehut.gitsrht}/bin/gitsrht-update-hook";

      # git.sr.ht's OAuth client ID and secret for meta.sr.ht
      # Register your client at meta.example.org/oauth
      "git.sr.ht".oauth-client-id = mkDefault null;
      "git.sr.ht".oauth-client-secret = mkDefault null;
      # Path to git repositories on disk
      "git.sr.ht".repos = mkDefault "/var/lib/git";

      "git.sr.ht".outgoing-domain = mkDefault "http://git.${cfg.originBase}";

      # The authorized keys hook uses this to dispatch to various handlers
      # The format is a program to exec into as the key, and the user to match as the
      # value. When someone tries to log in as this user, this program is executed
      # and is expected to omit an AuthorizedKeys file.
      #
      # Discard of the string context is in order to allow derivation-derived strings.
      # This is safe if the relevant package is installed which will be the case if the setting is utilized.
      "git.sr.ht::dispatch".${builtins.unsafeDiscardStringContext "${pkgs.sourcehut.gitsrht}/bin/gitsrht-keys"} = mkDefault "${user}:${user}";
    };

    services.nginx.virtualHosts."git.${cfg.originBase}" = {
      forceSSL = true;
      locations."/".proxyPass = "http://${cfg.address}:${toString port}";
      locations."/query".proxyPass = "http://${cfg.address}:${toString (port + 100)}";
      locations."/static".root = "${pkgs.sourcehut.gitsrht}/${pkgs.sourcehut.python.sitePackages}/gitsrht";
      extraConfig = ''
            location = /authorize {
            proxy_pass http://${cfg.address}:${toString port};
            proxy_pass_request_body off;
            proxy_set_header Content-Length "";
            proxy_set_header X-Original-URI $request_uri;
        }
            location ~ ^/([^/]+)/([^/]+)/(HEAD|info/refs|objects/info/.*|git-upload-pack).*$ {
                auth_request /authorize;
                root /var/lib/git;
                fastcgi_pass unix:/run/fcgiwrap.sock;
                fastcgi_param SCRIPT_FILENAME ${pkgs.git}/bin/git-http-backend;
                fastcgi_param PATH_INFO $uri;
                fastcgi_param GIT_PROJECT_ROOT $document_root;
                fastcgi_read_timeout 500s;
                include ${pkgs.nginx}/conf/fastcgi_params;
                gzip off;
            }
      '';

    };
  };
}

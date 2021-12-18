{ config, lib, options, pkgs, ... }:

with lib;
let
  cfg = config.services.sourcehut;
  opt = options.services.sourcehut;
  scfg = cfg.hg;
  iniKey = "hg.sr.ht";

  rcfg = config.services.redis;
  drv = pkgs.sourcehut.hgsrht;
in
{
  options.services.sourcehut.hg = {
    user = mkOption {
      type = types.str;
      internal = true;
      readOnly = true;
      default = "hg";
      description = ''
        User for hg.sr.ht.
      '';
    };

    port = mkOption {
      type = types.port;
      default = 5010;
      description = ''
        Port on which the "hg" module should listen.
      '';
    };

    database = mkOption {
      type = types.str;
      default = "hg.sr.ht";
      description = ''
        PostgreSQL database name for hg.sr.ht.
      '';
    };

    statePath = mkOption {
      type = types.path;
      default = "${cfg.statePath}/hgsrht";
      defaultText = literalExpression ''"''${config.${opt.statePath}}/hgsrht"'';
      description = ''
        State path for hg.sr.ht.
      '';
    };

    cloneBundles = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Generate clonebundles (which require more disk space but dramatically speed up cloning large repositories).
      '';
    };
  };

  config = with scfg; lib.mkIf (cfg.enable && elem "hg" cfg.services) {
    # In case it ever comes into being
    environment.etc."ssh/hgsrht-dispatch" = {
      mode = "0755";
      text = ''
        #! ${pkgs.stdenv.shell}
        ${cfg.python}/bin/gitsrht-dispatch $@
      '';
    };

    environment.systemPackages = [ pkgs.mercurial ];

    users = {
      users = {
        "${user}" = {
          isSystemUser = true;
          group = user;
          # Assuming hg.sr.ht needs this too
          shell = pkgs.bash;
          description = "hg.sr.ht user";
        };
      };

      groups = {
        "${user}" = { };
      };
    };

    services = {
      cron.systemCronJobs = [ "*/20 * * * * ${cfg.python}/bin/hgsrht-periodic" ]
        ++ optional cloneBundles "0 * * * * ${cfg.python}/bin/hgsrht-clonebundles";

      openssh.authorizedKeysCommand = ''/etc/ssh/hgsrht-dispatch "%u" "%h" "%t" "%k"'';
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
        "f /var/log/hg-srht-shell 0644 ${user} ${user} -"

        "d ${statePath} 0750 ${user} ${user} -"
        "d ${cfg.settings."${iniKey}".repos} 2755 ${user} ${user} -"
      ];

      services.hgsrht = import ./service.nix { inherit config pkgs lib; } scfg drv iniKey {
        after = [ "redis.service" "postgresql.service" "network.target" ];
        requires = [ "redis.service" "postgresql.service" ];
        wantedBy = [ "multi-user.target" ];

        path = [ pkgs.mercurial ];
        description = "hg.sr.ht website service";

        serviceConfig.ExecStart = "${cfg.python}/bin/gunicorn ${drv.pname}.app:app -b ${cfg.address}:${toString port}";
      };
    };

    services.sourcehut.settings = {
      # URL hg.sr.ht is being served at (protocol://domain)
      "hg.sr.ht".origin = mkDefault "http://hg.${cfg.originBase}";
      # Address and port to bind the debug server to
      "hg.sr.ht".debug-host = mkDefault "0.0.0.0";
      "hg.sr.ht".debug-port = mkDefault port;
      # Configures the SQLAlchemy connection string for the database.
      "hg.sr.ht".connection-string = mkDefault "postgresql:///${database}?user=${user}&host=/var/run/postgresql";
      # The redis connection used for the webhooks worker
      "hg.sr.ht".webhooks = mkDefault "redis://${rcfg.bind}:${toString rcfg.port}/1";
      # A post-update script which is installed in every mercurial repo.
      "hg.sr.ht".changegroup-script = mkDefault "${cfg.python}/bin/hgsrht-hook-changegroup";
      # hg.sr.ht's OAuth client ID and secret for meta.sr.ht
      # Register your client at meta.example.org/oauth
      "hg.sr.ht".oauth-client-id = mkDefault null;
      "hg.sr.ht".oauth-client-secret = mkDefault null;
      # Path to mercurial repositories on disk
      "hg.sr.ht".repos = mkDefault "/var/lib/hg";
      # Path to the srht mercurial extension
      # (defaults to where the hgsrht code is)
      # "hg.sr.ht".srhtext = mkDefault null;
      # .hg/store size (in MB) past which the nightly job generates clone bundles.
      # "hg.sr.ht".clone_bundle_threshold = mkDefault 50;
      # Path to hg-ssh (if not in $PATH)
      # "hg.sr.ht".hg_ssh = mkDefault /path/to/hg-ssh;

      # The authorized keys hook uses this to dispatch to various handlers
      # The format is a program to exec into as the key, and the user to match as the
      # value. When someone tries to log in as this user, this program is executed
      # and is expected to omit an AuthorizedKeys file.
      #
      # Uncomment the relevant lines to enable the various sr.ht dispatchers.
      "hg.sr.ht::dispatch"."/run/current-system/sw/bin/hgsrht-keys" = mkDefault "${user}:${user}";
    };

    # TODO: requires testing and addition of hg-specific requirements
    services.nginx.virtualHosts."hg.${cfg.originBase}" = {
      forceSSL = true;
      locations."/".proxyPass = "http://${cfg.address}:${toString port}";
      locations."/query".proxyPass = "http://${cfg.address}:${toString (port + 100)}";
      locations."/static".root = "${pkgs.sourcehut.hgsrht}/${pkgs.sourcehut.python.sitePackages}/hgsrht";
    };
  };
}

{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.services.overleaf;

  ferret = pkgs.ferretdb.overrideAttrs (final: prev: {
    patches = [ ./fields.patch ];
  });

  sagetex-fixed = pkgs.sagetex.overrideAttrs (final: prev: {
    buildInputs = with pkgs; [
      sage
      texlive.combined.scheme-full
    ];

    buildPhase = ''
      make all
    '';
    installPhase = prev.installPhase + ''
      mkdir $out/bin
      cp -va *.py "$out/bin"
    '';

    HOME = "/tmp/test";
  });

  overleafServices = [
    "chat"
    "clsi"
    "contacts"
    "docstore"
    "document-updater"
    "filestore"
    "notifications"
    "project-history"
    "real-time"
    "track-changes"
    "web"
  ] ++ (optional (cfg.dicts != [ ]) "spelling");

  latexmkrc = pkgs.writeText "latexmkrc" (optionalString (elem "pythontex" cfg.engines) ''
    #############
    # PythonTeX #
    #############
    $pytexmod = 'python3 ${head pkgs.texlive.pythontex.pkgs}/scripts/pythontex/pythontex3.py';

    $go_mode = 1;

    add_cus_dep('pytxcode', 'tex', 0, 'pythontex');
    add_cus_dep('pytxcode', 'Rtex', 0, 'pythontex');
    sub pythontex {
      return system("$pytexmod --error-exit-code false output &> ./pythontex.log") ;
    }

    $pdflatex = 'internal mylatex %S pdflatex -synctex=1 -interaction=batchmode %O %S';
    $latex = 'internal mylatex %S latex -synctex=1 -interaction=batchmode %O %S';
    $lualatex = 'internal mylatex %S lualatex -synctex=1 -interaction=batchmode %O %S';
    $xelatex = 'internal mylatex %S latex -synctex=1 -interaction=batchmode %O %S';

    use File::Basename;

    sub mylatex {
      (my $source, my $dir, my $ext) = fileparse(shift, qr/.tex/);
      if (! $source == 'output') {
        if (-l "$source.pytxcode"){
          unlink "$source.pytxcode";
        };
        if (-l "pythontex-files-$source"){
          unlink "pythontex-files-$source";
        };
        symlink 'output.pytxcode', "$source.pytxcode";
        symlink 'pythontex-files-output', "pythontex-files-$source";
      };
      return system @_;
    }

  '' + optionalString (elem "knitr" cfg.engines) ''
    #########
    # Knitr #
    #########
    add_cus_dep( 'Rtex', 'tex', 0, 'do_knitr');
    sub do_knitr {
      Run_subst(qq{Rscript -e 'library("knitr");
        opts_knit\$set(concordance=T);
        knitr::knit(%S, output=%D);' &> ./knitr.log});
    }

  '' + optionalString (elem "sagetex" cfg.engines) ''
    ###########
    # SageTeX #
    ###########

    $sagetexrun = 'sage ${sagetex-fixed}/tex/latex/sagetex/sagetex-run.py';

    $latex = "$latex ; $sagetexrun %B";
    $pdflatex = "$pdflatex ; $sagetexrun %B";

    add_cus_dep('sage', 'sout', 0, 'makesout');
    $hash_calc_ignore_pattern{'sage'} = '^( st.goboom|print .SageT)';
    sub makesout {
      system( "sage \"$_[0].sage\" &> sagetex.log" );
    }

  '' + cfg.latexmkrc);
in

{
  meta.maintainers = with maintainers; [ julienmalka camillemndn ];

  options.services.overleaf = {
    enable = mkEnableOption (mdDoc ''Overleaf'');

    hostname = mkOption {
      type = types.nullOr types.str;
      default = null;
      example = "overleaf.org";
      description = mdDoc ''This enable a default nginx reverse proxy configuration.'';
    };

    enableRedis = mkOption {
      type = types.bool;
      default = true;
      description = mdDoc ''Redis'';
    };

    mongodbType = mkOption {
      type = types.str;
      default = "mongodb";
      example = "ferretdb";
      description = mdDoc ''The type of MongoDB service to enable. One of "mongodb", "ferretdb" or "none".'';
    };

    texlivePackage = mkOption {
      type = types.package;
      default = pkgs.texlive.combined.scheme-basic;
      defaultText = literalExpression "pkgs.textlive.combined.scheme-basic";
      example = literalExpression "pkgs.texlive.combined.scheme-full";
      description = mdDoc ''
        The package for TeX Live. See
        <https://search.nixos.org/packages?query=texlive.combined>
        for available options.
      '';
    };

    settings = mkOption {
      type = types.submodule { freeformType = with types; attrsOf str; };
      default = { };
      example = {
        OVERLEAF_REDIS_HOST = "localhost";
        OVERLEAF_REDIS_PORT = "6379";
        WEB_HOST = "localhost";
        WEB_PORT = "3032";
        GRACEFUL_SHUTDOWN_DELAY = "0";
        OVERLEAF_SITE_URL = "https://overleaf.example.org";
        OVERLEAF_ADMIN_EMAIL = "overleaf@example.org";
        OVERLEAF_SITE_LANGUAGE = "fr";
        OVERLEAF_APP_NAME = "My self-hosted Overleaf instance";
        OVERLEAF_EMAIL_FROM_ADDRESS = "overleaf@example.org";
        OVERLEAF_EMAIL_SMTP_HOST = "mail.example.org";
        OVERLEAF_EMAIL_SMTP_PORT = "587";
        OVERLEAF_EMAIL_SMTP_SECURE = "true";
        OVERLEAF_EMAIL_SMTP_USER = "overleaf";
        ADMIN_PRIVILEGE_AVAILABLE = "true";
      };
      description = mdDoc ''
        Additional configuration for Overleaf, see
        <https://github.com/overleaf/overleaf/blob/main/server-ce/config/settings.js>
        for supported values.
      '';
    };

    secrets = mkOption {
      type = types.submodule { freeformType = with types; attrsOf str; };
      default = { };
      example = {
        WEB_API_PASSWORD = "/etc/secrets/web_api_pass";
        OVERLEAF_REDIS_PASS = "/run/secrets/overleaf_redis";
        OVERLEAF_SESSION_SECRET = "/run/secrets/overleaf_session";
        STAGING_PASSWORD_FILE = "/run/secrets/overleaf_staging";
        OVERLEAF_EMAIL_SMTP_PASS = "/run/secrets/mail/overleaf.example.org";
      };
      description = mdDoc ''
        Secrets for Overleaf, see
        <https://github.com/overleaf/overleaf/blob/main/server-ce/config/settings.js>
        for supported values.
      '';
    };

    path = mkOption {
      type = with types; listOf package;
      default = [ ];
      example = literalExpression "with pkgs; [ qpdf ]";
      description = mdDoc ''
        Additional packages to place in the path of the Overleaf services.
      '';
    };

    engines = mkOption {
      type = with types; listOf str;
      default = [ ];
      example = literalExpression ''[ "sagetex" ]'';
      description = mdDoc ''
        Additional engines to execute code when compiling LateX documents. Choose among
        "sagetex", "pythontex" and "knitr".
      '';
    };

    latexmkrc = mkOption {
      type = types.lines;
      default = "";
      description = mdDoc ''
        Extra contents appended to the LaTeX configuration file,
        .latexmkrc.
      '';
    };

    dicts = mkOption {
      type = with types; listOf package;
      default = [ ];
      example = literalExpression ''with pkgs.aspellDicts; [ en fr ]'';
      description = mdDoc ''
        Additional languages to add to overleaf spell check engine,
        based on aspell.
      '';
    };

    extraPythonPackages = mkOption {
      type = with types; listOf package;
      default = [ ];
      example = literalExpression ''with pkgs.python3Packages; [ matplotlib ]'';
      description = mdDoc ''
        Additional packages to add to the ```pythontex``` engine.
      '';
    };

    extraRPackages = mkOption {
      type = with types; listOf package;
      default = [ ];
      example = literalExpression ''with pkgs.rPackages; [ ggplot2 ]'';
      description = mdDoc ''
        Additional R packages to use with the ```knitr``` engine.
      '';
    };

    dockerSandboxes.enable = mkEnableOption (mdDoc ''
      Docker sandboxed compiles, provided the user adds
        ```virtualization.docker.enable = true;```
      to their configuration. It avoids read-access to all the filesystem by any Overleaf user.
    '');
  };

  config = mkIf cfg.enable (mkMerge [
    {
      services.overleaf.settings = {
        NODE_ENV = "production";
        # OVERLEAF_CONFIG = "${pkgs.overleaf}/share/server-ce/config/settings.js";
        OVERLEAF_CONFIG = "/var/lib/overleaf/settings.js";
        DATA_DIR = mkDefault "/var/lib/overleaf";
        OVERLEAF_MONGO_URL = mkDefault "mongodb://localhost:27017/overleaf";
        OVERLEAF_REDIS_PATH = mkDefault "/run/redis-overleaf/redis.sock";
        WEB_PORT = mkDefault "3032";
        WEB_API_USER = mkDefault "overleaf";
        GRACEFUL_SHUTDOWN_DELAY = mkDefault "0";
        OVERLEAF_FPH_DISPLAY_NEW_PROJECTS = mkDefault "true";
        SANDBOXED_COMPILES = mkIf cfg.dockerSandboxes.enable "true";
        TEX_LIVE_DOCKER_IMAGE = mkIf cfg.dockerSandboxes.enable "texlive/texlive";
      };

      systemd.targets.overleaf.requires = map (service: "overleaf-${service}.service") overleafServices;

      systemd.services =
        let
          activateServices = service: {
            "overleaf-${service}" = {
              description = "Overleaf ${service}";
              wantedBy = [ "overleaf.target" "multi-user.target" ];
              environment = cfg.settings;
              path = with pkgs; [ cfg.texlivePackage qpdf (aspellWithDicts (ps: with ps; cfg.dicts)) ] ++ cfg.path;
              serviceConfig = {
                Type = "simple";
                ExecStart = pkgs.writeShellScript "overleaf-${service}" ''
                  # This sources the secrets as environment variables, less secure but avoids a patch:
                  for secret in $(ls $CREDENTIALS_DIRECTORY)
                  do
                    export $secret=$(cat $CREDENTIALS_DIRECTORY/$secret)
                  done

                  # This softlinks the LaTeX configuration files to the home of Overleaf:
                  ${optionalString (cfg.engines != []) "ln -sf ${latexmkrc} /var/lib/overleaf/.latexmkrc"}

                  exec ${pkgs.overleaf}/bin/overleaf-${service}
                '';
                StateDirectory = "overleaf";
                WorkingDirectory = "/var/lib/overleaf";
                User = "overleaf";
                LoadCredential = mapAttrsToList (name: path: "${name}:${path}") cfg.secrets;
                SupplementaryGroups = mkIf cfg.dockerSandboxes.enable [ "docker" ];
                #InaccessibleDirectories = [ "/run" ];
                #PrivateTmp = true;
                ProtectHome = true;
                ProtectSystem = "strict";
                NoNewPrivileges = true;
                PrivateDevices = true;
                ProtectHostname = true;
                ProtectClock = true;
                ProtectKernelTunables = true;
                ProtectKernelModules = true;
                ProtectKernelLogs = true;
                ProtectControlGroups = true;
              };
            };
          };
        in
        mkMerge (map activateServices overleafServices);

      users.users.overleaf = {
        isSystemUser = true;
        group = "overleaf";
        home = "/var/lib/overleaf";
        createHome = true;
      };

      users.groups.overleaf = { };

      services.nginx = mkIf (isString cfg.hostname) {
        enable = true;
        recommendedOptimisation = mkDefault true;
        recommendedGzipSettings = mkDefault true;

        virtualHosts."${cfg.hostname}" = {
          locations."/" = {
            proxyPass = "http://localhost:${cfg.settings.WEB_PORT}";
            proxyWebsockets = true;
          };
          locations."/socket.io" = {
            proxyPass = "http://localhost:3026";
            proxyWebsockets = true;
            extraConfig = ''
              proxy_read_timeout 10m;
              proxy_send_timeout 10m;
            '';
          };
        };
      };

      services.redis.servers.overleaf = mkIf cfg.enableRedis {
        enable = true;
        user = "overleaf";
        port = 0;
      };
    }

    (mkIf (cfg.mongodbType == "mongodb") {
      services.mongodb = {
        enable = true;
        package = pkgs.mongodb-4_2;
      };
    })

    (mkIf (cfg.mongodbType == "ferretdb") {
      systemd.services.ferretdb = {
        description = "FerretDB";
        wantedBy = [ "multi-user.target" ];
        serviceConfig = {
          Type = "simple";
          ExecStart = "${ferret}/bin/ferretdb --postgresql-url=\"postgres://localhost/ferretdb?host=/run/postgresql\"";
          StateDirectory = "ferretdb";
          WorkingDirectory = "/var/lib/ferretdb";
          User = "ferretdb";
        };
      };
      systemd.services.postgresql.environment.LC_ALL = "en_US.UTF-8";

      users.users.ferretdb = {
        isSystemUser = true;
        group = "ferretdb";
        home = "/var/lib/ferretdb";
        createHome = true;
      };

      users.groups.ferretdb = { };

      services.postgresql = {
        enable = true;
        ensureDatabases = [ "ferretdb" ];
        ensureUsers = [{
          name = "ferretdb";
          ensurePermissions."DATABASE ferretdb" = "ALL PRIVILEGES";
        }];
      };
    })

    (mkIf (elem "sagetex" cfg.engines) {
      services.overleaf.texlivePackage = with pkgs; mkOverride 98 (texlive.combine {
        inherit (texlive) scheme-full;
        sagetex = { pkgs = [ sagetex-fixed ]; };
      });
      services.overleaf.path = [ pkgs.sage sagetex-fixed ];
      services.overleaf.settings.PYTHONPATH = with pkgs.python3.pkgs; makePythonPath ([ pygments ] ++ cfg.extraPythonPackages) + ":${sagetex-fixed}/bin";
    })

    (mkIf (elem "knitr" cfg.engines) {
      services.overleaf.path = with pkgs; [ (rWrapper.override { packages = with rPackages; [ knitr patchSynctex ] ++ cfg.extraRPackages; }) ];
    })

    (mkIf (elem "pythontex" cfg.engines) {
      services.overleaf.texlivePackage = mkOverride 99 pkgs.texlive.combined.scheme-full;
      services.overleaf.path = [ (pkgs.python3.withPackages (p: with p; [ pygments ] ++ cfg.extraPythonPackages)) ];
    })
  ]);
}

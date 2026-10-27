{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.flame;

  settingsFormat = pkgs.formats.json { };

  # Accepts either a list of strings or a raw semicolon-separated string.
  schemaToStr = x: if builtins.isList x then lib.concatStringsSep ";" x else x;

  # Needed to prepopulate DB
  sqlQuote = s: "'" + builtins.replaceStrings [ "'" ] [ "''" ] s + "'";

  seedSql = pkgs.writeText "flame-seed.sql" ''
    ${lib.optionalString (cfg.apps != [ ] || cfg.categories != [ ]) ''
      DELETE FROM bookmarks;
      DELETE FROM categories;
      DELETE FROM apps;
    ''}
    ${lib.concatMapStringsSep "\n" (app: ''
      INSERT INTO apps (name, url, icon, description, isPinned, createdAt, updatedAt)
      VALUES (${sqlQuote app.name}, ${sqlQuote app.url}, ${sqlQuote app.icon}, ${sqlQuote app.description}, ${
        if app.isPinned then "1" else "0"
      }, datetime('now'), datetime('now'));
    '') cfg.apps}
    ${lib.concatMapStringsSep "\n" (cat: ''
      INSERT INTO categories (name, isPinned, createdAt, updatedAt)
      VALUES (${sqlQuote cat.name}, ${
        if cat.isPinned then "1" else "0"
      }, datetime('now'), datetime('now'));
      ${lib.concatMapStringsSep "\n" (bm: ''
        INSERT INTO bookmarks (name, url, icon, categoryId, createdAt, updatedAt)
        VALUES (${sqlQuote bm.name}, ${sqlQuote bm.url}, ${sqlQuote bm.icon}, (SELECT id FROM categories WHERE name = ${sqlQuote cat.name} ORDER BY id DESC LIMIT 1), datetime('now'), datetime('now'));
      '') cat.bookmarks}
    '') cfg.categories}
  '';

  cssFile = pkgs.writeText "flame-custom.css" cfg.customCSS;

  # Build-time symlink farm of everything Flame ships except data/ and
  # public/, which are left as empty placeholders here and populated at
  # runtime (data/ is real state; public/ is refreshed from cfg.package
  # on every start, since it holds built client assets).
  appTree = pkgs.runCommand "flame-app-tree" { } ''
    mkdir -p $out
    for entry in ${cfg.package}/lib/flame/*; do
      name=$(basename "$entry")
      if [ "$name" != data ] && [ "$name" != public ]; then
        ln -s "$entry" "$out/$name"
      fi
    done
    mkdir -p $out/data $out/public
  '';

  # WEATHER_API_KEY is deliberately excluded here; it's injected at
  # runtime from `weatherApiKeyFile` so it never touches the Nix store.
  settingsFile = settingsFormat.generate "flame-settings.json" (
    lib.filterAttrs (n: _: n != "weatherApiKeyFile") cfg.settings
    // lib.optionalAttrs (cfg.settings ? greetingsSchema) {
      greetingsSchema = schemaToStr cfg.settings.greetingsSchema;
    }
    // lib.optionalAttrs (cfg.settings ? daySchema) {
      daySchema = schemaToStr cfg.settings.daySchema;
    }
    // lib.optionalAttrs (cfg.settings ? monthSchema) {
      monthSchema = schemaToStr cfg.settings.monthSchema;
    }
  );
in
{
  meta.maintainers = with lib.maintainers; [ DerGrumpf ];

  options.services.flame = {
    enable = lib.mkEnableOption "Flame, a self-hosted startpage for your server";
    package = lib.mkPackageOption pkgs "flame" { };

    port = lib.mkOption {
      type = lib.types.port;
      default = 5005;
      description = "Port on which to serve the Flame web interface.";
    };

    passwordFile = lib.mkOption {
      type = lib.types.path;
      description = ''
        Path to a file containing the password to log in to Flame's settings panel.
        This is the recommended option as it avoids storing the password in the Nix store.
        Compatible with sops-nix and agenix.
      '';
      example = "/run/secrets/flame-password";
    };

    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Whether to open the firewall for the port used by Flame.";
    };

    customCSS = lib.mkOption {
      type = lib.types.lines;
      default = "";
      description = ''
        Custom CSS injected into Flame's UI, written to
        {file}`public/flame.css` on every service start. Can also be used
        to define a fully custom theme via CSS custom properties — see
        [Flame's Custom CSS wiki page](https://github.com/pawelmalak/flame/wiki/Custom-CSS).
      '';
      example = ''
        .Home_SettingsButton__Qvn8C {
          border-radius: 0 !important;
        }
      '';
    };

    categories = lib.mkOption {
      type = lib.types.listOf (
        lib.types.submodule {
          options = {
            name = lib.mkOption {
              type = lib.types.str;
              description = "Name of the bookmark category.";
            };
            isPinned = lib.mkOption {
              type = lib.types.bool;
              default = false;
              description = "Whether the category is pinned by default.";
            };
            bookmarks = lib.mkOption {
              default = [ ];
              description = "Bookmarks belonging to this category.";
              type = lib.types.listOf (
                lib.types.submodule {
                  options = {
                    name = lib.mkOption {
                      type = lib.types.str;
                      description = "Name of the bookmark.";
                    };
                    url = lib.mkOption {
                      type = lib.types.str;
                      description = "URL of the bookmark.";
                    };
                    icon = lib.mkOption {
                      type = lib.types.str;
                      default = "";
                      description = "Icon name or URL for the bookmark.";
                    };
                  };
                }
              );
            };
          };
        }
      );
      default = [ ];
      description = ''
        Bookmark categories and their bookmarks. When non-empty, this
        fully replaces the contents of Flame's `categories` and
        `bookmarks` tables on every service start — any bookmarks added
        through the web UI will not persist across restarts.
      '';
      example = [
        {
          name = "Dev";
          bookmarks = [
            {
              name = "GitHub";
              url = "https://github.com";
            }
          ];
        }
      ];
    };

    apps = lib.mkOption {
      type = lib.types.listOf (
        lib.types.submodule {
          options = {
            name = lib.mkOption {
              type = lib.types.str;
              description = "Name of the app.";
            };
            url = lib.mkOption {
              type = lib.types.str;
              description = "URL of the app.";
            };
            icon = lib.mkOption {
              type = lib.types.str;
              default = "cancel";
              description = "Icon name or URL for the app.";
            };
            description = lib.mkOption {
              type = lib.types.str;
              default = "";
              description = "Short description shown for the app.";
            };
            isPinned = lib.mkOption {
              type = lib.types.bool;
              default = false;
              description = "Whether the app is pinned by default.";
            };
          };
        }
      );
      default = [ ];
      description = ''
        Applications shown on the dashboard. When non-empty, this fully
        replaces the contents of Flame's `apps` table on every service
        start — any apps added through the web UI will not persist
        across restarts.
      '';
      example = [
        {
          name = "Router";
          url = "http://192.168.1.1";
        }
      ];
    };

    settings = lib.mkOption {
      type = lib.types.submodule {
        freeformType = settingsFormat.type;

        options = {
          weatherApiKeyFile = lib.mkOption {
            type = lib.types.nullOr lib.types.path;
            default = null;
            description = ''
              Path to a file containing the API key obtained from https://www.weatherapi.com used for
              Flame's weather widget.
              Compatible with sops-nix and agenix.
            '';
            example = "/run/secrets/flame-weather-api-key";
          };
        };
      };
      default = { };
      description = ''
        Flame settings, written to Flame's settings JSON on every service
        start. Accepts any key Flame's settings API supports; see
        [Flame's source](https://github.com/pawelmalak/flame/blob/master/client/src/context/context.js)
        for the current schema, since Flame does not publish separate
        settings documentation.

        `greetingsSchema`, `daySchema`, and `monthSchema` accept either a
        list of strings or a single semicolon-separated string.
      '';
      example = {
        lat = 52.52;
        long = 13.405;
        customTitle = "My Dashboard";
        hideHeader = true;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services = {
      flame-seed = lib.mkIf (cfg.apps != [ ] || cfg.categories != [ ]) {
        description = "Seed Flame apps and bookmarks";
        after = [ "flame.service" ];
        requires = [ "flame.service" ];
        wantedBy = [ "flame.service" ];

        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
          DynamicUser = true;
          StateDirectory = "flame";
        };

        script = ''
          for i in $(seq 1 30); do
            if ${lib.getExe pkgs.sqlite} /var/lib/flame/app/data/db.sqlite \
               "SELECT 1 FROM sqlite_master WHERE type='table' AND name='apps';" | grep -q 1; then
              break
            fi
            sleep 1
          done
          ${lib.getExe pkgs.sqlite} /var/lib/flame/app/data/db.sqlite < ${seedSql}
        '';
      };

      flame = {
        description = "Flame, a self-hosted startpage for your server";
        wantedBy = [ "multi-user.target" ];
        after = [ "network.target" ];

        preStart = ''
          for entry in ${appTree}/*; do
            name=$(basename "$entry")
            if [ "$name" != data ] && [ "$name" != public ]; then
              ln -sfn "$entry" /var/lib/flame/app/"$name"
            fi
          done

          for entry in /var/lib/flame/app/data /var/lib/flame/app/public; do
            if [ -L "$entry" ]; then
              rm -f "$entry"
            fi
          done
          mkdir -p /var/lib/flame/app/data/uploads /var/lib/flame/app/public

          if [ ! -f /var/lib/flame/app/data/.secret ]; then
            ${lib.getExe pkgs.openssl} rand -hex 32 > /var/lib/flame/app/data/.secret
          fi
          chmod 644 /var/lib/flame/app/data/.secret

          cp -r ${cfg.package}/lib/flame/public/. /var/lib/flame/app/public/
          chmod -R u+w /var/lib/flame/app/public

          install -m644 ${cssFile} /var/lib/flame/app/data/flame.css

          ${lib.getExe pkgs.jq} -n --slurpfile base ${cfg.package}/lib/flame/utils/init/initialConfig.json \
            '$base[0]' > /var/lib/flame/app/data/config.json.tmp

          ${lib.optionalString (cfg.settings.weatherApiKeyFile != null) ''
            weatherApiKey=$(cat ${cfg.settings.weatherApiKeyFile})
            ${lib.getExe pkgs.jq} --arg key "$weatherApiKey" '.WEATHER_API_KEY = $key' \
              ${settingsFile} > /var/lib/flame/app/data/settings-with-key.json
          ''}

          ${lib.getExe pkgs.jq} -s '.[0] * .[1]' \
            /var/lib/flame/app/data/config.json.tmp \
            ${
              if cfg.settings.weatherApiKeyFile != null then
                "/var/lib/flame/app/data/settings-with-key.json"
              else
                settingsFile
            } \
            > /var/lib/flame/app/data/config.json
          rm -f /var/lib/flame/app/data/config.json.tmp
          chmod u+w /var/lib/flame/app/data/config.json
        '';

        serviceConfig = {
          DynamicUser = true;
          StateDirectory = [
            "flame"
            "flame/app"
          ];
          WorkingDirectory = "/var/lib/flame/app";
          Environment = [
            "PORT=${toString cfg.port}"
            "NODE_ENV=production"
            "VERSION=${cfg.package.version}"
          ];
          LoadCredential = [ "flame-password:${cfg.passwordFile}" ];
          Restart = "always";
          NoNewPrivileges = true;
          PrivateTmp = true;
          ProtectSystem = "strict";
          ProtectHome = true;
          CapabilityBoundingSet = "";
        };

        script = ''
          export PASSWORD="$(cat "$CREDENTIALS_DIRECTORY/flame-password")"
          exec ${lib.getExe pkgs.nodejs} --preserve-symlinks --preserve-symlinks-main server.js
        '';
      };
    };

    networking.firewall = lib.mkIf cfg.openFirewall {
      allowedTCPPorts = [ cfg.port ];
    };
  };
}

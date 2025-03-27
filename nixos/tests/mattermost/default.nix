import ../make-test-python.nix (
  { pkgs, lib, ... }:
  let
    host = "smoke.test";
    port = 8065;
    url = "http://${host}:${toString port}";
    siteName = "NixOS Smoke Tests, Inc.";

    makeMattermost =
      mattermostConfig: extraConfig:
      lib.mkMerge [
        (
          { config, ... }:
          {
            environment = {
              systemPackages = [
                pkgs.mattermost
                pkgs.curl
                pkgs.jq
              ];
            };
            networking.hosts = {
              "127.0.0.1" = [ host ];
            };

            # Assume that Postgres won't update across stateVersion.
            services.postgresql = {
              package = lib.mkForce pkgs.postgresql;
              initialScript = lib.mkIf (!config.services.mattermost.database.peerAuth) (
                pkgs.writeText "init.sql" ''
                  create role ${config.services.mattermost.database.user} with login nocreatedb nocreaterole encrypted password '${config.services.mattermost.database.password}';
                ''
              );
            };

            system.stateVersion = lib.mkDefault "25.05";

            services.mattermost = lib.recursiveUpdate {
              enable = true;
              inherit siteName;
              host = "0.0.0.0";
              inherit port;
              siteUrl = url;
              socket = {
                enable = true;
                export = true;
              };
              database = {
                peerAuth = lib.mkDefault true;
              };
              telemetry.enableSecurityAlerts = false;
              settings = {
                SupportSettings.AboutLink = "https://nixos.org";
                PluginSettings.AutomaticPrepackagedPlugins = false;
                AnnouncementSettings = {
                  # Disable this since it doesn't work in the sandbox and causes a timeout.
                  AdminNoticesEnabled = false;
                  UserNoticesEnabled = false;
                };
              };
            } mattermostConfig;

            # Upgrade to the latest Mattermost.
            specialisation.latest.configuration = {
              services.mattermost.package = lib.mkForce pkgs.mattermostLatest;
              system.stateVersion = lib.mkVMOverride "25.05";
            };
          }
        )
        extraConfig
      ];

    makeMysql =
      mattermostConfig: extraConfig:
      lib.mkMerge [
        mattermostConfig
        (
          { pkgs, config, ... }:
          {
            services.mattermost.database = {
              driver = lib.mkForce "mysql";
              peerAuth = lib.mkForce true;
            };
          }
        )
        extraConfig
      ];
  in
  {
    name = "mattermost";

    nodes = rec {
      postgresMutable =
        makeMattermost
          {
            mutableConfig = true;
            preferNixConfig = false;
            settings.SupportSettings.HelpLink = "https://search.nixos.org";
          }
          {
            # Last version to support the "old" config layout.
            system.stateVersion = lib.mkForce "24.11";

            # First version to support the "new" config layout.
            specialisation.upgrade.configuration.system.stateVersion = lib.mkVMOverride "25.05";
          };
      postgresMostlyMutable = makeMattermost {
        mutableConfig = true;
        plugins = with pkgs; [
          # Build the demo plugin.
          (mattermost.buildPlugin {
            pname = "mattermost-plugin-starter-template";
            version = "0.1.0";
            src = fetchFromGitHub {
              owner = "mattermost";
              repo = "mattermost-plugin-starter-template";
              # Newer versions have issues with their dependency lockfile.
              rev = "7c98e89ac1a268ce8614bc665571b7bbc9a70df2";
              hash = "sha256-uyfxB0GZ45qL9ssWUord0eKQC6S0TlCTtjTOXWtK4H0=";
            };
            vendorHash = "sha256-Jl4F9YkHNqiFP9/yeyi4vTntqxMk/J1zhEP6QLSvJQA=";
            npmDepsHash = "sha256-z08nc4XwT+uQjQlZiUydJyh8mqeJoYdPFWuZpw9k99s=";
          })

          # Build the todos plugin.
          (mattermost.buildPlugin {
            pname = "mattermost-plugin-todo";
            version = "0.8-pre";
            src = fetchFromGitHub {
              owner = "mattermost-community";
              repo = "mattermost-plugin-todo";
              # 0.7.1 didn't work, seems to use an older set of node dependencies.
              rev = "f25dc91ea401c9f0dcd4abcebaff10eb8b9836e5";
              hash = "sha256-OM+m4rTqVtolvL5tUE8RKfclqzoe0Y38jLU60Pz7+HI=";
            };
            vendorHash = "sha256-5KpechSp3z/Nq713PXYruyNxveo6CwrCSKf2JaErbgg=";
            npmDepsHash = "sha256-o2UOEkwb8Vx2lDWayNYgng0GXvmS6lp/ExfOq3peyMY=";
            extraGoModuleAttrs = {
              npmFlags = [ "--legacy-peer-deps" ];
            };
          })
        ];
      } { };
      postgresImmutable = makeMattermost {
        package = pkgs.mattermost.overrideAttrs (prev: {
          webapp = prev.webapp.overrideAttrs (prevWebapp: {
            # Ensure that users can add patches.
            postPatch =
              prevWebapp.postPatch or ""
              + ''
                substituteInPlace channels/src/root.html --replace-fail "Mattermost" "Patched Mattermost"
              '';
          });
        });
        mutableConfig = false;

        # Make sure something other than the default works.
        user = "mmuser";
        group = "mmgroup";

        database = {
          # Ensure that this gets tested on Postgres.
          peerAuth = false;
        };
        settings.SupportSettings.HelpLink = "https://search.nixos.org";
      } { };
      postgresEnvironmentFile = makeMattermost {
        mutableConfig = false;
        database.fromEnvironment = true;
        settings.SupportSettings.AboutLink = "https://example.org";
        environmentFile = pkgs.writeText "mattermost-env" ''
          MM_SQLSETTINGS_DATASOURCE=postgres:///mattermost?host=/run/postgresql
          MM_SUPPORTSETTINGS_ABOUTLINK=https://nixos.org
        '';
      } { };

      mysqlMutable = makeMysql postgresMutable { };
      mysqlMostlyMutable = makeMysql postgresMostlyMutable { };
      mysqlImmutable = makeMysql postgresImmutable {
        # Let's try to use this on MySQL.
        services.mattermost.database = {
          peerAuth = lib.mkForce true;
          user = lib.mkForce "mmuser";
          name = lib.mkForce "mmuser";
        };
      };
      mysqlEnvironmentFile = makeMysql postgresEnvironmentFile {
        services.mattermost.environmentFile = lib.mkForce (
          pkgs.writeText "mattermost-env" ''
            MM_SQLSETTINGS_DATASOURCE=mattermost@unix(/run/mysqld/mysqld.sock)/mattermost?charset=utf8mb4,utf8&writeTimeout=30s
            MM_SUPPORTSETTINGS_ABOUTLINK=https://nixos.org
          ''
        );
      };
    };

    testScript =
      { nodes, ... }:
      let
        expectConfig = pkgs.writeShellScript "expect-config" ''
          set -euo pipefail
          config="$(curl ${lib.escapeShellArg "${url}/api/v4/config/client?format=old"})"
          echo "Config: $(echo "$config" | ${pkgs.jq}/bin/jq)" >&2
          [[ "$(echo "$config" | ${pkgs.jq}/bin/jq -r ${lib.escapeShellArg ".SiteName == $siteName and .Version == $mattermostVersion and "}"($1)" --arg siteName ${lib.escapeShellArg siteName} --arg mattermostVersion "$2" --arg sep '-')" = "true" ]]
        '';

        setConfig = pkgs.writeShellScript "set-config" ''
          set -eo pipefail
          mattermostConfig=/etc/mattermost/config.json
          nixosVersion="$2"
          if [ -z "$nixosVersion" ]; then
            nixosVersion="$(nixos-version)"
          fi
          nixosVersion="$(echo "$nixosVersion" | sed -nr 's/^([0-9]{2})\.([0-9]{2}).*/\1\2/p')"
          echo "NixOS version: $nixosVersion" >&2
          if [ "$nixosVersion" -lt 2505 ]; then
            mattermostConfig=/var/lib/mattermost/config/config.json
          fi
          newConfig="$(${pkgs.jq}/bin/jq -r "$1" "$mattermostConfig")"
          echo "New config @ $mattermostConfig: $(echo "$newConfig" | ${pkgs.jq}/bin/jq)" >&2
          truncate -s 0 "$mattermostConfig"
          echo "$newConfig" >> "$mattermostConfig"
        '';

        expectPlugins = pkgs.writeShellScript "expect-plugins" ''
          set -euo pipefail
          case "$1" in
            ""|*[!0-9]*)
              plugins="$(curl ${lib.escapeShellArg "${url}/api/v4/plugins/webapp"})"
              echo "Plugins: $(echo "$plugins" | ${pkgs.jq}/bin/jq)" >&2
              [[ "$(echo "$plugins" | ${pkgs.jq}/bin/jq -r "$1")" == "true" ]]
              ;;
            *)
              code="$(curl -s -o /dev/null -w "%{http_code}" ${lib.escapeShellArg "${url}/api/v4/plugins/webapp"})"
              [[ "$code" == "$1" ]]
              ;;
          esac
        '';

        ensurePost = pkgs.writeShellScript "ensure-post" ''
          set -euo pipefail

          url="$1"
          failIfNotFound="$2"

          # Make sure the user exists
          thingExists='(type == "array" and length > 0)'
          userExists="($thingExists and ("'.[0].username == "nixos"))'
          if mmctl user list --json | jq | tee /dev/stderr | jq -e "$userExists | not"; then
            if [ "$failIfNotFound" -ne 0 ]; then
              echo "User didn't exist!" >&2
              exit 1
            else
              mmctl user create \
                --email tests@nixos.org \
                --username nixos --password nixosrules --system-admin --email-verified >&2

              # Make sure the user exists.
              while mmctl user list --json | jq | tee /dev/stderr | jq -e "$userExists | not"; do
                sleep 1
              done
            fi
          fi

          # Auth.
          mmctl auth login "$url" --name nixos --username nixos --password nixosrules

          # Make sure the team exists
          teamExists="($thingExists and ("'.[0].display_name == "NixOS Smoke Tests, Inc."))'
          if mmctl team list --json | jq | tee /dev/stderr | jq -e "$teamExists | not"; then
            if [ "$failIfNotFound" -ne 0 ]; then
              echo "Team didn't exist!" >&2
              exit 1
            else
              mmctl team create \
                --name nixos \
                --display-name "NixOS Smoke Tests, Inc."

              # Teams take a second to create.
              while mmctl team list --json | jq | tee /dev/stderr | jq -e "$teamExists | not"; do
                sleep 1
              done

              # Add the user.
              mmctl team users add nixos tests@nixos.org
            fi
          fi

          authToken="$(cat ~/.config/mmctl/config | jq -r '.nixos.authToken')"
          authHeader="Authorization: Bearer $authToken"
          acceptHeader="Accept: application/json; charset=UTF-8"

          # Make sure the test post exists.
          postContents="pls enjoy this NixOS meme I made"
          postAttachment=${./test.jpg}
          postAttachmentSize="$(stat -c%s $postAttachment)"
          postAttachmentHash="$(sha256sum $postAttachment | awk '{print $1}')"
          postAttachmentId=""
          postPredicate='select(.message == $message and (.file_ids | length) > 0 and (.metadata.files[0].size | tonumber) == ($size | tonumber))'
          postExists="($thingExists and ("'(.[] | '"$postPredicate"' | length) > 0))'
          if mmctl post list nixos:off-topic --json | jq | tee /dev/stderr | jq --arg message "$postContents" --arg size "$postAttachmentSize" -e "$postExists | not"; then
            if [ "$failIfNotFound" -ne 0 ]; then
              echo "Post didn't exist!" >&2
              exit 1
            else
              # Can't use mmcli for this seemingly.
              channelId="$(mmctl channel list nixos --json | jq | tee /dev/stderr | jq -r '.[] | select(.name == "off-topic") | .id')"
              echo "Channel ID: $channelId" >&2

              # Upload the file.
              echo "Uploading file at $postAttachment (size: $postAttachmentSize)..." >&2
              postAttachmentId="$(curl "$url/api/v4/files" -X POST -H "$acceptHeader" -H "$authHeader" \
                -F "files=@$postAttachment" -F "channel_id=$channelId" -F "client_ids=test" | jq | tee /dev/stderr | jq -r '.file_infos[0].id')"

              # Create the post with it attached.
              postJson="$(echo '{}' | jq -c --arg channelId "$channelId" --arg message "$postContents" --arg fileId "$postAttachmentId" \
                '{channel_id: $channelId, message: $message, file_ids: [$fileId]}')"
              echo "Creating post with contents $postJson..." >&2
              curl "$url/api/v4/posts" -X POST -H "$acceptHeader" -H "$authHeader" --json "$postJson" | jq >&2
            fi
          fi

          if mmctl post list nixos:off-topic --json | jq | tee /dev/stderr | jq --arg message "$postContents" --arg size "$postAttachmentSize" -e "$postExists"; then
            # Get the attachment ID.
            getPostAttachmentId=".[] | $postPredicate | .file_ids[0]"
            postAttachmentId="$(mmctl post list nixos:off-topic --json | jq | tee /dev/stderr | \
              jq --arg message "$postContents" --arg size "$postAttachmentSize" -r "$getPostAttachmentId")"

            echo "Expected post attachment hash: $postAttachmentHash" >&2
            actualPostAttachmentHash="$(curl "$url/api/v4/files/$postAttachmentId?download=1" -H "$authHeader" | sha256sum | awk '{print $1}')"
            echo "Actual post attachment hash: $postAttachmentHash" >&2
            if [ "$actualPostAttachmentHash" != "$postAttachmentHash" ]; then
              echo "Post attachment hash mismatched!" >&2
              exit 1
            else
              echo "Post attachment hash was OK!" >&2
              exit 0
            fi
          else
            echo "Post didn't exist when it should have!" >&2
            exit 1
          fi
        '';
      in
      ''
        import shlex

        def wait_mattermost_up(node, site_name="${siteName}"):
          node.systemctl("start mattermost.service")
          node.wait_for_unit("mattermost.service")
          node.wait_for_open_port(8065)
          node.succeed(f"curl {shlex.quote('${url}')} >/dev/null")
          node.succeed(f"curl {shlex.quote('${url}')}/index.html | grep {shlex.quote(site_name)}")

        def restart_mattermost(node, site_name="${siteName}"):
          node.systemctl("restart mattermost.service")
          wait_mattermost_up(node, site_name)

        def expect_config(node, mattermost_version, *configs):
          for config in configs:
            node.succeed(f"${expectConfig} {shlex.quote(config)} {shlex.quote(mattermost_version)}")

        def expect_plugins(node, jq_or_code):
          node.succeed(f"${expectPlugins} {shlex.quote(str(jq_or_code))}")

        def ensure_post(node, fail_if_not_found=False):
          node.succeed(f"${ensurePost} {shlex.quote('${url}')} {1 if fail_if_not_found else 0}")

        def set_config(node, *configs, nixos_version='25.05'):
          for config in configs:
            args = [shlex.quote("${setConfig}")]
            args.append(shlex.quote(config))
            if nixos_version:
              args.append(shlex.quote(str(nixos_version)))
            node.succeed(' '.join(args))

        def run_mattermost_tests(mutableToplevel: str, mutable,
                                 mostlyMutableToplevel: str, mostlyMutable,
                                 immutableToplevel: str, immutable,
                                 environmentFileToplevel: str, environmentFile):
          esr, latest = '${pkgs.mattermost.version}', '${pkgs.mattermostLatest.version}'

          ## Mutable node tests ##
          mutable.start()
          wait_mattermost_up(mutable)

          # Get the initial config
          expect_config(mutable, esr, '.AboutLink == "https://nixos.org" and .HelpLink == "https://search.nixos.org"')

          # Edit the config and make a post
          set_config(
            mutable,
            '.SupportSettings.AboutLink = "https://mattermost.com"',
            '.SupportSettings.HelpLink = "https://nixos.org/nixos/manual"',
            nixos_version='24.11' # Default 'mutable' config is an old version
          )
          ensure_post(mutable)
          restart_mattermost(mutable)

          # AboutLink and HelpLink should be changed, and the post should exist
          expect_config(mutable, esr, '.AboutLink == "https://mattermost.com" and .HelpLink == "https://nixos.org/nixos/manual"')
          ensure_post(mutable, fail_if_not_found=True)

          # Switch to the newer config
          mutable.succeed(f"{mutableToplevel}/specialisation/upgrade/bin/switch-to-configuration switch")
          wait_mattermost_up(mutable)

          # AboutLink and HelpLink should be changed, still, and the post should still exist
          expect_config(mutable, esr, '.AboutLink == "https://mattermost.com" and .HelpLink == "https://nixos.org/nixos/manual"')
          ensure_post(mutable, fail_if_not_found=True)

          # Switch to the latest Mattermost version
          mutable.succeed(f"{mutableToplevel}/specialisation/latest/bin/switch-to-configuration switch")
          wait_mattermost_up(mutable)

          # AboutLink and HelpLink should be changed, still, and the post should still exist
          expect_config(mutable, latest, '.AboutLink == "https://mattermost.com" and .HelpLink == "https://nixos.org/nixos/manual"')
          ensure_post(mutable, fail_if_not_found=True)

          mutable.shutdown()

          ## Mostly mutable node tests ##
          mostlyMutable.start()
          wait_mattermost_up(mostlyMutable)

          # Get the initial config
          expect_config(mostlyMutable, esr, '.AboutLink == "https://nixos.org"')

          # No plugins.
          expect_plugins(mostlyMutable, 'length == 0')

          # Edit the config and make a post
          set_config(
            mostlyMutable,
            '.SupportSettings.AboutLink = "https://mattermost.com"',
            '.SupportSettings.HelpLink = "https://nixos.org/nixos/manual"',
            '.PluginSettings.PluginStates."com.mattermost.plugin-todo".Enable = true'
          )
          ensure_post(mostlyMutable)
          restart_mattermost(mostlyMutable)

          # AboutLink should be overridden by NixOS configuration; HelpLink should be what we set above
          expect_config(mostlyMutable, esr, '.AboutLink == "https://nixos.org" and .HelpLink == "https://nixos.org/nixos/manual"')

          # Single plugin that's now enabled.
          expect_plugins(mostlyMutable, 'length == 1')

          # Post should exist.
          ensure_post(mostlyMutable, fail_if_not_found=True)

          # Switch to the latest Mattermost version
          mostlyMutable.succeed(f"{mostlyMutableToplevel}/specialisation/latest/bin/switch-to-configuration switch")
          wait_mattermost_up(mostlyMutable)

          # AboutLink should be overridden and the post should still exist
          expect_config(mostlyMutable, latest, '.AboutLink == "https://nixos.org" and .HelpLink == "https://nixos.org/nixos/manual"')
          ensure_post(mostlyMutable, fail_if_not_found=True)

          mostlyMutable.shutdown()

          ## Immutable node tests ##
          immutable.start()
          wait_mattermost_up(immutable, "Patched Mattermost")

          # Get the initial config
          expect_config(immutable, esr, '.AboutLink == "https://nixos.org" and .HelpLink == "https://search.nixos.org"')

          # Edit the config and make a post
          set_config(
            immutable,
            '.SupportSettings.AboutLink = "https://mattermost.com"',
            '.SupportSettings.HelpLink = "https://nixos.org/nixos/manual"'
          )
          ensure_post(immutable)
          restart_mattermost(immutable, "Patched Mattermost")

          # Our edits should be ignored on restart
          expect_config(immutable, esr, '.AboutLink == "https://nixos.org" and .HelpLink == "https://search.nixos.org"')

          # No plugins.
          expect_plugins(immutable, 'length == 0')

          # Post should exist.
          ensure_post(immutable, fail_if_not_found=True)

          # Switch to the latest Mattermost version
          immutable.succeed(f"{immutableToplevel}/specialisation/latest/bin/switch-to-configuration switch")
          wait_mattermost_up(immutable)

          # AboutLink and HelpLink should be changed, still, and the post should still exist
          expect_config(immutable, latest, '.AboutLink == "https://nixos.org" and .HelpLink == "https://search.nixos.org"')
          ensure_post(immutable, fail_if_not_found=True)

          immutable.shutdown()

          ## Environment File node tests ##
          environmentFile.start()
          wait_mattermost_up(environmentFile)
          ensure_post(environmentFile)

          # Settings in the environment file should override settings set otherwise, and the post should exist
          expect_config(environmentFile, esr, '.AboutLink == "https://nixos.org"')
          ensure_post(environmentFile, fail_if_not_found=True)

          # Switch to the latest Mattermost version
          environmentFile.succeed(f"{environmentFileToplevel}/specialisation/latest/bin/switch-to-configuration switch")
          wait_mattermost_up(environmentFile)

          # AboutLink should be changed still, and the post should still exist
          expect_config(environmentFile, latest, '.AboutLink == "https://nixos.org"')
          ensure_post(environmentFile, fail_if_not_found=True)

          environmentFile.shutdown()

        run_mattermost_tests(
          "${nodes.mysqlMutable.system.build.toplevel}",
          mysqlMutable,
          "${nodes.mysqlMostlyMutable.system.build.toplevel}",
          mysqlMostlyMutable,
          "${nodes.mysqlImmutable.system.build.toplevel}",
          mysqlImmutable,
          "${nodes.mysqlEnvironmentFile.system.build.toplevel}",
          mysqlEnvironmentFile
        )

        run_mattermost_tests(
          "${nodes.postgresMutable.system.build.toplevel}",
          postgresMutable,
          "${nodes.postgresMostlyMutable.system.build.toplevel}",
          postgresMostlyMutable,
          "${nodes.postgresImmutable.system.build.toplevel}",
          postgresImmutable,
          "${nodes.postgresEnvironmentFile.system.build.toplevel}",
          postgresEnvironmentFile
        )
      '';
  }
)

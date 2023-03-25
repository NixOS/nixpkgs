import ./make-test-python.nix ({ pkgs, lib, ... }:
  let
    host = "smoke.test";
    port = 8065;
    url = "http://${host}:${toString port}";
    siteName = "NixOS Smoke Tests, Inc.";

    makeMattermost = mattermostConfig:
      { config, ... }: {
        environment.systemPackages = [
          pkgs.mattermost
          pkgs.curl
          pkgs.jq
        ];
        networking.hosts = {
          "127.0.0.1" = [ host ];
        };
        services.mattermost = lib.recursiveUpdate
          {
            enable = true;
            inherit siteName;
            listenAddress = "0.0.0.0";
            inherit port;
            siteUrl = url;
            settings.SupportSettings.AboutLink = "https://nixos.org";
          }
          mattermostConfig;
      };
  in
  {
    name = "mattermost";

    nodes = {
      mutable = makeMattermost {
        mutableConfig = true;
        settings.SupportSettings.HelpLink = "https://search.nixos.org";
      };
      mostlyMutable = makeMattermost {
        mutableConfig = true;
        preferNixConfig = true;
        settings.PluginSettings.AutomaticPrepackagedPlugins = false;
        plugins = [
          (pkgs.fetchurl {
            url = "https://github.com/matterpoll/matterpoll/releases/download/v1.5.0/com.github.matterpoll.matterpoll-1.5.0.tar.gz";
            sha256 = "1nvgxfza2pfc9ggrr6l3m3hadfy93iid05h3spbhvfh9s1vnmx00";
          })
        ];
      };
      immutable = makeMattermost {
        mutableConfig = false;
        settings.SupportSettings.HelpLink = "https://search.nixos.org";
      };
    };

    testScript =
      let
        expectMattermostUp = pkgs.writeShellScript "expect-mattermost-up" ''
          set -euo pipefail
          curl ${lib.escapeShellArg url} >/dev/null
        '';

        expectConfig = jqExpression: pkgs.writeShellScript "expect-config" ''
          set -euo pipefail
          config="$(curl ${lib.escapeShellArg "${url}/api/v4/config/client?format=old"})"
          [[ "$(echo "$config" | ${pkgs.jq}/bin/jq -r ${lib.escapeShellArg ".SiteName == $siteName and .Version == ($mattermostName / $sep)[-1] and (${jqExpression})"} --arg siteName ${lib.escapeShellArg siteName} --arg mattermostName ${lib.escapeShellArg pkgs.mattermost.name} --arg sep '-')" == "true" ]]
        '';

        setConfig = jqExpression: pkgs.writeShellScript "set-config" ''
          set -euo pipefail
          mattermostConfig=/etc/mattermost/config.json
          newConfig="$(${pkgs.jq}/bin/jq -r ${lib.escapeShellArg jqExpression} $mattermostConfig)"
          truncate -s 0 "$mattermostConfig"
          echo "$newConfig" >> "$mattermostConfig"
        '';

        expectPlugins = jqExpressionOrStatusCode: pkgs.writeShellScript "expect-plugins" ''
          set -euo pipefail
          ${if builtins.isInt jqExpressionOrStatusCode then ''
            code="$(curl -s -o /dev/null -w "%{http_code}" ${lib.escapeShellArg "${url}/api/v4/plugins/webapp"})"
            [[ "$code" == ${lib.escapeShellArg (toString jqExpressionOrStatusCode)} ]]
          '' else ''
            plugins="$(curl ${lib.escapeShellArg "${url}/api/v4/plugins/webapp"})"
            [[ "$(echo "$plugins" | ${pkgs.jq}/bin/jq -r ${lib.escapeShellArg "(${jqExpressionOrStatusCode})"})" == "true" ]]
          ''}
        '';
      in
      ''
        ## Mutable node tests ##
        mutable.start()
        mutable.wait_for_unit("mattermost.service")
        mutable.wait_for_open_port(8065)

        # Get the initial config
        mutable.succeed("${expectMattermostUp}")
        mutable.succeed("${expectConfig ''.AboutLink == "https://nixos.org" and .HelpLink == "https://search.nixos.org"''}")

        # Edit the config
        mutable.succeed("${setConfig ''.SupportSettings.AboutLink = "https://mattermost.com"''}")
        mutable.succeed("${setConfig ''.SupportSettings.HelpLink = "https://nixos.org/nixos/manual"''}")
        mutable.systemctl("restart mattermost.service")
        mutable.wait_for_open_port(8065)

        # AboutLink and HelpLink should be changed
        mutable.succeed("${expectConfig ''.AboutLink == "https://mattermost.com" and .HelpLink == "https://nixos.org/nixos/manual"''}")

        # No plugins.
        mutable.succeed("${expectPlugins ''length == 0''}")
        mutable.shutdown()

        ## Mostly mutable node tests ##
        mostlyMutable.start()
        mostlyMutable.wait_for_unit("mattermost.service")
        mostlyMutable.wait_for_open_port(8065)

        # Get the initial config
        mostlyMutable.succeed("${expectMattermostUp}")
        mostlyMutable.succeed("${expectConfig ''.AboutLink == "https://nixos.org"''}")

        # No plugins.
        mostlyMutable.succeed("${expectPlugins ''length == 0''}")

        # Edit the config
        mostlyMutable.succeed("${setConfig ''.SupportSettings.AboutLink = "https://mattermost.com"''}")
        mostlyMutable.succeed("${setConfig ''.SupportSettings.HelpLink = "https://nixos.org/nixos/manual"''}")
        mostlyMutable.succeed("${setConfig ''.PluginSettings.PluginStates."com.github.matterpoll.matterpoll".Enable = true''}")
        mostlyMutable.systemctl("restart mattermost.service")
        mostlyMutable.wait_for_open_port(8065)

        # AboutLink should be overridden by NixOS configuration; HelpLink should be what we set above
        mostlyMutable.succeed("${expectConfig ''.AboutLink == "https://nixos.org" and .HelpLink == "https://nixos.org/nixos/manual"''}")

        # Single plugin that's now enabled.
        mostlyMutable.succeed("${expectPlugins ''length == 1''}")
        mostlyMutable.shutdown()

        ## Immutable node tests ##
        immutable.start()
        immutable.wait_for_unit("mattermost.service")
        immutable.wait_for_open_port(8065)

        # Get the initial config
        immutable.succeed("${expectMattermostUp}")
        immutable.succeed("${expectConfig ''.AboutLink == "https://nixos.org" and .HelpLink == "https://search.nixos.org"''}")

        # Edit the config
        immutable.succeed("${setConfig ''.SupportSettings.AboutLink = "https://mattermost.com"''}")
        immutable.succeed("${setConfig ''.SupportSettings.HelpLink = "https://nixos.org/nixos/manual"''}")
        immutable.systemctl("restart mattermost.service")
        immutable.wait_for_open_port(8065)

        # Our edits should be ignored on restart
        immutable.succeed("${expectConfig ''.AboutLink == "https://nixos.org" and .HelpLink == "https://search.nixos.org"''}")

        # No plugins.
        immutable.succeed("${expectPlugins ''length == 0''}")
        immutable.shutdown()
      '';
  })

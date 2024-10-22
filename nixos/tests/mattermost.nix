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
      services.postgresql.initialScript = lib.mkIf (!config.services.mattermost.database.peerAuth) (pkgs.writeText "init.sql" ''
        create role ${config.services.mattermost.database.user} with login nocreatedb nocreaterole encrypted password '${config.services.mattermost.database.password}'
      '');
      services.mattermost = lib.recursiveUpdate {
        enable = true;
        inherit siteName;
        host = "0.0.0.0";
        inherit port;
        siteUrl = url;
        database = {
          peerAuth = true;
        };
        settings = {
          SupportSettings.AboutLink = "https://nixos.org";
          PluginSettings.AutomaticPrepackagedPlugins = false;
        };
      } mattermostConfig;
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
      plugins = [
        (pkgs.fetchurl {
          url = "https://github.com/mattermost-community/mattermost-plugin-todo/releases/download/v0.7.1/com.mattermost.plugin-todo-0.7.1.tar.gz";
          sha256 = "1ki7vsvhjl2xgw4mfmnvn9s5hkn98l7nf4v9fdk59v44zbm7mriz";
        })
      ];
    };
    immutable = makeMattermost {
      mutableConfig = false;

      # Make sure something other than the default works.
      user = "mmuser";
      group = "mmgroup";

      database = {
        peerAuth = false;
      };
      settings.SupportSettings.HelpLink = "https://search.nixos.org";
    };
    environmentFile = makeMattermost {
      mutableConfig = false;
      database.fromEnvironment = true;
      settings.SupportSettings.AboutLink = "https://example.org";
      environmentFile = pkgs.writeText "mattermost-env" ''
        MM_SQLSETTINGS_DATASOURCE=postgres:///mattermost?host=/run/postgresql
        MM_SUPPORTSETTINGS_ABOUTLINK=https://nixos.org
      '';
    };
  };

  testScript = let
    expectMattermostUp = pkgs.writeShellScript "expect-mattermost-up" ''
      set -euo pipefail
      curl ${lib.escapeShellArg url} >/dev/null
    '';

    expectConfig = pkgs.writeShellScript "expect-config" ''
      set -euo pipefail
      config="$(curl ${lib.escapeShellArg "${url}/api/v4/config/client?format=old"})"
      echo "Config: $(echo "$config" | ${pkgs.jq}/bin/jq)" >&2
      [[ "$(echo "$config" | ${pkgs.jq}/bin/jq -r ${lib.escapeShellArg ".SiteName == $siteName and .Version == ($mattermostName / $sep)[-1] and "}"($1)" --arg siteName ${lib.escapeShellArg siteName} --arg mattermostName ${lib.escapeShellArg pkgs.mattermost.name} --arg sep '-')" = "true" ]]
    '';

    setConfig = pkgs.writeShellScript "set-config" ''
      set -euo pipefail
      mattermostConfig=/etc/mattermost/config.json
      echo "Old config: $(echo "$config" | ${pkgs.jq}/bin/jq)" >&2
      newConfig="$(${pkgs.jq}/bin/jq -r "$1" $mattermostConfig)"
      echo "New config: $(echo "$newConfig" | ${pkgs.jq}/bin/jq)" >&2
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
  in
  ''
    import shlex

    def wait_mattermost_up(node):
      node.wait_for_unit("mattermost.service")
      node.wait_for_open_port(8065)
      node.succeed(f"curl {shlex.quote('${url}')} >/dev/null")

    def restart_mattermost(node):
      node.systemctl("restart mattermost.service")
      wait_mattermost_up(node)

    def expect_config(node, *configs):
      for config in configs:
        node.succeed(f"${expectConfig} {shlex.quote(config)}")

    def expect_plugins(node, jq_or_code):
      node.succeed(f"${expectPlugins} {shlex.quote(str(jq_or_code))}")

    def set_config(node, *configs):
      for config in configs:
        node.succeed(f"${setConfig} {shlex.quote(config)}")

    ## Mutable node tests ##
    mutable.start()
    wait_mattermost_up(mutable)

    # Get the initial config
    expect_config(mutable, '.AboutLink == "https://nixos.org" and .HelpLink == "https://search.nixos.org"')

    # Edit the config
    set_config(
      mutable,
      '.SupportSettings.AboutLink = "https://mattermost.com"',
      '.SupportSettings.HelpLink = "https://nixos.org/nixos/manual"'
    )
    restart_mattermost(mutable)

    # AboutLink and HelpLink should be changed
    expect_config(mutable, '.AboutLink == "https://mattermost.com" and .HelpLink == "https://nixos.org/nixos/manual"')
    mutable.shutdown()

    ## Mostly mutable node tests ##
    mostlyMutable.start()
    wait_mattermost_up(mostlyMutable)

    # Get the initial config
    expect_config(mostlyMutable, '.AboutLink == "https://nixos.org"')

    # No plugins.
    expect_plugins(mostlyMutable, 'length == 0')

    # Edit the config
    set_config(
      mostlyMutable,
      '.SupportSettings.AboutLink = "https://mattermost.com"',
      '.SupportSettings.HelpLink = "https://nixos.org/nixos/manual"',
      '.PluginSettings.PluginStates."com.mattermost.plugin-todo".Enable = true'
    )
    restart_mattermost(mostlyMutable)

    # AboutLink should be overridden by NixOS configuration; HelpLink should be what we set above
    expect_config(mostlyMutable, '.AboutLink == "https://nixos.org" and .HelpLink == "https://nixos.org/nixos/manual"')

    # Single plugin that's now enabled.
    expect_plugins(mostlyMutable, 'length == 1')
    mostlyMutable.shutdown()

    ## Immutable node tests ##
    immutable.start()
    wait_mattermost_up(immutable)

    # Get the initial config
    expect_config(immutable, '.AboutLink == "https://nixos.org" and .HelpLink == "https://search.nixos.org"')

    # Edit the config
    set_config(
      immutable,
      '.SupportSettings.AboutLink = "https://mattermost.com"',
      '.SupportSettings.HelpLink = "https://nixos.org/nixos/manual"'
    )
    restart_mattermost(immutable)

    # Our edits should be ignored on restart
    expect_config(immutable, '.AboutLink == "https://nixos.org" and .HelpLink == "https://search.nixos.org"')

    # No plugins.
    expect_plugins(immutable, 'length == 0')
    immutable.shutdown()

    ## Environment File node tests ##
    environmentFile.start()
    wait_mattermost_up(environmentFile)

    # Settings in the environment file should override settings set otherwise
    expect_config(environmentFile, '.AboutLink == "https://nixos.org"')
    environmentFile.shutdown()
  '';
})

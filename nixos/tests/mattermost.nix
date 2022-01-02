import ./make-test-python.nix ({ pkgs, lib, ... }:
let
  host = "smoke.test";
  port = "8065";
  url = "http://${host}:${port}";
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
      services.mattermost = lib.recursiveUpdate {
        enable = true;
        inherit siteName;
        listenAddress = "0.0.0.0:${port}";
        siteUrl = url;
        extraConfig = {
          SupportSettings.AboutLink = "https://nixos.org";
        };
      } mattermostConfig;
    };
in
{
  name = "mattermost";

  nodes = {
    mutable = makeMattermost {
      mutableConfig = true;
      extraConfig.SupportSettings.HelpLink = "https://search.nixos.org";
    };
    mostlyMutable = makeMattermost {
      mutableConfig = true;
      preferNixConfig = true;
      plugins = let
        mattermostDemoPlugin = pkgs.fetchurl {
          url = "https://github.com/mattermost/mattermost-plugin-demo/releases/download/v0.9.0/com.mattermost.demo-plugin-0.9.0.tar.gz";
          sha256 = "1h4qi34gcxcx63z8wiqcf2aaywmvv8lys5g8gvsk13kkqhlmag25";
        };
      in [
        mattermostDemoPlugin
      ];
    };
    immutable = makeMattermost {
      mutableConfig = false;
      extraConfig.SupportSettings.HelpLink = "https://search.nixos.org";
    };
    immutable_6 = makeMattermost {
      package = pkgs.mattermost_6;
      mutableConfig = false;
      plugins = let
        mattermostDemoPlugin = pkgs.fetchurl {
          url = "https://github.com/mattermost/mattermost-plugin-demo/releases/download/v0.9.0/com.mattermost.demo-plugin-0.9.0.tar.gz";
          sha256 = "1h4qi34gcxcx63z8wiqcf2aaywmvv8lys5g8gvsk13kkqhlmag25";
        };
      in [
        mattermostDemoPlugin
      ];
      extraConfig.SupportSettings.HelpLink = "https://search.nixos.org";
    };
  };

  testScript = let
    expectConfig = pkg: jqExpression: pkgs.writeShellScript "expect-config" ''
      set -euo pipefail
      echo "Expecting config to match: "${lib.escapeShellArg jqExpression} >&2
      curl ${lib.escapeShellArg url} >/dev/null
      config="$(curl ${lib.escapeShellArg "${url}/api/v4/config/client?format=old"})"
      echo "Config: $(echo "$config" | ${pkgs.jq}/bin/jq)" >&2
      [[ "$(echo "$config" | ${pkgs.jq}/bin/jq -r ${lib.escapeShellArg ".SiteName == $siteName and .Version == ($mattermostName / $sep)[-1] and (${jqExpression})"} --arg siteName ${lib.escapeShellArg siteName} --arg mattermostName ${lib.escapeShellArg pkg.name} --arg sep '-')" = "true" ]]
    '';

    setConfig = jqExpression: pkgs.writeShellScript "set-config" ''
      set -euo pipefail
      mattermostConfig=/var/lib/mattermost/config/config.json
      newConfig="$(${pkgs.jq}/bin/jq -r ${lib.escapeShellArg jqExpression} $mattermostConfig)"
      rm -f $mattermostConfig
      echo "$newConfig" > "$mattermostConfig"
    '';
  in
  ''
    start_all()

    ## Mutable node tests ##
    mutable.wait_for_unit("mattermost.service")
    mutable.wait_for_open_port(8065)

    # Get the initial config
    mutable.succeed("${expectConfig pkgs.mattermost ''.AboutLink == "https://nixos.org" and .HelpLink == "https://search.nixos.org"''}")

    # Edit the config
    mutable.succeed("${setConfig ''.SupportSettings.AboutLink = "https://mattermost.com"''}")
    mutable.succeed("${setConfig ''.SupportSettings.HelpLink = "https://nixos.org/nixos/manual"''}")
    mutable.systemctl("restart mattermost.service")
    mutable.wait_for_open_port(8065)

    # AboutLink and HelpLink should be changed
    mutable.succeed("${expectConfig pkgs.mattermost ''.AboutLink == "https://mattermost.com" and .HelpLink == "https://nixos.org/nixos/manual"''}")

    ## Mostly mutable node tests ##
    mostlyMutable.wait_for_unit("mattermost.service")
    mostlyMutable.wait_for_open_port(8065)

    # Get the initial config
    mostlyMutable.succeed("${expectConfig pkgs.mattermost ''.AboutLink == "https://nixos.org"''}")

    # Edit the config
    mostlyMutable.succeed("${setConfig ''.SupportSettings.AboutLink = "https://mattermost.com"''}")
    mostlyMutable.succeed("${setConfig ''.SupportSettings.HelpLink = "https://nixos.org/nixos/manual"''}")
    mostlyMutable.systemctl("restart mattermost.service")
    mostlyMutable.wait_for_open_port(8065)

    # AboutLink should be overridden by NixOS configuration; HelpLink should be what we set above
    mostlyMutable.succeed("${expectConfig pkgs.mattermost ''.AboutLink == "https://nixos.org" and .HelpLink == "https://nixos.org/nixos/manual"''}")

    ## Immutable node tests ##
    immutable.wait_for_unit("mattermost.service")
    immutable.wait_for_open_port(8065)

    # Get the initial config
    immutable.succeed("${expectConfig pkgs.mattermost ''.AboutLink == "https://nixos.org" and .HelpLink == "https://search.nixos.org"''}")

    # Edit the config
    immutable.succeed("${setConfig ''.SupportSettings.AboutLink = "https://mattermost.com"''}")
    immutable.succeed("${setConfig ''.SupportSettings.HelpLink = "https://nixos.org/nixos/manual"''}")
    immutable.systemctl("restart mattermost.service")
    immutable.wait_for_open_port(8065)

    # Our edits should be ignored on restart
    immutable.succeed("${expectConfig pkgs.mattermost ''.AboutLink == "https://nixos.org" and .HelpLink == "https://search.nixos.org"''}")

    ## Immutable v6 node tests ##
    immutable_6.wait_for_unit("mattermost.service")
    immutable_6.wait_for_open_port(8065)

    # Get the initial config
    immutable_6.succeed("${expectConfig pkgs.mattermost_6 ''.AboutLink == "https://nixos.org" and .HelpLink == "https://search.nixos.org"''}")

    # Edit the config
    immutable_6.succeed("${setConfig ''.SupportSettings.AboutLink = "https://mattermost.com"''}")
    immutable_6.succeed("${setConfig ''.SupportSettings.HelpLink = "https://nixos.org/nixos/manual"''}")
    immutable_6.systemctl("restart mattermost.service")
    immutable_6.wait_for_open_port(8065)

    # Our edits should be ignored on restart
    immutable_6.succeed("${expectConfig pkgs.mattermost_6 ''.AboutLink == "https://nixos.org" and .HelpLink == "https://search.nixos.org"''}")
  '';
})

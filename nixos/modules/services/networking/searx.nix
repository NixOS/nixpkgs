{ config, lib, pkgs, ... }:

with lib;

let
  dataDir = "/var/lib/searx";
  cfg = config.services.searx;

  hasEngines =
    builtins.hasAttr "engines" cfg.settings &&
    cfg.settings.engines != { };

  # Script to merge NixOS settings with
  # the default settings.yml bundled in searx.
  mergeConfig = ''
    cd ${dataDir}
    # find the default settings.yml
    default=$(find '${cfg.package}/' -name settings.yml)

    # write NixOS settings as JSON
    cat <<'EOF' > settings.json
      ${builtins.toJSON cfg.settings}
    EOF

    ${optionalString hasEngines ''
      # extract and convert the default engines array to an object
      ${pkgs.yq-go}/bin/yq r "$default" engines -j | \
      ${pkgs.jq}/bin/jq 'reduce .[] as $e ({}; .[$e.name] = $e)' \
        > engines.json

      # merge and update the NixOS engines with the newly created object
      cp settings.json temp.json
      ${pkgs.jq}/bin/jq -s '. as [$s, $e] | $s | .engines |=
        ($e * . | to_entries | map (.value))' \
        temp.json engines.json > settings.json

      # clean up temporary files
      rm {engines,temp}.json
    ''}

    # merge the default and NixOS settings
    ${pkgs.yq-go}/bin/yq m -P settings.json "$default" > settings.yml
    rm settings.json

    # substitute environment variables
    env -0 | while IFS='=' read -r -d ''' n v; do
      sed "s#@$n@#$v#g" -i settings.yml
    done
  '';

in

{

  imports = [
    (mkRenamedOptionModule
      [ "services" "searx" "configFile" ]
      [ "services" "searx" "settingsFile" ])
  ];

  ###### interface

  options = {

    services.searx = {

      enable = mkOption {
        type = types.bool;
        default = false;
        relatedPackages = [ "searx" ];
        description = "Whether to enable Searx, the meta search engine.";
      };

      environmentFile = mkOption {
        type = types.nullOr types.path;
        default = null;
        description = ''
          Environment file (see <literal>systemd.exec(5)</literal>
          "EnvironmentFile=" section for the syntax) to define variables for
          Searx. This option can be used to safely include secret keys into the
          Searx configuration.
        '';
      };

      settings = mkOption {
        type = types.attrs;
        default = { };
        example = literalExample ''
          { server.port = 8080;
            server.bind_address = "0.0.0.0";
            server.secret_key = "@SEARX_SECRET_KEY@";

            engines.wolframalpha =
              { shortcut = "wa";
                api_key = "@WOLFRAM_API_KEY@";
                engine = "wolframalpha_api";
              };
          }
        '';
        description = ''
          Searx settings. These will be merged with (taking precedence over)
          the default configuration. It's also possible to refer to
          environment variables
          (defined in <xref linkend="opt-services.searx.environmentFile"/>)
          using the syntax <literal>@VARIABLE_NAME@</literal>.
          <note>
            <para>
              For available settings, see the Searx
              <link xlink:href="https://searx.github.io/searx/admin/settings.html">docs</link>.
            </para>
          </note>
        '';
      };

      settingsFile = mkOption {
        type = types.path;
        default = "${dataDir}/settings.yml";
        description = ''
          The path of the Searx server settings.yml file. If no file is
          specified, a default file is used (default config file has debug mode
          enabled). Note: setting this options overrides
          <xref linkend="opt-services.searx.settings"/>.
          <warning>
            <para>
              This file, along with any secret key it contains, will be copied
              into the world-readable Nix store.
            </para>
          </warning>
        '';
      };

      package = mkOption {
        type = types.package;
        default = pkgs.searx;
        defaultText = "pkgs.searx";
        description = "searx package to use.";
      };

    };

  };


  ###### implementation

  config = mkIf config.services.searx.enable {
    systemd.services.searx = {
      description = "Searx server, the meta search engine.";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        User = "searx";
        DynamicUser = true;
        ExecStart = "${cfg.package}/bin/searx-run";
        StateDirectory = "searx";
      } // optionalAttrs (cfg.environmentFile != null)
        { EnvironmentFile = builtins.toPath cfg.environmentFile; };
      environment.SEARX_SETTINGS_PATH = cfg.settingsFile;
      preStart = mergeConfig;
    };

    environment.systemPackages = [ cfg.package ];

  };

  meta.maintainers = with lib.maintainers; [ rnhmjoj ];

}

{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  settingsFormat = {
    type =
      with lib.types;
      attrsOf (oneOf [
        bool
        int
        str
      ]);
    generate =
      name: attrs:
      pkgs.writeText name (
        lib.strings.concatStringsSep "\n" (
          lib.attrsets.mapAttrsToList (key: value: "${key}=${builtins.toJSON value}") attrs
        )
      );
  };
in
{
  options = {

    services.uhub = mkOption {
      default = { };
      description = "Uhub ADC hub instances";
      type = types.attrsOf (
        types.submodule {
          options = {

            enable = mkEnableOption "hub instance" // {
              default = true;
            };

            enableTLS = mkOption {
              type = types.bool;
              default = false;
              description = "Whether to enable TLS support.";
            };

            settings = mkOption {
              inherit (settingsFormat) type;
              description = ''
                Configuration of uhub.
                See https://www.uhub.org/doc/config.php for a list of options.
              '';
              default = { };
              example = {
                server_bind_addr = "any";
                server_port = 1511;
                hub_name = "My Public Hub";
                hub_description = "Yet another ADC hub";
                max_users = 150;
              };
            };

            plugins = mkOption {
              description = "Uhub plugin configuration.";
              type =
                with types;
                listOf (submodule {
                  options = {
                    plugin = mkOption {
                      type = path;
                      example = literalExpression "$${pkgs.uhub}/plugins/mod_auth_sqlite.so";
                      description = "Path to plugin file.";
                    };
                    settings = mkOption {
                      description = "Settings specific to this plugin.";
                      type = with types; attrsOf str;
                      example = {
                        file = "/etc/uhub/users.db";
                      };
                    };
                  };
                });
              default = [ ];
            };

          };
        }
      );
    };

  };

  config =
    let
      hubs = lib.attrsets.filterAttrs (_: cfg: cfg.enable) config.services.uhub;
    in
    {

      environment.etc = lib.attrsets.mapAttrs' (
        name: cfg:
        let
          settings' = cfg.settings // {
            tls_enable = cfg.enableTLS;
            file_plugins = pkgs.writeText "uhub-plugins.conf" (
              lib.strings.concatStringsSep "\n" (
                map (
                  { plugin, settings }:
                  ''plugin ${plugin} "${
                    toString (lib.attrsets.mapAttrsToList (key: value: "${key}=${value}") settings)
                  }"''
                ) cfg.plugins
              )
            );
          };
        in
        {
          name = "uhub/${name}.conf";
          value.source = settingsFormat.generate "uhub-${name}.conf" settings';
        }
      ) hubs;

      systemd.services = lib.attrsets.mapAttrs' (name: cfg: {
        name = "uhub-${name}";
        value =
          let
            pkg = pkgs.uhub.override { tlsSupport = cfg.enableTLS; };
          in
          {
            description = "high performance peer-to-peer hub for the ADC network";
            after = [ "network.target" ];
            wantedBy = [ "multi-user.target" ];
            reloadIfChanged = true;
            serviceConfig = {
              Type = "notify";
              ExecStart = "${pkg}/bin/uhub -c /etc/uhub/${name}.conf -L";
              ExecReload = "${pkgs.coreutils}/bin/kill -HUP $MAINPID";
              DynamicUser = true;

              AmbientCapabilities = "CAP_NET_BIND_SERVICE";
              CapabilityBoundingSet = "CAP_NET_BIND_SERVICE";
            };
          };
      }) hubs;
    };

}

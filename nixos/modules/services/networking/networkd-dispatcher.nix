{
  config,
  lib,
  pkgs,
  ...
}:

let

  cfg = config.services.networkd-dispatcher;

in
{

  options = {
    services.networkd-dispatcher = {

      enable = lib.mkEnableOption ''
        Networkd-dispatcher service for systemd-networkd connection status
        change. See [upstream instructions](https://gitlab.com/craftyguy/networkd-dispatcher)
        for usage
      '';

      rules = lib.mkOption {
        default = { };
        example = lib.literalExpression ''
          { "restart-tor" = {
              onState = ["routable" "off"];
              script = '''
                #!''${pkgs.runtimeShell}
                if [[ $IFACE == "wlan0" && $AdministrativeState == "configured" ]]; then
                  echo "Restarting Tor ..."
                  systemctl restart tor
                fi
                exit 0
              ''';
            };
          };
        '';
        description = ''
          Declarative configuration of networkd-dispatcher rules. See
          [upstream instructions](https://gitlab.com/craftyguy/networkd-dispatcher)
          for an introduction and example scripts.
        '';
        type = lib.types.attrsOf (
          lib.types.submodule {
            options = {
              onState = lib.mkOption {
                type = lib.types.listOf (
                  lib.types.enum [
                    "routable"
                    "dormant"
                    "no-carrier"
                    "off"
                    "carrier"
                    "degraded"
                    "configuring"
                    "configured"
                  ]
                );
                default = null;
                description = ''
                  List of names of the systemd-networkd operational states which
                  should trigger the script. See <https://www.freedesktop.org/software/systemd/man/networkctl.html>
                  for a description of the specific state type.
                '';
              };
              script = lib.mkOption {
                type = lib.types.lines;
                description = ''
                  Shell commands executed on specified operational states.
                '';
              };
            };
          }
        );
      };

      extraArgs = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ ];
        description = ''
          Extra arguments to pass to the networkd-dispatcher command.
        '';
        apply = lib.escapeShellArgs;
      };

    };
  };

  config = lib.mkIf cfg.enable {

    systemd = {
      packages = [ pkgs.networkd-dispatcher ];
      services.networkd-dispatcher = {
        wantedBy = [ "multi-user.target" ];
        environment.networkd_dispatcher_args = cfg.extraArgs;
      };
    };

    services.networkd-dispatcher.extraArgs =
      let
        scriptDir = pkgs.symlinkJoin {
          name = "networkd-dispatcher-script-dir";
          paths = lib.mapAttrsToList (
            name: cfg:
            (map (
              state:
              pkgs.writeTextFile {
                inherit name;
                text = cfg.script;
                destination = "/${state}.d/${name}";
                executable = true;
              }
            ) cfg.onState)
          ) cfg.rules;
        };
      in
      [
        "--verbose"
        "--script-dir"
        "${scriptDir}"
      ];

  };
}

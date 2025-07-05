{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let

  cfg = config.services.networkd-dispatcher;

in
{

  options = {
    services.networkd-dispatcher = {

      enable = mkEnableOption ''
        Networkd-dispatcher service for systemd-networkd connection status
        change. See [upstream instructions](https://gitlab.com/craftyguy/networkd-dispatcher)
        for usage
      '';

      rules = mkOption {
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
        type = types.attrsOf (
          types.submodule {
            options = {
              onState = mkOption {
                type = types.listOf (
                  types.enum [
                    "routable"
                    "dormant"
                    "no-carrier"
                    "off"
                    "carrier"
                    "degraded"
                    "configuring"
                    "configured"
                    "enslaved"
                  ]
                );
                default = null;
                description = ''
                  List of names of the systemd-networkd operational states which
                  should trigger the script. See {manpage}`networkctl(1)`
                  for a description of the specific state type.
                '';
              };
              script = mkOption {
                type = types.lines;
                description = ''
                  Shell commands executed on specified operational states.
                '';
              };
            };
          }
        );
      };

      extraArgs = mkOption {
        type = types.listOf types.str;
        default = [ ];
        description = ''
          Extra arguments to pass to the networkd-dispatcher command.
        '';
        apply = escapeShellArgs;
      };

    };
  };

  config = mkIf cfg.enable {

    systemd = {
      packages = [ pkgs.networkd-dispatcher ];
      services.networkd-dispatcher = {
        wantedBy = [ "multi-user.target" ];
        environment.networkd_dispatcher_args = cfg.extraArgs;
      };
    };

    services.networkd-dispatcher.extraArgs =
      let
        scriptDir = pkgs.runCommand "networkd-dispatcher-script-dir" { } (
          ''
            mkdir $out
          ''
          + (lib.concatStrings (
            lib.mapAttrsToList (
              name: cfg:
              (lib.concatStrings (
                map (state: ''
                  mkdir -p $out/${state}.d
                  ln -s ${
                    lib.getExe (
                      pkgs.writeShellApplication {
                        inherit name;
                        text = cfg.script;
                      }
                    )
                  } $out/${state}.d/${name}
                '') cfg.onState
              ))
            ) cfg.rules
          ))
        );
      in
      [
        "--verbose"
        "--script-dir"
        "${scriptDir}"
      ];

  };
}

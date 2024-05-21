{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.networkd-dispatcher;

in {

  options = {
    services.networkd-dispatcher = {

      enable = mkEnableOption ''
        Networkd-dispatcher service for systemd-networkd connection status
        change. See [https://gitlab.com/craftyguy/networkd-dispatcher](upstream instructions)
        for usage.
      '';

      rules = mkOption {
        default = {};
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
          [https://gitlab.com/craftyguy/networkd-dispatcher](upstream instructions)
          for an introduction and example scripts.
        '';
        type = types.attrsOf (types.submodule {
          options = {
            onState = mkOption {
              type = types.listOf (types.enum [
                "routable" "dormant" "no-carrier" "off" "carrier" "degraded"
                "configuring" "configured"
              ]);
              default = null;
              description = ''
                List of names of the systemd-networkd operational states which
                should trigger the script. See <https://www.freedesktop.org/software/systemd/man/networkctl.html>
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
        });
      };

    };
  };

  config = mkIf cfg.enable {

    systemd = {
      packages = [ pkgs.networkd-dispatcher ];
      services.networkd-dispatcher = {
        wantedBy = [ "multi-user.target" ];
        # Override existing ExecStart definition
        serviceConfig.ExecStart = let
          scriptDir = pkgs.symlinkJoin {
            name = "networkd-dispatcher-script-dir";
            paths = lib.mapAttrsToList (name: cfg:
              (map(state:
                pkgs.writeTextFile {
                  inherit name;
                  text = cfg.script;
                  destination = "/${state}.d/${name}";
                  executable = true;
                }
              ) cfg.onState)
            ) cfg.rules;
          };
        in [
          ""
          "${pkgs.networkd-dispatcher}/bin/networkd-dispatcher -v --script-dir ${scriptDir} $networkd_dispatcher_args"
        ];
      };
    };

  };
}


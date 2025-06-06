{ config, lib, pkgs, ... }:
let
  cfg = config.services.onedrive;

  onedriveLauncher =  pkgs.writeShellScriptBin
    "onedrive-launcher"
    ''
      # XDG_CONFIG_HOME is not recognized in the environment here.
      if [ -f $HOME/.config/onedrive-launcher ]
      then
        # Hopefully using underscore boundary helps locate variables
        for _onedrive_config_dirname_ in $(cat $HOME/.config/onedrive-launcher | grep -v '[ \t]*#' )
        do
          systemctl --user start onedrive@$_onedrive_config_dirname_
        done
      else
        systemctl --user start onedrive@onedrive
      fi
    ''
  ;

in {
  ### Documentation
  # meta.doc = ./onedrive.xml;

  ### Interface

  options.services.onedrive = {
     enable = lib.mkEnableOption "OneDrive service";

     package = lib.mkOption {
       type = lib.types.package;
       default = pkgs.onedrive;
       defaultText = lib.literalExpression "pkgs.onedrive";
       description = ''
         OneDrive package to use.
       '';
     };
  };
### Implementation

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    systemd.user.services."onedrive@" = {
      description = "Onedrive sync service";

      serviceConfig = {
        Type = "simple";
        ExecStart = ''
          ${cfg.package}/bin/onedrive --monitor --confdir=%h/.config/%i
        '';
        Restart="on-failure";
        RestartSec=3;
        RestartPreventExitStatus=3;
      };
    };

    systemd.user.services.onedrive-launcher = {
      wantedBy = [ "default.target" ];
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${onedriveLauncher}/bin/onedrive-launcher";
      };
    };
  };
}

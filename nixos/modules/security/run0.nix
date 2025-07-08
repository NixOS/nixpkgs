{
  config,
  lib,
  pkgs,
  options,
  ...
}:
let

  cfg = config.security.run0;
  run0-wrapper = pkgs.writeShellScriptBin "run0" ''
    #!${pkgs.bash}/bin/bash
    exec -a run0 ${pkgs.systemd}/bin/systemd-run "$@"
  '';

in

{

  ###### interface

  options.security.run0 = {

    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Whether to enable the {command}`run0` command, a non-setuid
        sudo alternative from systemd.
      '';
    };

    pamCfg = lib.mkOption {
      type = options.security.pam.services.type;
      default = {};
      description = ''
        Extra settings to add to systemd-run0 pam service.
      '';
    };

  };


  ###### implementation

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = config.security.polkit.enable;
        message = ''
                The `run0` program needs polkit for authorization.
        '';
      }
    ];

    security.wrappers.run0 = {
        owner = "root";
        group = "root";
        permissions = "a+x";
        setuid = false;
        setgid = false;
        source = "${run0-wrapper}/bin/run0";
    };



    security.pam.services.run0 = cfg.pamCfg;

  };

}

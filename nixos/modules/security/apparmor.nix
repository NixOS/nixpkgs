{pkgs, config, ...}:

let
  cfg = config.security.apparmor;
in

with pkgs.lib;

{

  ###### interface

  options = {

    security.apparmor = {

      enable = mkOption {
        default = false;
        description = ''
          Enable AppArmor application security system. Enable only if
          you want to further improve AppArmor.
        '';
      };

      profiles = mkOption {
        default = [];
        merge = mergeListOption;
        description = ''
          List of file names of AppArmor profiles.
        '';
      };

    };
  };


  ###### implementation

  config = mkIf (cfg.enable) {

    assertions = [ { assertion = config.boot.kernelPackages.kernel.features ? apparmor
                               && config.boot.kernelPackages.kernel.features.apparmor;
                     message = "AppArmor is enabled, but the kernel doesn't have AppArmor support"; }
                 ];

    environment.systemPackages = [ pkgs.apparmor ];

    systemd.services.apparmor = {
      #wantedBy = [ "basic.target" ];
      wantedBy = [ "local-fs.target" ];
      path = [ pkgs.apparmor ];

      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = "yes";
        ExecStart = concatMapStrings (profile:
          ''${pkgs.apparmor}/sbin/apparmor_parser -rKv -I ${pkgs.apparmor}/etc/apparmor.d/ "${profile}" ; ''
        ) cfg.profiles;
        ExecStop = concatMapStrings (profile:
          ''${pkgs.apparmor}/sbin/apparmor_parser -Rv -I ${pkgs.apparmor}/etc/apparmor.d/ "${profile}" ; ''
        ) cfg.profiles;
      };

    };

  };

}

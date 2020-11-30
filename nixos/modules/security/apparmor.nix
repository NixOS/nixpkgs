{ config, lib, pkgs, utils, ... }:

let
  inherit (lib) mkIf mkOption types concatMapStrings;
  cfg = config.security.apparmor;
in

{
  options = {
    security.apparmor = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = "Enable the AppArmor Mandatory Access Control system.";
      };
      profiles = mkOption {
        type = types.listOf types.path;
        default = [];
        description = "List of files containing AppArmor profiles.";
      };
      packages = mkOption {
        type = types.listOf types.package;
        default = [];
        description = "List of packages to be added to apparmor's include path";
      };
    };

    security.pam =
      let
        name = "apparmor";
        pamCfg = config.security.pam;
        modCfg = pamCfg.modules.${name};
      in
      utils.pam.mkPamModule {
        inherit name;
        mkSvcConfigCondition = svcCfg: svcCfg.modules.${name}.enable && cfg.enable;

        mkModuleOptions = global: {
          enable = mkOption {
            default = if global then false else modCfg.enable;
            type = types.bool;
            description = ''
              Enable support for attaching AppArmor profiles at the
              user/group level, e.g., as part of a role based access
              control scheme.
            '';
          };
        };

        mkSessionConfig = svcCfg: {
          ${name} = {
            control = "optional";
            path = "${pkgs.apparmor-pam}/lib/security/pam_apparmor.so";
            args = [
              "order=user,group,default"
              "debug"
            ];
            order = 15000;
          };
        };
      };
  };

   config = mkIf cfg.enable {
     environment.systemPackages = [ pkgs.apparmor-utils ];

     boot.kernelParams = [ "apparmor=1" "security=apparmor" ];

     systemd.services.apparmor = let
       paths = concatMapStrings (s: " -I ${s}/etc/apparmor.d")
         ([ pkgs.apparmor-profiles ] ++ cfg.packages);
     in {
       after = [ "local-fs.target" ];
       before = [ "sysinit.target" ];
       wantedBy = [ "multi-user.target" ];
       unitConfig = {
         DefaultDependencies = "no";
       };
       serviceConfig = {
         Type = "oneshot";
         RemainAfterExit = "yes";
         ExecStart = map (p:
           ''${pkgs.apparmor-parser}/bin/apparmor_parser -rKv ${paths} "${p}"''
         ) cfg.profiles;
         ExecStop = map (p:
           ''${pkgs.apparmor-parser}/bin/apparmor_parser -Rv "${p}"''
         ) cfg.profiles;
         ExecReload = map (p:
           ''${pkgs.apparmor-parser}/bin/apparmor_parser --reload ${paths} "${p}"''
         ) cfg.profiles;
       };
     };
   };
}

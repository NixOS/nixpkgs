{ config, lib, pkgs, ... }:

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

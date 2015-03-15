{ config, lib, pkgs, ... }:

let
  inherit (lib) mkIf mkOption types concatMapStrings;
  cfg = config.security.apparmor;
in

{
   #### interface
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

     };

   };

   #### implementation
   config = mkIf cfg.enable {

     environment.systemPackages = [
       pkgs.apparmor-utils
     ];

     systemd.services.apparmor = {
       wantedBy = [ "local-fs.target" ];

       serviceConfig = {
         Type = "oneshot";
         RemainAfterExit = "yes";
         ExecStart = concatMapStrings (p:
           ''${pkgs.apparmor-parser}/bin/apparmor_parser -rKv -I ${pkgs.apparmor-profiles}/etc/apparmor.d "${p}" ; ''
         ) cfg.profiles;
         ExecStop = concatMapStrings (p:
           ''${pkgs.apparmor-parser}/bin/apparmor_parser -Rv "${p}" ; ''
         ) cfg.profiles;
       };
     };

     security.pam.services.apparmor.text = ''
       ## The AppArmor service changes hats according to order: first try
       ## user, then group, and finally fall back to a hat called "DEFAULT"
       ##
       ## For now, enable debugging as this is an experimental feature.
       session optional ${pkgs.apparmor-pam}/lib/security/pam_apparmor.so order=user,group,default debug
     '';

   };
}

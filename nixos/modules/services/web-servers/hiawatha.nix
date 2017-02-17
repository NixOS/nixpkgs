{ config, lib, pkgs, ...}:
with lib;
let
  cfg = config.services.hiawatha;
 
  ###### Interface
in
{
  options = {
    services.hiawatha = {
      enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable the Hiawatha server";
   };

     configDir = mkOption {
     default = "${pkgs.hiawatha}/etc/hiawatha";
     type = types.path;
     example = "/etc/hiawatha";
     description = ''Location of configs
                     Note: Must create directory manually
                   '';};
       };
    };


  

#### Implementation

config = mkIf cfg.enable {

     systemd.services.hiawatha = {
       description = "Hiawatha";
       wantedBy = [ "multi-user.target" ];
      
     serviceConfig = {
       ExecStart = "${pkgs.hiawatha}/bin/hiawatha -c ${cfg.configDir}";
       Type = "forking";
       User = "hiawatha";
       Group = "hiawatha";
       
      };
     };
       environment.systemPackages = [ pkgs.hiawatha ];

       users.extraUsers.hiawatha = {
         group = "hiawatha";
         uid = config.ids.uids.hiawatha;
         };
       users.extraGroups.hiawatha.gid = config.ids.uids.hiawatha;
};
}

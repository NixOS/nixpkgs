 # Module to run mldonkey as a daemon
 
 { config, lib, pkgs, ... }:
 
 with lib;
 
 let
  cfg = config.services.mldonkey;
 in
 {
    ###### interface
    
    options = {
      services.mldonkey = {
      
        enable = mkEnableOption "mldonkey daemon";
               
        allowedIps = mkOption {
          type = types.str;
          default = "127.0.0.1";
          description = "IPs allowed to control the mldonkey daemon";
        };
        
        logToSyslog = mkOption {
          type = types.str;
          default = "true";
          description = "Wether or not mldonkey should log to syslog.";
        };
        
      };
    };
    
     ###### implementation
    
    config = mkIf cfg.enable {
    
      environment.systemPackages = [ pkgs.ocamlPackages.mldonkey ];
    
      users.extraUsers.mldonkey = {
        description     = "MLDonkey daemon user";
        home            = "/var/lib/mldonkey/";
        createHome      = true;
        group           = "mldonkey";
        uid             = config.ids.uids.mldonkey;
      };
      
      users.extraGroups.mldonkey.gid = config.ids.gids.mldonkey;
      
      systemd.services.mldonkeyd = {
        description     = "MLDonkey Daemon";
        after           = [ "local-fs.target" "network.target" ];
        wantedBy        = [ "multi-user.target" ];
        
       serviceConfig = {
          User          = "mldonkey";
          Group         = "mldonkey";
          Type          = "forking";
          ExecStart     = "${pkgs.ocamlPackages.mldonkey}/bin/mlnet -log_to_syslog ${cfg.logToSyslog} -allowed_ips \" ${cfg.allowedIps}\"";
          Restart       = "always";
        };
      };
    };
 }

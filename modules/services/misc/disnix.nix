# Disnix server
{config, pkgs, ...}:

###### interface
let
  inherit (pkgs.lib) mkOption;
  
  options = {
    services = {
      disnix = {
        enable = mkOption {
          default = false;
          description = "Whether to enable Disnix";
        };        
      };
    };
  };
in

###### implementation
let
  cfg = config.services.disnix;
  inherit (pkgs.lib) mkIf;

  job = {
    name = "disnix";
        
    job = ''
      description "Disnix server"

      start on dbus
      stop on shutdown  
    
      script
        export ACTIVATION_SCRIPTS=${pkgs.disnix_activation_scripts}/libexec/disnix/activation-scripts
        export PATH=${pkgs.nixUnstable}/bin
        export HOME=/root
	
        ${pkgs.disnix}/bin/disnix-service
      end script
    '';
  };
in

mkIf cfg.enable {
  require = [
    #../upstart-jobs/default.nix
    #../upstart-jobs/dbus.nix # services.dbus.*
    options
  ];
  
  environment.systemPackages = [ pkgs.disnix ];

  services = {
    extraJobs = [job];

    dbus = {
      enable = true;
      packages = [ pkgs.disnix ];
    };
  };
}

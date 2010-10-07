{ config, pkgs, ... }:

with pkgs.lib;

let 
  cfg = config.services.hydraChannelMirror ;
  mirrorChannel = pkgs.fetchsvn {
    url = https://svn.nixos.org/repos/nix/release/trunk/channels/mirror-channel.pl;
    rev = 24132;
    sha256 = "02xvswbbr2sj9k1wfraa0j9053vf6w88nhk15qwzs8nkm180n820";
  };
  cronjob = jobset : ''
    ${cfg.period} root ENABLE_PATCHES=1 PATH=${config.environment.nix}/libexec/nix:$PATH perl -I${config.environment.nix}/libexec/nix ${mirrorChannel} ${cfg.hydraURL}/jobset/${jobset.project}/${jobset.jobset}/channel/latest ${cfg.dataDir}/channels/${jobset.relURL} ${cfg.dataDir}/nars ${cfg.mirrorURL}/nars ${cfg.dataDir}/patches ${cfg.mirrorURL}/patches ${if jobset.nixexprs == "" then "" else "${cfg.hydraURL}/job/${jobset.project}/${jobset.jobset}/${jobset.nixexprs}/latest/download-by-type/file/source-dist"} >> ${cfg.dataDir}/logs/${jobset.name}.log
  '';
in
{
  options = {
  
    services.hydraChannelMirror = {

      enable = mkOption {
        default = false;
        description = ''
          Whether to enable Hydra channel mirroring.
        '';
      };

      period = mkOption {
        default = "15 * * * *";
        description = ''
          This option defines (in the format used by cron) when the
          mirroring should occur.
        '';
      };

      jobsets = mkOption {
        default = [ rec { name = "nixpkgs-unstable"; project = "nixpkgs"; jobset = "trunk"; nixexprs = "tarball"; relURL = "nixpkgs/channels/${name}"; } ];
        description = ''
          List of jobsets to mirror.
        '';
      };
 
      hydraURL = mkOption {
        default = "http://hydra.nixos.org";
        description = ''
          Location (URL) of Hydra instance
        '';
      };

      mirrorURL = mkOption {
        default = "http://nixos.org/releases";
        description = ''
          Location (URL) of Hydra mirror
        '';
      };

      dataDir = mkOption {
        default = "/data/hydra-mirror";
        description = ''
          Location of Hydra mirror data
        '';
      };
    };

  };

  config = mkIf cfg.enable {
  
    services.cron.systemCronJobs = map cronjob cfg.jobsets ;

    system.activationScripts.hydraChannelMirror = stringAfter [ "stdio" "users" ]
      ''
        mkdir -m 0755 -p ${cfg.dataDir}
        mkdir -m 0755 -p ${cfg.dataDir}/nars
        mkdir -m 0755 -p ${cfg.dataDir}/patches
        mkdir -m 0755 -p ${cfg.dataDir}/channels
        ln -fs ${cfg.dataDir}/nars ${cfg.dataDir}/channels/nars 
        ln -fs ${cfg.dataDir}/patches ${cfg.dataDir}/channels/patches 
        mkdir -m 0755 -p ${cfg.dataDir}/logs
        ${concatMapStrings (j : ''
        mkdir -m 0755 -p ${cfg.dataDir}/channels/${j.relURL}
        '') cfg.jobsets}
      '';
    
  };
  
}

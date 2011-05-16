{ config, pkgs, ... }:

with pkgs.lib;

let 

  cfg = config.services.hydraChannelMirror;

  mirrorChannel = pkgs.fetchsvn {
    url = https://svn.nixos.org/repos/nix/release/trunk/channels/mirror-channel.pl;
    rev = 25210;
    sha256 = "0gspqid1rpsj1z1mr29nakh7di278nlv6v2knafvmm3g8ah3yxgz";
  };

  cronjob = jobset:
    "${cfg.period} ${cfg.user}"
    + optionalString cfg.enableBinaryPatches " ENABLE_PATCHES=1"
    + " perl -I${config.environment.nix}/libexec/nix -I${pkgs.perlPackages.DBI}/lib/perl5/site_perl -I${pkgs.perlPackages.DBDSQLite}/lib/perl5/site_perl ${mirrorChannel}"
    + " ${cfg.hydraURL}/jobset/${jobset.project}/${jobset.jobset}/channel/latest"
    + " ${cfg.dataDir}/${jobset.project}/channels/${jobset.name}"
    + " ${cfg.dataDir}/nars"
    + " ${cfg.mirrorURL}/nars"
    + " ${cfg.dataDir}/patches"
    + " ${cfg.mirrorURL}/patches"
    + " ${if jobset.nixexprs == "" then "" else "${cfg.hydraURL}/job/${jobset.project}/${jobset.jobset}/${jobset.nixexprs}/latest/download-by-type/file/source-dist"}"
    + " >> ${cfg.dataDir}/logs/${jobset.name}.log 2>&1\n";

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

      user = mkOption {
        default = "hydra-mirror";
        description = ''
          User running the Hydra mirror script.
        '';
      };

      jobsets = mkOption {
        default = [ { name = "nixpkgs-unstable"; project = "nixpkgs"; jobset = "trunk"; nixexprs = "tarball"; } ];
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

      enableBinaryPatches = mkOption {
        default = false;
        description = ''
          Whether to enable generating binary patches for the mirrored channels.
        '';
      };
    };

  };

  config = mkIf cfg.enable {
  
    users.extraUsers = singleton
      { name = cfg.user; description = "Hydra mirror"; };

    services.cron.systemCronJobs = map cronjob cfg.jobsets;

    system.activationScripts.hydraChannelMirror = stringAfter [ "stdio" "users" ]
      ''
        mkdir -m 0755 -p ${cfg.dataDir}
        chown ${cfg.user} ${cfg.dataDir}

        mkdir -m 0755 -p ${cfg.dataDir}/nars
        chown ${cfg.user} ${cfg.dataDir}/nars

        mkdir -m 0755 -p ${cfg.dataDir}/patches
        chown ${cfg.user} ${cfg.dataDir}/patches

        mkdir -m 0755 -p ${cfg.dataDir}/logs
        chown ${cfg.user} ${cfg.dataDir}/logs

        ${concatMapStrings (j : ''
          mkdir -m 0755 -p ${cfg.dataDir}/${j.project}/channels/${j.name}
          chown ${cfg.user} ${cfg.dataDir}/${j.project}/channels/${j.name}
        '') cfg.jobsets}
      '';
    
  };
  
}

{ config, pkgs, lib, ... }:

with lib;
let
  cfg = config.programs.singularity;
in {
  options.programs.singularity = {
    enable = mkEnableOption "Singularity";
  };

  config = mkIf cfg.enable {
      environment.systemPackages = [ pkgs.singularity ];
      systemd.tmpfiles.rules = [ "d /var/singularity/mnt/session 0770 root root -"
                                 "d /var/singularity/mnt/final 0770 root root -"
                                 "d /var/singularity/mnt/overlay 0770 root root -"
                                 "d /var/singularity/mnt/container 0770 root root -"
                                 "d /var/singularity/mnt/source 0770 root root -"];
  };

}

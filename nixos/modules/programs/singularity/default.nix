{ config, pkgs, lib, ... }:

with lib;
let
  cfg = config.programs.singularity;
  singularity = pkgs.singularity.overrideAttrs (attrs : {
    patches = [ ./suid.patch ];
  });
in {
  options.programs.singularity = {
    enable = mkEnableOption "Singularity";
  };

  config = mkIf cfg.enable {
      environment.systemPackages = [ singularity ];
      security.wrappers.singularity-suid.source = "${singularity}/libexec/singularity/bin/starter-suid";
      systemd.tmpfiles.rules = [ "d /var/singularity/mnt/session 0770 root root -"
                                 "d /var/singularity/mnt/final 0770 root root -"
                                 "d /var/singularity/mnt/overlay 0770 root root -"
                                 "d /var/singularity/mnt/container 0770 root root -"
                                 "d /var/singularity/mnt/source 0770 root root -"];
  };

}

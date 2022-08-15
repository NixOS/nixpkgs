{ config, pkgs, lib, ... }:

with lib;

{
  # interface
  options.programs.k3b = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = lib.mdDoc ''
        Whether to enable k3b, the KDE disk burning application.

        Additionally to installing `k3b` enabling this will
        add `setuid` wrappers in `/run/wrappers/bin`
        for both `cdrdao` and `cdrecord`. On first
        run you must manually configure the path of `cdrdae` and
        `cdrecord` to correspond to the appropriate paths under
        `/run/wrappers/bin` in the "Setup External Programs" menu.
      '';
    };
  };

  # implementation
  config = mkIf config.programs.k3b.enable {

    environment.systemPackages = with pkgs; [
      k3b
      dvdplusrwtools
      cdrdao
      cdrkit
    ];

    security.wrappers = {
      cdrdao = {
        setuid = true;
        owner = "root";
        group = "cdrom";
        permissions = "u+wrx,g+x";
        source = "${pkgs.cdrdao}/bin/cdrdao";
      };
      cdrecord = {
        setuid = true;
        owner = "root";
        group = "cdrom";
        permissions = "u+wrx,g+x";
        source = "${pkgs.cdrkit}/bin/cdrecord";
      };
    };

  };
}

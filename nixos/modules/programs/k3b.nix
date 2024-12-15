{ config, pkgs, lib, ... }:

{
  # interface
  options.programs.k3b = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Whether to enable k3b, the KDE disk burning application.

        Additionally to installing `k3b` enabling this will
        add `setuid` wrappers in `/run/wrappers/bin`
        for both `cdrdao` and `cdrecord`. On first
        run you must manually configure the path of `cdrdao` and
        `cdrecord` to correspond to the appropriate paths under
        `/run/wrappers/bin` in the "Setup External Programs" menu.
      '';
    };

    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.kdePackages.k3b;
      description = "k3b package to use";
      defaultText = lib.literalExpression "pkgs.kdePackages.k3b";
      relatedPackages = [
        "kdePackages.k3b"
        "libsForQt5.k3b"
      ];
    };
  };

  # implementation
  config = lib.mkIf config.programs.k3b.enable {

    environment.systemPackages = with pkgs; [
      config.programs.k3b.package
      dvdplusrwtools
      cdrdao
      cdrtools
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
        source = "${pkgs.cdrtools}/bin/cdrecord";
      };
    };

  };
}

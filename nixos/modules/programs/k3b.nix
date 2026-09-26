{
  config,
  pkgs,
  lib,
  ...
}:

{
  options.programs.k3b = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Whether to enable k3b, the KDE disk burning application.

        Additionally to installing `k3b` enabling this will
        add `setuid` wrappers in `/run/wrappers/bin`
        for both `cdrdao` and `cdrecord`.
      '';
    };
  };

  config = lib.mkIf config.programs.k3b.enable {

    environment.systemPackages = with pkgs; [
      kdePackages.k3b
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

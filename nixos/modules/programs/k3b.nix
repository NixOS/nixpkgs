{ config, pkgs, lib, ... }:

with lib;

{
  # interface
  options.programs.k3b = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Whether to enable k3b, the KDE disk burning application.

        Additionally to installing <literal>k3b</literal> enabling this will
        add <literal>setuid</literal> wrappers in <literal>/run/wrappers/bin</literal>
        for both <literal>cdrdao</literal> and <literal>cdrecord</literal>. On first
        run you must manually configure the path of <literal>cdrdae</literal> and
        <literal>cdrecord</literal> to correspond to the appropriate paths under
        <literal>/run/wrappers/bin</literal> in the "Setup External Programs" menu.
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

{ config, lib, pkgs, ... }:

with lib;

let
  xcfg = config.services.xserver;
  cfg = xcfg.desktopManager.maxx;
  deps = [ pkgs.gcc ] ++ cfg.extraPackages;
in {
  options.services.xserver.desktopManager.maxx = {
    enable = mkEnableOption "MaXX desktop environment";

    extraPackages = mkOption {
      type = with types; listOf package;
      default = with pkgs; [
        xorg.xclock xsettingsd
      ];
      description = ''
        Extra packages visible to session.
      '';
    };
  };

  config = mkIf (xcfg.enable && cfg.enable) {
    environment.systemPackages = [ pkgs.maxx ];

    # there is hardcoded path in binaries
    system.activationScripts.setup-maxx = ''
      mkdir -p /opt
      ln -sfn ${pkgs.maxx}/opt/MaXX /opt
    '';

    services.xserver.desktopManager.session = [
    { name = "MaXX";
      start = ''
        export PATH="${makeBinPath deps}:$PATH"
        export GTK_PATH="${pkgs.gtk-engine-murrine}/lib/gtk-2.0:${pkgs.gtk_engines}/lib/gtk-2.0:$GTK_PATH"
        export GDK_PIXBUF_MODULE_FILE=$(echo ${pkgs.librsvg.out}/lib/gdk-pixbuf-2.0/*/loaders.cache)

        exec ${pkgs.maxx}/opt/MaXX/etc/skel/Xsession.dt
      '';
    }];
  };

  meta.maintainers = [ maintainers.gnidorah ];
}

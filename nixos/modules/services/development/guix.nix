{config, pkgs, lib, ...}:

with lib;

let

  cfg = config.services.guix;

  buildGuixUser = i:
    {
      "guixbuilder${builtins.toString i}" = {
        group = "guixbuild";
        extraGroups = ["guixbuild"];
        home = "/var/empty";
        shell = pkgs.nologin;
        description = "Guix build user ${builtins.toString i}";
        isSystemUser = true;
      };
    };

in {

  options.services.guix = {
    enable = mkEnableOption "GNU Guix package manager";
    package = mkOption {
      type = types.package;
      default = pkgs.guix;
      defaultText = "pkgs.guix";
      description = "Package that contains the guix binary and initial store.";
    };
  };

  config = mkIf (cfg.enable) {

    users = {
      extraUsers = lib.fold (a: b: a // b) {} (builtins.map buildGuixUser (lib.range 1 10));
      extraGroups.guixbuild = {name = "guixbuild";};
    };

    systemd.services.guix-daemon = {
      enable = true;
      description = "Build daemon for GNU Guix";
      serviceConfig = {
        ExecStart="/var/guix/profiles/per-user/root/current-guix/bin/guix-daemon --build-users-group=guixbuild";
        Environment="GUIX_LOCPATH=/var/guix/profiles/per-user/root/guix-profile/lib/locale";
        RemainAfterExit="yes";

        # See <https://lists.gnu.org/archive/html/guix-devel/2016-04/msg00608.html>.
        # Some package builds (for example, go@1.8.1) may require even more than
        # 1024 tasks.
        TasksMax="8192";
      };
      wantedBy = [ "multi-user.target" ];
    };

    system.activationScripts.guix = ''

      # copy initial /gnu/store
      if [ ! -d /gnu/store ]
      then
        mkdir -p /gnu
        cp -ra ${cfg.package.store}/gnu/store /gnu/
      fi

      # copy initial /var/guix content
      if [ ! -d /var/guix ]
      then
        mkdir -p /var
        cp -ra ${cfg.package.var}/var/guix /var/
      fi

      # root profile
      if [ ! -d ~root/.config/guix ]
      then
        mkdir -p ~root/.config/guix
        ln -sf /var/guix/profiles/per-user/root/current-guix \
          ~root/.config/guix/current
      fi

      # authorize substitutes
      GUIX_PROFILE="`echo ~root`/.config/guix/current"; source $GUIX_PROFILE/etc/profile
      guix archive --authorize < ~root/.config/guix/current/share/guix/ci.guix.info.pub
    '';

    environment.shellInit = ''
      # Make the Guix command available to users
      export PATH="/var/guix/profiles/per-user/root/current-guix/bin:$PATH"

      export GUIX_LOCPATH="$HOME/.guix-profile/lib/locale"
      export PATH="$HOME/.guix-profile/bin:$PATH"
      export INFOPATH="$HOME/.guix-profile/share/info:$INFOPATH"
    '';
  };

}

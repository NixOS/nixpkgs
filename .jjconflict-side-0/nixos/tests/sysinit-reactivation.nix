# This runs to two scenarios but in one tests:
# - A post-sysinit service needs to be restarted AFTER tmpfiles was restarted.
# - A service needs to be restarted BEFORE tmpfiles is restarted

{ lib, ... }:

let
  makeGeneration = generation: {
    "${generation}".configuration = {
      systemd.services.pre-sysinit-before-tmpfiles.environment.USER =
        lib.mkForce "${generation}-tmpfiles-user";

      systemd.services.pre-sysinit-after-tmpfiles.environment = {
        NEEDED_PATH = lib.mkForce "/run/${generation}-needed-by-pre-sysinit-after-tmpfiles";
        PATH_TO_CREATE = lib.mkForce "/run/${generation}-needed-by-post-sysinit";
      };

      systemd.services.post-sysinit.environment = {
        NEEDED_PATH = lib.mkForce "/run/${generation}-needed-by-post-sysinit";
        PATH_TO_CREATE = lib.mkForce "/run/${generation}-created-by-post-sysinit";
      };

      systemd.tmpfiles.settings.test = lib.mkForce {
        "/run/${generation}-needed-by-pre-sysinit-after-tmpfiles".f.user = "${generation}-tmpfiles-user";
      };
    };
  };
in

{

  name = "sysinit-reactivation";

  meta.maintainers = with lib.maintainers; [ nikstur ];

  nodes.machine =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      systemd.services.pre-sysinit-before-tmpfiles = {
        wantedBy = [ "sysinit.target" ];
        requiredBy = [ "sysinit-reactivation.target" ];
        before = [
          "systemd-tmpfiles-setup.service"
          "systemd-tmpfiles-resetup.service"
        ];
        unitConfig.DefaultDependencies = false;
        serviceConfig.Type = "oneshot";
        serviceConfig.RemainAfterExit = true;
        environment.USER = "tmpfiles-user";
        script = "${pkgs.shadow}/bin/useradd $USER";
      };

      systemd.services.pre-sysinit-after-tmpfiles = {
        wantedBy = [ "sysinit.target" ];
        requiredBy = [ "sysinit-reactivation.target" ];
        after = [
          "systemd-tmpfiles-setup.service"
          "systemd-tmpfiles-resetup.service"
        ];
        unitConfig.DefaultDependencies = false;
        serviceConfig.Type = "oneshot";
        serviceConfig.RemainAfterExit = true;
        environment = {
          NEEDED_PATH = "/run/needed-by-pre-sysinit-after-tmpfiles";
          PATH_TO_CREATE = "/run/needed-by-post-sysinit";
        };
        script = ''
          if [[ -e $NEEDED_PATH ]]; then
            touch $PATH_TO_CREATE
          fi
        '';
      };

      systemd.services.post-sysinit = {
        wantedBy = [ "default.target" ];
        serviceConfig.Type = "oneshot";
        serviceConfig.RemainAfterExit = true;
        environment = {
          NEEDED_PATH = "/run/needed-by-post-sysinit";
          PATH_TO_CREATE = "/run/created-by-post-sysinit";
        };
        script = ''
          if [[ -e $NEEDED_PATH ]]; then
            touch $PATH_TO_CREATE
          fi
        '';
      };

      systemd.tmpfiles.settings.test = {
        "/run/needed-by-pre-sysinit-after-tmpfiles".f.user = "tmpfiles-user";
      };

      specialisation = lib.mkMerge [
        (makeGeneration "second")
        (makeGeneration "third")
      ];
    };

  testScript =
    { nodes, ... }:
    ''
      def switch(generation):
        toplevel = "${nodes.machine.system.build.toplevel}";
        machine.succeed(f"{toplevel}/specialisation/{generation}/bin/switch-to-configuration switch")

      machine.wait_for_unit("default.target")
      machine.succeed("test -e /run/created-by-post-sysinit")

      switch("second")
      machine.succeed("test -e /run/second-created-by-post-sysinit")

      switch("third")
      machine.succeed("test -e /run/third-created-by-post-sysinit")
    '';
}

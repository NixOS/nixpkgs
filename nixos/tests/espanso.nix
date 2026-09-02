{ lib, runTest }:
let
  makeTest =
    conf:
    runTest {
      name = "espanso";
      meta.maintainers = with lib.maintainers; [ n8henrie ];

      nodes.machine =
        let
          base =
            { pkgs, config, ... }:
            {
              imports = [ ./common/user-account.nix ];
              services.espanso.enable = true;
              systemd.tmpfiles.settings.espanso =
                let
                  confdir = "${config.users.users.alice.home}/.config/espanso";
                  mode = "0755";
                  user = config.users.users.alice.name;
                  group = config.users.users.alice.group;
                in
                {
                  "${config.users.users.alice.home}/.config".d = { inherit mode user group; };
                  "${confdir}".d = { inherit mode user group; };
                  "${confdir}/config".d = { inherit mode user group; };
                  "${confdir}/match".d = { inherit mode user group; };
                  "${confdir}/config/default.yml".f = {
                    mode = "0644";
                    inherit user group;
                  };
                  "${confdir}/match/base.yml".f = {
                    mode = "0644";
                    inherit user group;
                    argument = lib.toJSON {
                      matches = [
                        {
                          trigger = ":nixostest";
                          replace = "My NixOS Test Passed!";
                        }
                      ];
                    };
                  };
                };
            };
        in
        {
          imports = [
            base
            conf
          ];
        };

      enableOCR = true;
      testScript = ''
        machine.wait_for_unit("graphical.target")
        machine.wait_for_text("Espanso is running!")
        machine.send_chars(":nixostest")
        machine.wait_for_text("My NixOS Test Passed!")
      '';
    };
in
{
  x11 = makeTest {
    imports = [ ./common/x11.nix ];
    test-support.displayManager.auto.user = "alice";
    users.users.alice.extraGroups = [ "input" ];
  };
  wayland = makeTest (
    { pkgs, config, ... }:
    {
      programs.sway.enable = true;
      services = {
        greetd =
          let
            initial_session = {
              user = config.users.users.alice.name;
              command = lib.getExe pkgs.sway;
            };
          in
          {
            enable = true;
            settings = {
              inherit initial_session;
              default_session = initial_session;
            };
          };
        espanso.package = pkgs.espanso-wayland;
      };
    }
  );
}

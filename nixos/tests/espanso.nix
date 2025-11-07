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
              system.activationScripts.espanso-config = {
                deps = [ "users" ];
                text =
                  let
                    confdir = "${config.users.users.alice.home}/.config/espanso";
                    espanso_conf =
                      let
                        settingsFormat = pkgs.formats.yaml { };
                      in
                      settingsFormat.generate "base.yaml" {
                        matches = [
                          {
                            trigger = ":nixostest";
                            replace = "My NixOS Test Passed!";
                          }
                        ];
                      };
                  in
                  ''
                    mkdir -p ${confdir}/{config,match}
                    touch ${confdir}/config/default.yml
                    cp ${espanso_conf} ${confdir}/match/base.yml
                    chown -R ${config.users.users.alice.name} ${confdir}
                  '';
              };
            };
        in
        lib.mkMerge [
          base
          conf
        ];

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

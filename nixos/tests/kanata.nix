{ lib, ... }:

{
  name = "kanata";

  meta = {
    maintainers = with lib.maintainers; [ linj ];
  };

  nodes = {
    machine = {
      specialisation.withKanata.configuration = {
        services.kanata = {
          enable = true;
          keyboards.all = {
            config = ''
              ;; map 1 to 2
              (defsrc 1)
              (deflayer default-layer 2)
            '';
          };
        };
      };
    };
  };

  testScript = ''
    machine.wait_for_unit("default.target")

    with subtest("enabling kanata at runtime, i.e., nixos-rebuild switch"):
      machine.succeed("/run/current-system/specialisation/withKanata/bin/switch-to-configuration switch")
      machine.wait_for_unit("kanata-all.service")
  '';
}

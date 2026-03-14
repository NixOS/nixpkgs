{ lib, ... }:
{
  _class = "nixosTest";

  name = "kanata-modular";

  nodes = {
    kanata =
      { pkgs, ... }:
      {
        services.kanata.enable = true;

        system.services.my-kanata = {
          imports = [ pkgs.kanata.services.default ];

          # https://github.com/jtroo/kanata/blob/main/cfg_samples/minimal.kbd
          kanata.config = ''
            (defsrc
              caps grv         i
                          j    k    l
              lsft rsft
            )

            (deflayer default
              @cap @grv        _
                          _    _    _
              _    _
            )

            (deflayer arrows
              _    _           up
                          left down rght
              _    _
            )

            (defalias
              cap (tap-hold-press 200 200 caps lctl)
              grv (tap-hold-press 200 200 grv (layer-toggle arrows))
            )
          '';
        };
      };
  };

  testScript = ''
    service_name = "my-kanata"
    machine.wait_for_unit(f"{service_name}.service")

    with subtest("kanata is running"):
         machine.succeed(f"systemctl status {service_name}")
    with subtest("kanata symlink is created"):
         machine.wait_for_file(f"/run/{service_name}/{service_name}", timeout=5)
  '';

  meta.maintainers = with lib.maintainers; [
    kaorilovescakes
  ];
}

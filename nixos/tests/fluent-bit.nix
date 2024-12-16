import ./make-test-python.nix (
  { lib, pkgs, ... }:
  {
    name = "fluent-bit";

    nodes.machine =
      { config, pkgs, ... }:
      {
        services.fluent-bit = {
          enable = true;
          settings = {
            pipeline = {
              inputs = [
                {
                  name = "systemd";
                  systemd_filter = "_SYSTEMD_UNIT=fluent-bit.service";
                }
              ];
              outputs = [
                {
                  name = "file";
                  path = "/var/log/fluent-bit";
                  file = "fluent-bit.out";
                }
              ];
            };
          };
        };

        systemd.services.fluent-bit.serviceConfig.LogsDirectory = "fluent-bit";
      };

    testScript = ''
      start_all()

      machine.wait_for_unit("fluent-bit.service")
      machine.wait_for_file("/var/log/fluent-bit/fluent-bit.out")
    '';
  }
)

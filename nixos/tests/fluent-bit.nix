# Regression test for https://github.com/NixOS/nixpkgs/pull/395128
{
  name = "fluent-bit";
  nodes.machine = {
    services.fluent-bit = {
      enable = true;
      settings = {
        pipeline = {
          inputs = [
            {
              name = "systemd";
              systemd_filter = "_SYSTEMD_UNIT=fluent-bit-regression-395128.service";
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

    # Logs get compressed when larger than 1024 bytes
    # Lets generate some logs that trigger that
    # This causes libzstd to be dlopen'd by systemd which breaks fluent-bit 3.2.7+
    # https://www.freedesktop.org/software/systemd/man/latest/journald.conf.html#Compress=
    systemd.services.fluent-bit-regression-395128 = {
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
      };
      script = ''
        for i in {1..20}; do
          (head -c 1200 < /dev/zero | tr '\0' 'A') && echo
          sleep 1
        done
      '';
    };
  };

  testScript = ''
    start_all()

    machine.wait_for_unit("fluent-bit.service")

    with subtest("fluent-bit handles zstd-compressed journal logs"):
      machine.succeed("systemctl start fluent-bit-regression-395128.service")
      machine.succeed("systemctl show -p NRestarts fluent-bit.service | grep -q 'NRestarts=0'")

    machine.wait_for_file("/var/log/fluent-bit/fluent-bit.out")
  '';
}

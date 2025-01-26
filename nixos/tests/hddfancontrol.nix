import ./make-test-python.nix (
  { pkgs, ... }:
  {
    name = "hddfancontrol";
    meta = with pkgs.lib.maintainers; {
      maintainers = [ benley ];
    };

    nodes.machine =
      { ... }:
      {
        imports = [ ../modules/profiles/minimal.nix ];

        services.hddfancontrol.enable = true;
        services.hddfancontrol.disks = [ "/dev/vda" ];
        services.hddfancontrol.pwmPaths = [ "/test/hwmon1/pwm1" ];
        services.hddfancontrol.extraArgs = [
          "--pwm-start-value=32"
          "--pwm-stop-value=0"
        ];

        systemd.services.hddfancontrol_fixtures = {
          description = "Install test fixtures for hddfancontrol";
          serviceConfig = {
            Type = "oneshot";
          };
          script = ''
            mkdir -p /test/hwmon1
            echo 255 > /test/hwmon1/pwm1
            echo 2 > /test/hwmon1/pwm1_enable
          '';
          wantedBy = [ "hddfancontrol.service" ];
          before = [ "hddfancontrol.service" ];
        };

        systemd.services.hddfancontrol.serviceConfig.ReadWritePaths = "/test";
      };

    # hddfancontrol.service will fail to start because qemu /dev/vda doesn't have
    # any thermal interfaces, but it should ensure that fans appear to be running
    # before it aborts.
    testScript = ''
      start_all()
      machine.wait_for_unit("multi-user.target")
      machine.succeed("journalctl -eu hddfancontrol.service|grep 'Setting fan speed'")
      machine.shutdown()

    '';

  }
)

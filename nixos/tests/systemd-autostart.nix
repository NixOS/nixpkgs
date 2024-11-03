import ./make-test-python.nix (
  { lib, ... }:
  {
    name = "systemd-autostart";
    meta.maintainers = [ lib.maintainers.lucasew ];

    nodes.demo =
      { pkgs, config, ... }:
      {
        systemd.services.test-system = {
          script = "echo hello world";
          autoStart = true;
        };
        systemd.services.test-system-empty = {
          script = "echo hello world";
        };
        systemd.user.services.test-user = {
          script = "echo hello world";
          autoStart = true;
        };
        systemd.user.services.test-user-empty = {
          script = "echo hello world";
        };

        assertions = [
          {
            assertion = config.systemd.services.test-system.wantedBy == [ "multi-user.target" ];
            message = "Bug in autoStart: wantedBy for system unit is not multi-user.target only";
          }
          {
            assertion = config.systemd.user.services.test-user.wantedBy == [ "default.target" ];
            message = "Bug in autoStart: wantedBy for user unit is not default.target only";
          }
          {
            assertion = config.systemd.services.test-system-empty.wantedBy == [ ];
            message = "Bug in autoStart: wantedBy for system unit and no autoStart should be empty";
          }
          {
            assertion = config.systemd.user.services.test-user-empty.wantedBy == [ ];
            message = "Bug in autoStart: wantedBy for user unit and no autoStart should be empty";
          }
        ];
      };

    testScript = ''
      # Doesn't matter, evaluation OK == runtime OK
    '';
  }
)

import ./make-test-python.nix (
  { lib, pkgs, ... }:
  {
    name = "ynetd";

    nodes.machine = {
      services.ynetd = {
        enable = true;

        instances = {
          echo = {
            enable = true;
            port = 7000;
            command = "${pkgs.coreutils}/bin/cat";
          };

          shell = {
            enable = true;
            port = 7001;
            command = "${pkgs.bash}/bin/bash -i";
            extraFlags = "-se y";
          };
        };
      };
    };

    testScript = ''
      start_all()

      machine.wait_for_unit("ynetd-echo.service")
      machine.wait_for_unit("ynetd-shell.service")

      machine.wait_for_open_port(7000)
      machine.wait_for_open_port(7001)

      # Test echo service
      echo_output = machine.succeed("echo 'Hello, world!' | nc -w 1 localhost 7000")
      assert "Hello, world!" in echo_output, f"Echo service failed: {echo_output}"

      # Test security
      machine.succeed("""
        cat > /tmp/shell_commands.txt << 'EOF'
        id -u -n
        cat /etc/shadow
        exit
        EOF
      """)

      # Send commands to the shell service and capture output
      security_output = machine.succeed("cat /tmp/shell_commands.txt | nc -w 2 localhost 7001")
      print(f"Security check output: {security_output}")

      # Verify running as nobody
      assert "nobody" in security_output, "Service not running as nobody user"

      # Verify cannot read /etc/shadow
      assert "Permission denied" in security_output, "Expected permission denied when trying to read /etc/shadow"

      # Verify services are active
      machine.succeed("systemctl is-active ynetd-echo.service")
      machine.succeed("systemctl is-active ynetd-shell.service")
    '';

    meta.maintainers = [ lib.maintainers.haylin ];
  }
)

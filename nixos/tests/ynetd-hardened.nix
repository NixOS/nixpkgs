import ./make-test-python.nix (
  { lib, pkgs, ... }:
  let
    powSolverScript = pkgs.writeTextFile {
      name = "pow-solver-script.py";
      text = ''
        import socket
        import re
        import subprocess
        import sys
        import time

        def main():
            # Connect to the service
            s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
            s.connect(('localhost', 7000))

            # Get the challenge
            challenge = s.recv(1024).decode('utf-8')
            print(f"Received challenge: {challenge}")

            # Extract the hex string from the challenge
            hex_match = re.search(r'unhex\("([0-9a-f]+)"', challenge)
            if not hex_match:
                print("Could not extract hex string from challenge")
                return 1

            hex_string = hex_match.group(1)

            # Extract the number of zero bits
            bits_match = re.search(r'(\d+) zero bits', challenge)
            if not bits_match:
                print("Could not extract zero bits from challenge")
                return 1

            zero_bits = bits_match.group(1)

            # Solve the PoW challenge
            solver_cmd = ["${pkgs.ynetd.hardened}/bin/pow-solver", zero_bits, hex_string]
            solution = subprocess.check_output(solver_cmd).decode('utf-8').strip()
            print(f"Solution: {solution}")

            # Send the solution
            s.sendall((solution + '\n').encode('utf-8'))

            # Wait a bit for the service to process the solution
            time.sleep(0.5)

            # Send our test message
            test_message = "Hello from hardened!\n"
            s.sendall(test_message.encode('utf-8'))

            # Get the response
            response = s.recv(1024).decode('utf-8')
            print(f"Response: {response}")

            # Check if our message was echoed back
            if "Hello from hardened!" in response:
                print("Test passed!")
                return 0
            else:
                print("Test failed!")
                return 1

        if __name__ == "__main__":
            sys.exit(main())
      '';
      executable = true;
      destination = "/bin/pow-solver-script.py";
    };
  in
  {
    name = "ynetd-hardened";

    nodes.machine = {
      services.ynetd = {
        enable = true;
        package = pkgs.ynetd.hardened;

        instances = {
          echo = {
            enable = true;
            port = 7000;
            command = "${pkgs.coreutils}/bin/cat";
            extraFlags = "-pow 5";
          };
        };
      };

      # Include our solver script
      environment.systemPackages = [ powSolverScript ];
    };

    testScript = ''
      start_all()

      machine.wait_for_unit("ynetd-echo.service")
      machine.wait_for_open_port(7000)

      # Run the test script
      test_result = machine.succeed("${pkgs.python3}/bin/python3 ${powSolverScript}/bin/pow-solver-script.py")
      print(f"Hardened test result: {test_result}")

      # Verify the test passed
      assert "Test passed!" in test_result, "Hardened echo service test failed"

      # Verify service is active
      machine.succeed("systemctl is-active ynetd-echo.service")
    '';

    meta.maintainers = [ lib.maintainers.haylin ];
  }
)

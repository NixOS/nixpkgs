import ../make-test-python.nix ({ pkgs, ...} : let
  port = 4318;

  # Load the test-script.py and replace port with port defined above.
  testScript = builtins.replaceStrings
    ["port = 4318"]
    ["port = ${toString port}"]
    (builtins.readFile ./test-script.py);
in {
  inherit testScript;

  name = "with-config-file";
  meta = with pkgs.lib.maintainers; {
    maintainers = [ tylerjl ];
  };

  nodes.machine = { ... }: {
    networking.firewall.allowedTCPPorts = [ port ];
    services.opentelemetry-collector = {
      enable = true;
      configFiles = [
        ./config/simple-config-1.yaml
        ./config/simple-config-2.yaml
      ];
    };
    virtualisation.forwardPorts = [{
      host.port = port;
      guest.port = port;
    }];
  };

  extraPythonPackages = p: [
    p.requests
    p.types-requests
  ];
})

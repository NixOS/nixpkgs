import ./make-test-python.nix (
  { ... }:
  {
    name = "localsend";

    nodes.machine =
      { ... }:
      {
        imports = [ ./common/x11.nix ];
        programs.localsend.enable = true;
      };

    testScript = ''
      machine.wait_for_x()
      machine.succeed("localsend_app >&2 &")
      machine.wait_for_open_port(53317)
      machine.wait_for_window("LocalSend", 10)
      machine.succeed("netstat --listening --program --tcp | grep -P 'tcp.*53317.*localsend'")
    '';
  }
)

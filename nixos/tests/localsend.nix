import ./make-test-python.nix ({ lib, pkgs, ... }: {
  name = "localsend";

  nodes.machine = { config, pkgs, ... }: {
    imports = [ ./common/x11.nix ];
    programs.localsend.enable = true;
  };

  testScript = ''
    machine.wait_for_x()
    machine.execute("localsend")
    machine.wait_for_window("LocalSend", 10)
    machine.wait_for_open_port(53317)
    machine.succeed("netstat --listening --program --tcp | grep -P 'tcp.*53317.*localsend'")
  '';
})

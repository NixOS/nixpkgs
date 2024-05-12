import ./make-test-python.nix ({ lib, pkgs, ... }: {
  name = "localsend";

  nodes.machine = { config, pkgs, ... }: {
    imports = [
      ./common/x11.nix
    ];
    services.xserver.enable = true;

    programs.localsend = {
      enable = true;
      openFirewall = true;
    };
  };

  testScript = ''
    machine.wait_for_x()
    machine.execute("localsend >&2 &")
    machine.wait_for_window("LocalSend")
    machine.wait_for_open_port(53317)
    machine.succeed("netstat --listening --program --tcp | grep -P 'tcp.*53317.*localsend'")
  '';
})

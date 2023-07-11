import ../make-test-python.nix ({ pkgs, ... }: {
  name = "croodle";
  meta = {
    maintainers = with pkgs.lib.maintainers; [ jboy ];
  };
  nodes = {
    machine = {
      services.croodle.enable = true;
    };
  };
  testScript = ''
    start_all()
    machine.wait_for_unit("phpfpm-croodle")
    machine.wait_for_open_port(80);
    machine.wait_until_succeeds("curl -s -L --fail http://localhost | grep 'Croodle'")
  '';
})

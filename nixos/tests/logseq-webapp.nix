import ./make-test-python.nix ({ pkgs, ... }:

{
  name = "logseq-webapp";
  meta = with pkgs.lib.maintainers; {
    maintainers = [ onny ];
  };

  nodes = {
    machine = { ... }: {
      services.logseq-webapp.enable = true;
    };
  };

  testScript = ''
    start_all()

    machine.wait_for_unit("caddy.service")
    machine.wait_for_open_port(80)

    machine.wait_until_succeeds("curl localhost | grep 'open-source platform for knowledge management and collaboration'")
  '';
})

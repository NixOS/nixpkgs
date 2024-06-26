import ./make-test-python.nix ({ pkgs, lib, ...} : {
  name = "plandex-server";
  meta = with pkgs.lib.maintainers; {
    maintainers = [ mattchrist ];
  };

  nodes.machine = { pkgs, ... }: {
    services.plandex-server = {
      enable = true;
      database.createLocally = true;
      port = 8080;
    };
  };

  testScript = ''
    machine.wait_for_open_port(8080)
    machine.succeed('${lib.getExe pkgs.curl} --fail-with-body http://localhost:8080/health')
  '';
})

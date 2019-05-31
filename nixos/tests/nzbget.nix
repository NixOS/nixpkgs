import ./make-test.nix ({ pkgs, ...} : {
  name = "nzbget";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ aanderse flokli ];
  };

  nodes = {
    server = { ... }: {
      services.nzbget.enable = true;

      # hack, don't add (unfree) unrar to nzbget's path,
      # so we can run this test in CI
      systemd.services.nzbget.path = pkgs.stdenv.lib.mkForce [ pkgs.p7zip ];
    };
  };

  testScript = ''
    startAll;

    $server->waitForUnit("nzbget.service");
    $server->waitForUnit("network.target");
    $server->waitForOpenPort(6789);
    $server->succeed("curl -s -u nzbget:tegbzn6789 http://127.0.0.1:6789 | grep -q 'This file is part of nzbget'");
    $server->succeed("${pkgs.nzbget}/bin/nzbget -n -o ControlIP=127.0.0.1 -o ControlPort=6789 -o ControlPassword=tegbzn6789 -V");
  '';
})

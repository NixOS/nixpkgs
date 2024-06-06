import ./make-test-python.nix ({pkgs, ...}: {
  name = "piped";

  meta = {
    maintainers = with pkgs.lib.maintainers; [defelo];
  };

  nodes = {
    machine = {
      config,
      lib,
      pkgs,
      ...
    }: {
      services.piped = {
        frontend = rec {
          enable = true;
          domain = "piped.example.com";
          externalUrl = "http://${domain}";
        };

        backend = rec {
          enable = true;
          database.passwordFile = builtins.toFile "db-password" "correct horse battery staple";
          port = 8000;
          nginx = {
            enable = true;
            domain = "pipedapi.example.com";
          };
          externalUrl = "http://${nginx.domain}";
        };

        proxy = rec {
          enable = true;
          port = 8001;
          nginx = {
            enable = true;
            domain = "pipedproxy.example.com";
          };
          externalUrl = "http://${nginx.domain}";
        };
      };

      networking.hosts."127.0.0.1" = [
        "piped.example.com"
        "pipedapi.example.com"
        "pipedproxy.example.com"
      ];
    };
  };

  testScript = ''
    from pathlib import Path
    import json
    import re

    machine.start()

    machine.wait_for_unit("nginx.service")
    machine.wait_for_open_port(80)
    machine.succeed("curl -s http://piped.example.com/ | grep '<title>Piped</title>'")

    asset = next(
      x for x in Path("${pkgs.piped}/assets").iterdir()
      if re.match(r"index-[a-zA-Z0-9_]+\.js", x.name)
      and "pipedapi.kavin.rocks" in x.read_text()
    )
    status, content = machine.execute(f"curl -s http://piped.example.com/assets/{asset.name}")
    assert status == 0
    assert "http://pipedapi.example.com" in content

    machine.wait_for_unit("piped-backend.service")
    machine.wait_for_open_port(8000)
    status, output = machine.execute("curl -s http://pipedapi.example.com/config")
    assert status == 0
    assert json.loads(output)["imageProxyUrl"] == "http://pipedproxy.example.com"

    machine.wait_for_unit("piped-proxy.service")
    machine.wait_for_open_port(8001)
    status, content = machine.execute("curl -s http://pipedproxy.example.com/")
    assert status == 0
    assert content.strip() == "No host provided"
  '';
})

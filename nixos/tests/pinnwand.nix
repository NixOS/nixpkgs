import ./make-test-python.nix ({ pkgs, ...}:
let
  pythonEnv = pkgs.python3.withPackages (py: with py; [ appdirs toml ]);

  port = 8000;
  baseUrl = "http://server:${toString port}";

  configureSteck = pkgs.writeScript "configure.py" ''
    #!${pythonEnv.interpreter}
    import appdirs
    import toml
    import os

    CONFIG = {
      "base": "${baseUrl}/",
      "confirm": False,
      "magic": True,
      "ignore": True
    }

    os.makedirs(appdirs.user_config_dir('steck'))
    with open(os.path.join(appdirs.user_config_dir('steck'), 'steck.toml'), "w") as fd:
        toml.dump(CONFIG, fd)
    '';
in
{
  name = "pinnwand";
  meta = with pkgs.lib.maintainers; {
    maintainers =[ hexa ];
  };

  nodes = {
    server = { config, ... }:
    {
      networking.firewall.allowedTCPPorts = [
        port
      ];

      services.pinnwand = {
        enable = true;
        port = port;
      };
    };

    client = { pkgs, ... }:
    {
      environment.systemPackages = [ pkgs.steck ];
    };
  };

  testScript = ''
    start_all()

    server.wait_for_unit("pinnwand.service")
    client.wait_for_unit("network.target")

    # create steck.toml config file
    client.succeed("${configureSteck}")

    # wait until the server running pinnwand is reachable
    client.wait_until_succeeds("ping -c1 server")

    # make sure pinnwand is listening
    server.wait_for_open_port(${toString port})

    # send the contents of /etc/machine-id
    response = client.succeed("steck paste /etc/machine-id")

    # parse the steck response
    raw_url = None
    removal_link = None
    for line in response.split("\n"):
        if line.startswith("View link:"):
            raw_url = f"${baseUrl}/raw/{line.split('/')[-1]}"
        if line.startswith("Removal link:"):
            removal_link = line.split(":", 1)[1]


    # start the reaper, it shouldn't do anything meaningful here
    server.systemctl("start pinnwand-reaper.service")
    server.wait_until_fails("systemctl is-active -q pinnwand-reaper.service")
    server.log(server.execute("journalctl -u pinnwand-reaper -e --no-pager")[1])

    # check whether paste matches what we sent
    client.succeed(f"curl {raw_url} > /tmp/machine-id")
    client.succeed("diff /tmp/machine-id /etc/machine-id")

    # remove paste and check that it's not available any more
    client.succeed(f"curl {removal_link}")
    client.fail(f"curl --fail {raw_url}")

    server.log(server.succeed("systemd-analyze security pinnwand"))
  '';
})

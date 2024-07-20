{ system ? builtins.currentSystem,
  config ? {},
  pkgs ? import ../.. { inherit system config; }
}:

with import ../lib/testing-python.nix { inherit system pkgs; };

let
  user = "alice";

  client =
    { pkgs, ... }:

    { imports = [ ./common/user-account.nix ./common/x11.nix ];
      hardware.graphics.enable = true;
      virtualisation.memorySize = 256;
      environment = {
        systemPackages = [ pkgs.armagetronad ];
        variables.XAUTHORITY = "/home/${user}/.Xauthority";
      };
      test-support.displayManager.auto.user = user;
    };

in
makeTest {
  name = "armagetronad";
  meta = with pkgs.lib.maintainers; {
    maintainers = [ numinit ];
  };

  enableOCR = true;

  nodes =
    {
      server = {
        services.armagetronad.servers = {
          high-rubber = {
            enable = true;
            name = "Smoke Test High Rubber Server";
            port = 4534;
            settings = {
              SERVER_OPTIONS = "High Rubber server made to run smoke tests.";
              CYCLE_RUBBER = 40;
              SIZE_FACTOR = 0.5;
            };
            roundSettings = {
              SAY = [
                "NixOS Smoke Test Server"
                "https://nixos.org"
              ];
            };
          };
          sty = {
            enable = true;
            name = "Smoke Test sty+ct+ap Server";
            package = pkgs.armagetronad."0.2.9-sty+ct+ap".dedicated;
            port = 4535;
            settings = {
              SERVER_OPTIONS = "sty+ct+ap server made to run smoke tests.";
              CYCLE_RUBBER = 20;
              SIZE_FACTOR = 0.5;
            };
            roundSettings = {
              SAY = [
                "NixOS Smoke Test sty+ct+ap Server"
                "https://nixos.org"
              ];
            };
          };
          trunk = {
            enable = true;
            name = "Smoke Test trunk Server";
            package = pkgs.armagetronad."0.4".dedicated;
            port = 4536;
            settings = {
              SERVER_OPTIONS = "0.4 server made to run smoke tests.";
              CYCLE_RUBBER = 20;
              SIZE_FACTOR = 0.5;
            };
            roundSettings = {
              SAY = [
                "NixOS Smoke Test 0.4 Server"
                "https://nixos.org"
              ];
            };
          };
        };
      };

      client1 = client;
      client2 = client;
    };

  testScript = let
    xdo = name: text: let
      xdoScript = pkgs.writeText "${name}.xdo" text;
    in "${pkgs.xdotool}/bin/xdotool ${xdoScript}";
  in
    ''
      import shlex
      import threading
      from collections import namedtuple

      class Client(namedtuple('Client', ('node', 'name'))):
        def send(self, *keys):
          for key in keys:
            self.node.send_key(key)

        def send_on(self, text, *keys):
          self.node.wait_for_text(text)
          self.send(*keys)

      Server = namedtuple('Server', ('node', 'name', 'address', 'port', 'welcome', 'attacker', 'victim', 'coredump_delay'))

      # Clients and their in-game names
      clients = (
        Client(client1, 'Arduino'),
        Client(client2, 'SmOoThIcE')
      )

      # Server configs.
      servers = (
        Server(server, 'high-rubber', 'server', 4534, 'NixOS Smoke Test Server', 'SmOoThIcE', 'Arduino', 8),
        Server(server, 'sty', 'server', 4535, 'NixOS Smoke Test sty+ct+ap Server', 'Arduino', 'SmOoThIcE', 8),
        Server(server, 'trunk', 'server', 4536, 'NixOS Smoke Test 0.4 Server', 'Arduino', 'SmOoThIcE', 8)
      )

      """
      Runs a command as the client user.
      """
      def run(cmd):
        return "su - ${user} -c " + shlex.quote(cmd)

      screenshot_idx = 1

      """
      Takes screenshots on all clients.
      """
      def take_screenshots(screenshot_idx):
        for client in clients:
          client.node.screenshot(f"screen_{client.name}_{screenshot_idx}")
        return screenshot_idx + 1

      # Wait for the servers to come up.
      start_all()
      for srv in servers:
        srv.node.wait_for_unit(f"armagetronad-{srv.name}")
        srv.node.wait_until_succeeds(f"ss --numeric --udp --listening | grep -q {srv.port}")

      # Make sure console commands work through the named pipe we created.
      for srv in servers:
        srv.node.succeed(
          f"echo 'say Testing!' >> /var/lib/armagetronad/{srv.name}/input"
        )
        srv.node.succeed(
          f"echo 'say Testing again!' >> /var/lib/armagetronad/{srv.name}/input"
        )
        srv.node.wait_until_succeeds(
          f"journalctl -u armagetronad-{srv.name} -e | grep -q 'Admin: Testing!'"
        )
        srv.node.wait_until_succeeds(
          f"journalctl -u armagetronad-{srv.name} -e | grep -q 'Admin: Testing again!'"
        )

      """
      Sets up a client, waiting for the given barrier on completion.
      """
      def client_setup(client, servers, barrier):
        client.node.wait_for_x()

        # Configure Armagetron.
        client.node.succeed(
          run("mkdir -p ~/.armagetronad/var"),
          run(f"echo 'PLAYER_1 {client.name}' >> ~/.armagetronad/var/autoexec.cfg")
        )
        for idx, srv in enumerate(servers):
          client.node.succeed(
            run(f"echo 'BOOKMARK_{idx+1}_ADDRESS {srv.address}' >> ~/.armagetronad/var/autoexec.cfg"),
            run(f"echo 'BOOKMARK_{idx+1}_NAME {srv.name}' >> ~/.armagetronad/var/autoexec.cfg"),
            run(f"echo 'BOOKMARK_{idx+1}_PORT {srv.port}' >> ~/.armagetronad/var/autoexec.cfg")
          )

        # Start Armagetron.
        client.node.succeed(run("ulimit -c unlimited; armagetronad >&2 & disown"))
        client.node.wait_until_succeeds(
          run(
            "${xdo "create_new_win-select_main_window" ''
              search --onlyvisible --name "Armagetron Advanced"
              windowfocus --sync
              windowactivate --sync
            ''}"
          )
        )

        # Get through the tutorial.
        client.send_on('Language Settings', 'ret')
        client.send_on('First Setup', 'ret')
        client.send_on('Welcome to Armagetron Advanced', 'ret')
        client.send_on('round 1', 'esc')
        client.send_on('Menu', 'up', 'up', 'ret')
        client.send_on('We hope you', 'ret')
        client.send_on('Armagetron Advanced', 'ret')
        client.send_on('Play Game', 'ret')

        # Online > LAN > Network Setup > Mates > Server Bookmarks
        client.send_on('Multiplayer', 'down', 'down', 'down', 'down', 'ret')

        barrier.wait()

      # Get to the Server Bookmarks screen on both clients. This takes a while so do it asynchronously.
      barrier = threading.Barrier(3, timeout=120)
      for client in clients:
        threading.Thread(target=client_setup, args=(client, servers, barrier)).start()
      barrier.wait()

      # Main testing loop. Iterates through each server bookmark and connects to them in sequence.
      # Assumes that the game is currently on the Server Bookmarks screen.
      for srv in servers:
        screenshot_idx = take_screenshots(screenshot_idx)

        # Connect both clients at once, one second apart.
        for client in clients:
          client.send('ret')
          client.node.sleep(1)

        # Wait for clients to connect
        for client in clients:
          srv.node.wait_until_succeeds(
            f"journalctl -u armagetronad-{srv.name} -e | grep -q '{client.name}.*entered the game'"
          )

        # Wait for the match to start
        srv.node.wait_until_succeeds(
          f"journalctl -u armagetronad-{srv.name} -e | grep -q 'Admin: {srv.welcome}'"
        )
        srv.node.wait_until_succeeds(
          f"journalctl -u armagetronad-{srv.name} -e | grep -q 'Admin: https://nixos.org'"
        )
        srv.node.wait_until_succeeds(
          f"journalctl -u armagetronad-{srv.name} -e | grep -q 'Go (round 1 of 10)'"
        )

        # Wait a bit
        srv.node.sleep(srv.coredump_delay)

        # Turn the attacker player's lightcycle left
        attacker = next(client for client in clients if client.name == srv.attacker)
        victim = next(client for client in clients if client.name == srv.victim)
        attacker.send('left')
        screenshot_idx = take_screenshots(screenshot_idx)

        # Wait for coredump.
        srv.node.wait_until_succeeds(
          f"journalctl -u armagetronad-{srv.name} -e | grep -q '{attacker.name} core dumped {victim.name}'"
        )
        screenshot_idx = take_screenshots(screenshot_idx)

        # Disconnect both clients from the server
        for client in clients:
          client.send('esc')
          client.send_on('Menu', 'up', 'up', 'ret')
          srv.node.wait_until_succeeds(
            f"journalctl -u armagetronad-{srv.name} -e | grep -q '{client.name}.*left the game'"
          )

        # Next server.
        for client in clients:
          client.send_on('Server Bookmarks', 'down')

      # Stop the servers
      for srv in servers:
        srv.node.succeed(
          f"systemctl stop armagetronad-{srv.name}"
        )
        srv.node.wait_until_fails(f"ss --numeric --udp --listening | grep -q {srv.port}")
    '';

}

import ./make-test-python.nix (
  { pkgs, ... }:
  {
    name = "renovate";
    meta.maintainers = with pkgs.lib.maintainers; [ marie natsukium ];

    nodes.machine =
      { config, ... }:
      {
        services.renovate = {
          enable = true;
          settings = {
            platform = "gitea";
            endpoint = "http://localhost:3000";
            autodiscover = true;
            gitAuthor = "Renovate <renovate@example.com>";
          };
          credentials = {
            RENOVATE_TOKEN = "/etc/renovate-token";
          };
        };
        environment.systemPackages = [
          config.services.forgejo.package
          pkgs.tea
          pkgs.git
        ];
        services.forgejo = {
          enable = true;
          settings.server.HTTP_PORT = 3000;
        };
      };

    testScript = ''
      def gitea(command):
        return machine.succeed(f"cd /var/lib/forgejo && sudo --user=forgejo GITEA_WORK_DIR=/var/lib/forgejo GITEA_CUSTOM=/var/lib/forgejo/custom gitea {command}")

      machine.wait_for_unit("forgejo.service")
      machine.wait_for_open_port(3000)

      machine.systemctl("stop forgejo.service")

      gitea("admin user create --username meow --email meow@example.com --password meow")

      machine.systemctl("start forgejo.service")
      machine.wait_for_unit("forgejo.service")
      machine.wait_for_open_port(3000)

      accessToken = gitea("admin user generate-access-token --raw --username meow --scopes all | tr -d '\n'")

      machine.succeed(f"tea login add --name default --user meow --token '{accessToken}' --password meow --url http://localhost:3000")
      machine.succeed("tea repo create --name kitty --init")
      machine.succeed("git config --global user.name Meow")
      machine.succeed("git config --global user.email meow@example.com")
      machine.succeed(f"git clone http://meow:{accessToken}@localhost:3000/meow/kitty.git /tmp/kitty")
      machine.succeed("echo '{ \"name\": \"meow\", \"version\": \"0.1.0\" }' > /tmp/kitty/package.json")
      machine.succeed("git -C /tmp/kitty add /tmp/kitty/package.json")
      machine.succeed("git -C /tmp/kitty commit -m 'add package.json'")
      machine.succeed("git -C /tmp/kitty push origin")

      machine.succeed(f"echo '{accessToken}' > /etc/renovate-token")
      machine.systemctl("start renovate.service")

      machine.succeed("tea pulls list --repo meow/kitty | grep 'Configure Renovate'")
      machine.succeed("tea pulls merge --repo meow/kitty 1")

      machine.systemctl("start renovate.service")
    '';
  }
)

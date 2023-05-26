import ./make-test-python.nix ({ pkgs, lib, ... }:

  let
    titleEnvFile = pkgs.writeText "pbin.env" ''
      PRIVATEBIN_NAME=NixOS Bin
    '';
    mkNode = extraConfig: { ... }: {
      environment.systemPackages = [
        pkgs.pbincli
      ];
      services.privatebin = lib.recursiveUpdate
        {
          enable = true;
          environmentFiles = [ titleEnvFile ];
          settings = {
            main.name._env = "PRIVATEBIN_NAME";
            traffic.limit = 300;
          };
        }
        extraConfig;
      networking.firewall.allowedTCPPorts = [ 80 ];
    };
  in
  {
    name = "privatebin";
    meta.maintainers = with lib.maintainers; [ e1mo ];

    nodes = {
      pgsql = mkNode {
        databaseSetup = {
          enable = true;
          kind = "pgsql";
        };
      };
      mysql = mkNode {
        databaseSetup = {
          enable = true;
          kind = "mysql";
        };
      };
      sqlite = mkNode {
        databaseSetup = {
          enable = true;
          kind = "sqlite";
        };
      };
      filesystem = mkNode {
        settings = {
          model.class = "Filesystem";
          model_options.dir = "/var/lib/privatebin/data";
        };
      };
    };

    testScript = ''
      start_all()

      def get_id_links(output):
        lines=paste_output.split("\n")
        id=lines[3].split("\t")[1].strip()
        link=lines[7].split("\t\t")[1].strip()
        delete_link=lines[8].split("\t")[1].strip()
        return (id,link,delete_link)

      for machine in [pgsql,mysql,sqlite,filesystem]:
        machine.wait_for_unit("phpfpm-privatebin.service")
        machine.succeed("timedatectl set-time '2023-05-26 10:00'")
        with subtest("Basic operations"):
          machine.wait_until_succeeds("curl --fail --insecure -L http://localhost/", timeout=10)
          assert "NixOS Bin" in machine.succeed("curl --fail --insecure -L http://localhost/")
          paste_output=machine.succeed('pbincli send -s "http://localhost" -t "Hello, NixOS!"')
          (id,link,delete_link) = get_id_links(paste_output)
          machine.succeed(f'pbincli get -s "http://localhost" "{link}"')
          machine.succeed(f'grep "Hello, NixOS!" paste-{id}.txt')
          machine.succeed(f'pbincli delete -s "http://localhost" "{delete_link}"')
          machine.fail(f'pbincli get -s "http://localhost" "{link}"')

        machine.succeed("timedatectl set-time '2023-05-26 11:00:00'")
        with subtest("Expiry"):
          paste_output=machine.succeed('pbincli send -s "http://localhost" -t "This will expire soon" -E 5min')
          (id,link,delete_link) = get_id_links(paste_output)
          machine.succeed(f'pbincli get -s "http://localhost" "{link}"')
          machine.succeed("timedatectl set-time '2023-05-26 11:05:30'")
          machine.fail(f'pbincli get -s "http://localhost" "{link}"')

        machine.succeed("timedatectl set-time '2023-05-26 12:00'")
        with subtest("Burn after reading"):
          paste_output=machine.succeed('pbincli send -s "http://localhost" -t "This will be burned" -B')
          (id,link,delete_link) = get_id_links(paste_output)
          machine.succeed(f'pbincli get -s "http://localhost" "{link}"')
          machine.fail(f'pbincli get -s "http://localhost" "{link}"')

        machine.succeed("timedatectl set-time '2023-05-26 13:00'")
        with subtest("Ratelimit"):
          machine.succeed('pbincli send -s "http://localhost" -t "This will be accepted"')
          machine.fail('pbincli send -s "http://localhost" -t "This will get ratelimited"')

        machine.shutdown()
    '';
  })

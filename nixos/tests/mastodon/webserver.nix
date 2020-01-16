import ../make-test-python.nix ({ pkgs, ...} : let

  basicConfig = { ... }: {
    services.mastodon = {
      enable = true;
      configureNginx = false;
    };
  };

in {
  name = "mastodon-webserver";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ happy-river ];
  };

  nodes = let
  in rec {
    alice =
      { ... }:
      {
        imports = [ basicConfig ];
        virtualisation.memorySize = 2048;
        services.mastodon = {
          smtp.user = "alice";
          smtp.fromAddress = "admin@alice.example.org";
          localDomain = "alice.example.org";
        };
      };
    };

  testScript =
    ''
      def mastodon_cmd(cmd):
          return f'su - mastodon -s /bin/sh -c "mastodon-env {cmd}" | cat'


      start_all()
      alice.wait_for_unit("multi-user.target")
      alice.log(alice.succeed(mastodon_cmd("tootctl settings registrations open")))
      alice.wait_for_open_port(55001)
      alice.succeed("curl http://localhost:55001/")
    '';
})

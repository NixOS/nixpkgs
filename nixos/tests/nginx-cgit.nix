{ ... }: {
  "http-clone" = import ./make-test-python.nix ({ lib, ... }: {
    name = "nginx-cgit-http-clone";
    meta = {
      maintainers = with lib.maintainers; [ afix-space hmenke ];
    };

    machine = { pkgs, ... }: {

      environment.systemPackages = [ pkgs.git ];

      services.nginx.enable = true;
      services.nginx.virtualHosts."localhost" = {
        cgit = {
          enable = true;
          virtual-root = "/";
          include = [
            (builtins.toFile "cgitrc-extra-1" ''
              repo.url=test-repo.git
              repo.path=/srv/git/test-repo.git
              repo.desc=the master foo repository
              repo.owner=fooman@example.com
            '')
            (builtins.toFile "cgitrc-extra-2" ''
              # Allow http transport git clone
              enable-http-clone=1
            '')
          ];
        };
      };
    };

    testScript = ''
      # Set up a test repository with only a single file that contains the string
      # "Hello World!".
      machine.succeed(
          """
          git config --global user.name "NixOS Test"
          git config --global user.email "NixOS Test"
          git init
          echo -n "Hello world!" > test.txt
          git add test.txt
          git commit -am "Test commit"
          git init --bare /srv/git/test-repo.git
          git push /srv/git/test-repo.git master
          """
      )

      machine.wait_for_unit("nginx.service")

      # Clone the repo on the client through cgit's http clone interface and
      # verify that the test file string is correct.
      text = machine.succeed(
          """
          git clone http://127.0.0.1/test-repo.git /tmp/test-repo
          cat /tmp/test-repo/test.txt
          """
      )
      assert text == "Hello world!", "Defective clone from cgit"
    '';
  });

  "location" = import ./make-test-python.nix ({ lib, ... }: {
    name = "nginx-cgit-location";
    meta = {
      maintainers = with lib.maintainers; [ afix-space hmenke ];
    };

    machine = { pkgs, ... }: {

      environment.systemPackages = [ pkgs.git ];

      services.nginx.enable = true;
      services.nginx.virtualHosts."localhost" = {
        cgit = {
          enable = true;
          location = "/somewhere/else/";
        };
      };
    };

    testScript = ''
      machine.wait_for_unit("nginx.service")
      machine.succeed("curl -fo /dev/null http://127.0.0.1/somewhere/else/cgit.png")
      machine.succeed("curl -fo /dev/null http://127.0.0.1/somewhere/else/cgit.css")
      machine.succeed("curl -fo /dev/null http://127.0.0.1/somewhere/else/favicon.ico")
      machine.succeed("curl -fo /dev/null http://127.0.0.1/somewhere/else/robots.txt")
    '';
  });

}

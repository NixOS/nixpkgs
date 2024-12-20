import ./make-test-python.nix ({ pkgs, lib, ... }: {
  name = "c2FmZQ";
  meta.maintainers = with lib.maintainers; [ hmenke ];

  nodes.machine = {
    services.c2fmzq-server = {
      enable = true;
      port = 8080;
      passphraseFile = builtins.toFile "pwfile" "hunter2"; # don't do this on real deployments
      settings = {
        verbose = 3; # debug
        # make sure multiple freeform options evaluate
        allow-new-accounts = true;
        auto-approve-new-accounts = true;
        licenses = false;
      };
    };
    environment = {
      sessionVariables = {
        C2FMZQ_PASSPHRASE = "lol";
        C2FMZQ_API_SERVER = "http://localhost:8080";
      };
      systemPackages = [
        pkgs.c2fmzq
        (pkgs.writeScriptBin "c2FmZQ-client-wrapper" ''
          #!${pkgs.expect}/bin/expect -f
          spawn c2FmZQ-client {*}$argv
          expect {
            "Enter password:" { send "$env(PASSWORD)\r" }
            "Type YES to confirm:" { send "YES\r" }
            timeout { exit 1 }
            eof { exit 0 }
          }
          interact
        '')
      ];
    };
  };

  testScript = { nodes, ... }: ''
    machine.start()
    machine.wait_for_unit("c2fmzq-server.service")
    machine.wait_for_open_port(8080)

    with subtest("Create accounts for alice and bob"):
        machine.succeed("PASSWORD=foobar c2FmZQ-client-wrapper -- -v 3 create-account alice@example.com")
        machine.succeed("PASSWORD=fizzbuzz c2FmZQ-client-wrapper -- -v 3 create-account bob@example.com")

    with subtest("Log in as alice"):
        machine.succeed("PASSWORD=foobar c2FmZQ-client-wrapper -- -v 3 login alice@example.com")
        msg = machine.succeed("c2FmZQ-client -v 3 status")
        assert "Logged in as alice@example.com" in msg, f"ERROR: Not logged in as alice:\n{msg}"

    with subtest("Create a new album, upload a file, and delete the uploaded file"):
        machine.succeed("c2FmZQ-client -v 3 create-album 'Rarest Memes'")
        machine.succeed("echo 'pls do not steal' > meme.txt")
        machine.succeed("c2FmZQ-client -v 3 import meme.txt 'Rarest Memes'")
        machine.succeed("c2FmZQ-client -v 3 sync")
        machine.succeed("rm meme.txt")

    with subtest("Share the album with bob"):
        machine.succeed("c2FmZQ-client-wrapper -- -v 3 share 'Rarest Memes' bob@example.com")

    with subtest("Log in as bob"):
        machine.succeed("PASSWORD=fizzbuzz c2FmZQ-client-wrapper -- -v 3 login bob@example.com")
        msg = machine.succeed("c2FmZQ-client -v 3 status")
        assert "Logged in as bob@example.com" in msg, f"ERROR: Not logged in as bob:\n{msg}"

    with subtest("Download the shared file"):
        machine.succeed("c2FmZQ-client -v 3 download 'shared/Rarest Memes/meme.txt'")
        machine.succeed("c2FmZQ-client -v 3 export 'shared/Rarest Memes/meme.txt' .")
        msg = machine.succeed("cat meme.txt")
        assert "pls do not steal\n" == msg, f"File content is not the same:\n{msg}"

    with subtest("Test that PWA is served"):
        msg = machine.succeed("curl -sSfL http://localhost:8080")
        assert "c2FmZQ" in msg, f"Could not find 'c2FmZQ' in the output:\n{msg}"

    with subtest("A setting with false value is properly passed"):
        machine.succeed("systemctl show -p ExecStart --value c2fmzq-server.service | grep -F -- '--licenses=false'");
  '';
})

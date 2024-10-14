import ./make-test-python.nix ({ pkgs, ... }:
{
  name = "openssh";

  nodes = {
    server = {
      services.openssh = {
        enable = true;
        settings.PasswordAuthentication = true;
      };
    };

    server-allowed-users = {
      services.openssh = {
        enable = true;
        settings = {
          AllowUsers = [ "alice" "bob" ];
          PasswordAuthentication = true;
        };
      };
      users.groups = { alice = { }; bob = { }; carol = { }; };
      users.users = {
        alice = { isNormalUser = true; group = "alice"; password = "alice"; };
        bob = { isSystemUser = true; group = "bob"; password = "bob"; };
        carol = { isNormalUser = true; group = "carol"; password = "carol"; };
      };
    };

    server-root-login = {
      services.openssh = {
        enable = true;
        settings = {
          PermitRootLogin = "yes";
          PermitEmptyPasswords = "yes";
          PasswordAuthentication = true;
        };
      };
      security.pam.services.sshd.allowNullPassword = true;
      users.groups = { alice = { }; };
      users.users = {
        # root.hashedPasswordFile = "${pkgs.writeText "hashed-password.root" ""}";
        alice = { isNormalUser = true; group = "alice"; password = "alice"; };
      };
      users.mutableUsers = false;
    };

    server-permit-empty = {
      services.openssh = {
        enable = true;
        settings = {
          AllowUsers = [ "alice" "bob" ];
          PermitEmptyPasswords = "yes";
          PasswordAuthentication = true;
        };
      };
      security.pam.services.sshd.allowNullPassword = true;
      users.groups = { alice = { }; bob = { }; carol = { }; };
      users.users = {
        alice = { isNormalUser = true; group = "alice"; password = ""; };
        bob = { isNormalUser = true; group = "bob"; password = "bob"; };
      };
    };

    client = {
      environment.systemPackages = with pkgs; [
        sshpass
      ];
    };
  };

  testScript = ''
    start_all()

    server.wait_for_unit("sshd", timeout=30)
    server_allowed_users.wait_for_unit("sshd", timeout=30)
    server_root_login.wait_for_unit("sshd", timeout=30)
    server_permit_empty.wait_for_unit("sshd", timeout=30)

    with subtest("allowed-users"):
        client.succeed(
            "sshpass -p alice ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no alice@server-allowed-users true",
            timeout=30
        )
        client.fail(
            "sshpass -p bob ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no bob@server-allowed-users true",
            timeout=30
        )
        client.fail(
            "sshpass -p carol ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no carol@server-allowed-users true",
            timeout=30
        )

    with subtest("server-root-login"):
        client.succeed(
            "ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no root@server-root-login true",
            timeout=30
        )

        ### BUG! DOES NOT WORK
        # client.succeed(
        #     "sshpass -p alice ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no alice@server-root-login true",
        #     timeout=30
        # )

    with subtest("server-permit-empty"):
        client.succeed(
            "ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no alice@server-permit-empty true",
            timeout=30
        )

        ### BUG! DOES NOT WORK
        # client.succeed(
        #     "sshpass -p bob ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no bob@server-permit-empty true",
        #     timeout=30
        # )
  '';
})

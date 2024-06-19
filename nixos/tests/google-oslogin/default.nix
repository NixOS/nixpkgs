import ../make-test-python.nix ({ pkgs, ... } :
let
  inherit (import ./../ssh-keys.nix pkgs)
    snakeOilPrivateKey snakeOilPublicKey;

    # don't check host keys or known hosts, use the snakeoil ssh key
    ssh-config = builtins.toFile "ssh.conf" ''
      UserKnownHostsFile=/dev/null
      StrictHostKeyChecking=no
      IdentityFile=~/.ssh/id_snakeoil
    '';
in {
  name = "google-oslogin";
  meta = with pkgs.lib.maintainers; {
    maintainers = [ flokli ];
  };

  nodes = {
    # the server provides both the the mocked google metadata server and the ssh server
    server = (import ./server.nix pkgs);

    client = { ... }: {};
  };
  testScript =  ''
    MOCKUSER = "mockuser_nixos_org"
    MOCKADMIN = "mockadmin_nixos_org"
    start_all()

    server.wait_for_unit("mock-google-metadata.service")
    server.wait_for_open_port(80)

    # mockserver should return a non-expired ssh key for both mockuser and mockadmin
    server.succeed(
        f'${pkgs.google-guest-oslogin}/bin/google_authorized_keys {MOCKUSER} | grep -q "${snakeOilPublicKey}"'
    )
    server.succeed(
        f'${pkgs.google-guest-oslogin}/bin/google_authorized_keys {MOCKADMIN} | grep -q "${snakeOilPublicKey}"'
    )

    # install snakeoil ssh key on the client, and provision .ssh/config file
    client.succeed("mkdir -p ~/.ssh")
    client.succeed(
        "cat ${snakeOilPrivateKey} > ~/.ssh/id_snakeoil"
    )
    client.succeed("chmod 600 ~/.ssh/id_snakeoil")
    client.succeed("cp ${ssh-config} ~/.ssh/config")

    client.wait_for_unit("network.target")
    server.wait_for_unit("sshd.service")

    # we should not be able to connect as non-existing user
    client.fail("ssh ghost@server 'true'")

    # we should be able to connect as mockuser
    client.succeed(f"ssh {MOCKUSER}@server 'true'")
    # but we shouldn't be able to sudo
    client.fail(
        f"ssh {MOCKUSER}@server '/run/wrappers/bin/sudo /run/current-system/sw/bin/id' | grep -q 'root'"
    )

    # we should also be able to log in as mockadmin
    client.succeed(f"ssh {MOCKADMIN}@server 'true'")
    # pam_oslogin_admin.so should now have generated a sudoers file
    server.succeed(
        f"find /run/google-sudoers.d | grep -q '/run/google-sudoers.d/{MOCKADMIN}'"
    )

    # and we should be able to sudo
    client.succeed(
        f"ssh {MOCKADMIN}@server '/run/wrappers/bin/sudo /run/current-system/sw/bin/id' | grep -q 'root'"
    )
  '';
  })

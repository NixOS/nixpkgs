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
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ adisbladis flokli ];
  };

  nodes = {
    # the server provides both the the mocked google metadata server and the ssh server
    server = (import ./server.nix pkgs);

    client = { ... }: {};
  };
  testScript =  ''
    start_all()

    server.wait_for_unit("mock-google-metadata.service")
    server.wait_for_open_port(80)

    # mockserver should return a non-expired ssh key for both mockuser and mockadmin
    server.succeed(
        '${pkgs.google-compute-engine-oslogin}/bin/google_authorized_keys mockuser | grep -q "${snakeOilPublicKey}"'
    )
    server.succeed(
        '${pkgs.google-compute-engine-oslogin}/bin/google_authorized_keys mockadmin | grep -q "${snakeOilPublicKey}"'
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
    client.succeed("ssh mockuser@server 'true'")
    # but we shouldn't be able to sudo
    client.fail(
        "ssh mockuser@server '/run/wrappers/bin/sudo /run/current-system/sw/bin/id' | grep -q 'root'"
    )

    # we should also be able to log in as mockadmin
    client.succeed("ssh mockadmin@server 'true'")
    # pam_oslogin_admin.so should now have generated a sudoers file
    server.succeed("find /run/google-sudoers.d | grep -q '/run/google-sudoers.d/mockadmin'")

    # and we should be able to sudo
    client.succeed(
        "ssh mockadmin@server '/run/wrappers/bin/sudo /run/current-system/sw/bin/id' | grep -q 'root'"
    )
  '';
  })


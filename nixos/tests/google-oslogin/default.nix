import ../make-test.nix ({ pkgs, ... } :
let
  inherit (import ./../ssh-keys.nix pkgs)
    snakeOilPrivateKey snakeOilPublicKey;
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
    startAll;

    $server->waitForUnit("mock-google-metadata.service");
    $server->waitForOpenPort(80);

    # mockserver should return a non-expired ssh key for both mockuser and mockadmin
    $server->succeed('${pkgs.google-compute-engine-oslogin}/bin/google_authorized_keys mockuser | grep -q "${snakeOilPublicKey}"');
    $server->succeed('${pkgs.google-compute-engine-oslogin}/bin/google_authorized_keys mockadmin | grep -q "${snakeOilPublicKey}"');

    # install snakeoil ssh key on the client
    $client->succeed("mkdir -p ~/.ssh");
    $client->succeed("cat ${snakeOilPrivateKey} > ~/.ssh/id_snakeoil");
    $client->succeed("chmod 600 ~/.ssh/id_snakeoil");

    $client->waitForUnit("network.target");
    $server->waitForUnit("sshd.service");

    # we should not be able to connect as non-existing user
    $client->fail("ssh -o User=ghost -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no server -i ~/.ssh/id_snakeoil 'true'");

    # we should be able to connect as mockuser
    $client->succeed("ssh -o User=mockuser -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no server -i ~/.ssh/id_snakeoil 'true'");
    # but we shouldn't be able to sudo
    $client->fail("ssh -o User=mockuser -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no server -i ~/.ssh/id_snakeoil '/run/wrappers/bin/sudo /run/current-system/sw/bin/id' | grep -q 'root'");

    # we should also be able to log in as mockadmin
    $client->succeed("ssh -o User=mockadmin -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no server -i ~/.ssh/id_snakeoil 'true'");
    # pam_oslogin_admin.so should now have generated a sudoers file
    $server->succeed("find /run/google-sudoers.d | grep -q '/run/google-sudoers.d/mockadmin'");

    # and we should be able to sudo
    $client->succeed("ssh -o User=mockadmin -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no server -i ~/.ssh/id_snakeoil '/run/wrappers/bin/sudo /run/current-system/sw/bin/id' | grep -q 'root'");
  '';
  })


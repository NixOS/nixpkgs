let
  user = "someuser";
  password = "some_password";
  port = builtins.toString 5232;
in
  import ./make-test.nix ({ pkgs, lib, ... }: {
  name = "radicale";
  meta.maintainers = with lib.maintainers; [ aneeshusa infinisil ];

  machine = {
    services.radicale = {
      enable = true;
      config = ''
        [auth]
        type = htpasswd
        htpasswd_filename = /etc/radicale/htpasswd
        htpasswd_encryption = bcrypt

        [storage]
        filesystem_folder = /tmp/collections

        [logging]
        debug = True
      '';
    };
    # WARNING: DON'T DO THIS IN PRODUCTION!
    # This puts secrets (albeit hashed) directly into the Nix store for ease of testing.
    environment.etc."radicale/htpasswd".source = pkgs.runCommand "htpasswd" {} ''
      ${pkgs.apacheHttpd}/bin/htpasswd -bcB "$out" ${user} ${password}
    '';
  };
  
  # This tests whether the web interface is accessible to an authenticated user
  testScript = ''
    $machine->waitForUnit('radicale.service');
    $machine->waitForOpenPort(${port});
    $machine->succeed('curl --fail http://${user}:${password}@localhost:${port}/.web/');
  '';
})

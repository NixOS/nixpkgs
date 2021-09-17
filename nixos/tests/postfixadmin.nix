import ./make-test-python.nix ({ pkgs, ...} : {
  name = "postfixadmin";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ globin ];
  };

  nodes = {
    postfixadmin = { config, pkgs, ... }: {
      services.postfixadmin = {
        enable = true;
        hostName = "postfixadmin";
        setupPasswordFile = pkgs.writeText "insecure-test-setup-pw-file" "$2y$10$r0p63YCjd9rb9nHrV9UtVuFgGTmPDLKu.0UIJoQTkWCZZze2iuB1m";
      };
      services.nginx.virtualHosts.postfixadmin = {
        forceSSL = false;
        enableACME = false;
      };
    };
  };

  testScript = ''
    postfixadmin.start
    postfixadmin.wait_for_unit("postgresql.service")
    postfixadmin.wait_for_unit("phpfpm-postfixadmin.service")
    postfixadmin.wait_for_unit("nginx.service")
    postfixadmin.succeed(
        "curl -sSfL http://postfixadmin/setup.php -X POST -F 'setup_password=not production'"
    )
    postfixadmin.succeed("curl -sSfL http://postfixadmin/ | grep 'Mail admins login here'")
  '';
})

import ./make-test-python.nix ({ pkgs, lib, ... }: {
  name = "dolibarr";
  meta.maintainers = [ ];

  nodes.machine =
    { ... }:
    {
      services.dolibarr = {
        enable = true;
        domain = "localhost";
        nginx = {
          forceSSL = false;
          enableACME = false;
        };
      };

      networking.firewall.allowedTCPPorts = [ 80 ];
    };

  testScript = ''
    from html.parser import HTMLParser
    start_all()

    csrf_token = None
    class TokenParser(HTMLParser):
      def handle_starttag(self, tag, attrs):
        attrs = dict(attrs) # attrs is an assoc list originally
        if tag == 'input' and attrs.get('name') == 'token':
            csrf_token = attrs.get('value')
            print(f'[+] Caught CSRF token: {csrf_token}')
      def handle_endtag(self, tag): pass
      def handle_data(self, data): pass

    machine.wait_for_unit("phpfpm-dolibarr.service")
    machine.wait_for_unit("nginx.service")
    machine.wait_for_open_port(80)
    # Sanity checks on URLs.
    # machine.succeed("curl -fL http://localhost/index.php")
    # machine.succeed("curl -fL http://localhost/")
    # Perform installation.
    machine.succeed('curl -fL -X POST http://localhost/install/check.php -F selectlang=auto')
    machine.succeed('curl -fL -X POST http://localhost/install/fileconf.php -F selectlang=auto')
    # First time is to write the configuration file correctly.
    machine.succeed('curl -fL -X POST http://localhost/install/step1.php -F "testpost=ok" -F "action=set" -F "selectlang=auto"')
    # Now, we have a proper conf.php in $stateDir.
    assert 'nixos' in machine.succeed("cat /var/lib/dolibarr/conf.php")
    machine.succeed('curl -fL -X POST http://localhost/install/step2.php --data "testpost=ok&action=set&dolibarr_main_db_character_set=utf8&dolibarr_main_db_collation=utf8_unicode_ci&selectlang=auto"')
    machine.succeed('curl -fL -X POST http://localhost/install/step4.php --data "testpost=ok&action=set&selectlang=auto"')
    machine.succeed('curl -fL -X POST http://localhost/install/step5.php --data "testpost=ok&action=set&login=root&pass=hunter2&pass_verif=hunter2&selectlang=auto"')
    # Now, we have installed the machine, let's verify we still have the right configuration.
    assert 'nixos' in machine.succeed("cat /var/lib/dolibarr/conf.php")
    # We do not want any redirect now as we have installed the machine.
    machine.succeed('curl -f -X GET http://localhost')
    # Test authentication to the webservice.
    parser = TokenParser()
    parser.feed(machine.succeed('curl -f -X GET http://localhost/index.php?mainmenu=login&username=root'))
    machine.succeed(f'curl -f -X POST http://localhost/index.php?mainmenu=login&token={csrf_token}&username=root&password=hunter2')
  '';
})

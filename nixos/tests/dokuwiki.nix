import ./make-test-python.nix ({ lib, ... }:

with lib;

{
  name = "dokuwiki";
  meta.maintainers = with maintainers; [ maintainers."1000101" ];

  nodes.machine =
    { pkgs, ... }:
    { services.dokuwiki = {
        enable = true;
        acl = " ";
        superUser = null;
        nginx = {
          forceSSL = false;
          enableACME = false;
        };
      }; 
    };

  testScript = ''
    machine.start()
    machine.wait_for_unit("phpfpm-dokuwiki.service")
    machine.wait_for_unit("nginx.service")
    machine.wait_for_open_port(80)
    machine.succeed("curl -sSfL http://localhost/ | grep 'DokuWiki'")
  '';
})

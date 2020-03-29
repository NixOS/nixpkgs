import ./make-test-python.nix ({ pkgs, ... }:

{
  name = "dokuwiki";
  meta.maintainers = with pkgs.lib.maintainers; [ "1000101" ];

  machine = { ... }: {
    services.dokuwiki."site1.local" = {
      acl = " ";
      superUser = null;
      nginx = {
        forceSSL = false;
        enableACME = false;
      };
    };
    services.dokuwiki."site2.local" = {
      acl = " ";
      superUser = null;
      nginx = {
        forceSSL = false;
        enableACME = false;
      };
    };
    networking.hosts."127.0.0.1" = [ "site1.local" "site2.local" ];
  };

  testScript = ''
    site_names = ["site1.local", "site2.local"]

    start_all()

    machine.wait_for_unit("phpfpm-dokuwiki-site1.local.service")
    machine.wait_for_unit("phpfpm-dokuwiki-site2.local.service")

    machine.wait_for_unit("nginx.service")

    machine.wait_for_open_port(80)

    machine.succeed("curl -sSfL http://site1.local/ | grep 'DokuWiki'")
    machine.succeed("curl -sSfL http://site2.local/ | grep 'DokuWiki'")
  '';
})

import ./make-test-python.nix (
  { pkgs, lib, ... }:
  {
    name = "mod_perl";

    meta = with pkgs.lib.maintainers; {
      maintainers = [ sgo ];
    };

    nodes.machine =
      {
        config,
        lib,
        pkgs,
        ...
      }:
      {
        services.httpd = {
          enable = true;
          adminAddr = "admin@localhost";
          virtualHosts."modperl" =
            let
              inc = pkgs.writeTextDir "ModPerlTest.pm" ''
                package ModPerlTest;
                use strict;
                use Apache2::RequestRec ();
                use Apache2::RequestIO ();
                use Apache2::Const -compile => qw(OK);
                sub handler {
                  my $r = shift;
                  $r->content_type('text/plain');
                  print "Hello mod_perl!\n";
                  return Apache2::Const::OK;
                }
                1;
              '';
              startup = pkgs.writeScript "startup.pl" ''
                use lib "${inc}",
                  split ":","${with pkgs.perl.pkgs; makeFullPerlPath ([ mod_perl2 ])}";
                1;
              '';
            in
            {
              extraConfig = ''
                PerlRequire ${startup}
              '';
              locations."/modperl" = {
                extraConfig = ''
                  SetHandler perl-script
                  PerlResponseHandler ModPerlTest
                '';
              };
            };
          enablePerl = true;
        };
      };
    testScript =
      { ... }:
      ''
        machine.wait_for_unit("httpd.service")
        response = machine.succeed("curl -fvvv -s http://127.0.0.1:80/modperl")
        assert "Hello mod_perl!" in response, "/modperl handler did not respond"
      '';
  }
)

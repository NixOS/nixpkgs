{ pkgs, ... }:
let
  testdir = pkgs.writeTextDir "www/app.psgi" ''
    my $app = sub {
        return [
            "200",
            [ "Content-Type" => "text/plain" ],
            [ "Hello, Perl on Unit!" ],
        ];
    };
  '';

in
{
  name = "unit-perl-test";
  meta.maintainers = with pkgs.lib.maintainers; [ sgo ];

  nodes.machine =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      services.unit = {
        enable = true;
        config = pkgs.lib.strings.toJSON {
          listeners."*:8080".application = "perl";
          applications.perl = {
            type = "perl";
            script = "${testdir}/www/app.psgi";
          };
        };
      };
    };
  testScript = ''
    machine.wait_for_unit("unit.service")
    machine.wait_for_open_port(8080)

    response = machine.succeed("curl -f -vvv -s http://127.0.0.1:8080/")
    assert "Hello, Perl on Unit!" in response, "Hello world"
  '';
}

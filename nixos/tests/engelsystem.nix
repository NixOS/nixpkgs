import ./make-test-python.nix (
  { pkgs, lib, ... }:
  {
    name = "engelsystem";
    meta = with pkgs.lib.maintainers; {
      maintainers = [ talyz ];
    };

    nodes.engelsystem =
      { ... }:
      {
        services.engelsystem = {
          enable = true;
          domain = "engelsystem";
          createDatabase = true;
        };
        networking.firewall.allowedTCPPorts = [
          80
          443
        ];
        environment.systemPackages = with pkgs; [
          xmlstarlet
          libxml2
        ];
      };

    testScript = ''
      engelsystem.start()
      engelsystem.wait_for_unit("phpfpm-engelsystem.service")
      engelsystem.wait_until_succeeds("curl engelsystem/login -sS -f")
      engelsystem.succeed(
          "curl engelsystem/login -sS -f -c cookie | xmllint -html -xmlout - >login"
      )
      engelsystem.succeed(
          "xml sel -T -t -m \"html/head/meta[@name='csrf-token']\" -v @content login >token"
      )
      engelsystem.succeed(
          "curl engelsystem/login -sS -f -b cookie -F 'login=admin' -F 'password=asdfasdf' -F '_token=<token' -L | xmllint -html -xmlout - >news"
      )
      engelsystem.succeed(
          "test 'News - Engelsystem' = \"$(xml sel -T -t -c html/head/title news)\""
      )
    '';
  }
)

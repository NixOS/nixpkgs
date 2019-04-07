import ./make-test.nix ({ pkgs, ...} : {
  name = "frab";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ manveru ];
  };

  nodes = {
    frab = { config, pkgs, ... }: {
      services.frab = {
        enable = true;
        host = "frab";
        listenAddress = "frab";
        secretKeyBase = "testing";
      };
    };
  };

  testScript = ''
    $frab->start;
    $frab->waitForUnit("frab.service");
    $frab->waitUntilSucceeds("curl -sSfL http://frab:3000/");
    $frab->succeed("curl -sSfL http://frab:3000/ | grep 'frab - home'");
  '';
})

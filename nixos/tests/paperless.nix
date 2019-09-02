import ./make-test.nix ({ lib, ... } : {
  name = "paperless";
  meta = with lib.maintainers; {
    maintainers = [ earvstedt ];
  };

  machine = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [ imagemagick jq ];
    services.paperless = {
      enable = true;
      ocrLanguages = [ "eng" ];
    };
  };

  testScript = ''
    $machine->waitForUnit("paperless-consumer.service");
    # Create test doc
    $machine->succeed('convert -size 400x40 xc:white -font "DejaVu-Sans" -pointsize 20 -fill black \
      -annotate +5+20 "hello world 16-10-2005" /var/lib/paperless/consume/doc.png');

    $machine->waitForUnit("paperless-server.service");
    # Wait until server accepts connections
    $machine->waitUntilSucceeds("curl -s localhost:28981");
    # Wait until document is consumed
    $machine->waitUntilSucceeds('(($(curl -s localhost:28981/api/documents/ | jq .count) == 1))');
    $machine->succeed("curl -s localhost:28981/api/documents/ | jq '.results | .[0] | .created'")
      =~ /2005-10-16/ or die;
  '';
})

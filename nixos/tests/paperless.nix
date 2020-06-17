import ./make-test-python.nix ({ lib, ... } : {
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
    machine.wait_for_unit("paperless-consumer.service")

    # Create test doc
    machine.succeed(
        "convert -size 400x40 xc:white -font 'DejaVu-Sans' -pointsize 20 -fill black -annotate +5+20 'hello world 16-10-2005' /var/lib/paperless/consume/doc.png"
    )

    with subtest("Service gets ready"):
        machine.wait_for_unit("paperless-server.service")
        # Wait until server accepts connections
        machine.wait_until_succeeds("curl -s localhost:28981")

    with subtest("Test document is consumed"):
        machine.wait_until_succeeds(
            "(($(curl -s localhost:28981/api/documents/ | jq .count) == 1))"
        )
        assert "2005-10-16" in machine.succeed(
            "curl -s localhost:28981/api/documents/ | jq '.results | .[0] | .created'"
        )
  '';
})

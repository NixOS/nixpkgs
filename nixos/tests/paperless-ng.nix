import ./make-test-python.nix ({ lib, ... }: {
  name = "paperless-ng";
  meta.maintainers = with lib.maintainers; [ earvstedt Flakebi ];

  nodes.machine = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [ imagemagick jq ];
    services.paperless-ng = {
      enable = true;
      passwordFile = builtins.toFile "password" "admin";
    };
    virtualisation.memorySize = 1024;
  };

  testScript = ''
    machine.wait_for_unit("paperless-ng-consumer.service")

    with subtest("Create test doc"):
        machine.succeed(
            "convert -size 400x40 xc:white -font 'DejaVu-Sans' -pointsize 20 -fill black "
            "-annotate +5+20 'hello world 16-10-2005' /var/lib/paperless/consume/doc.png"
        )

    with subtest("Web interface gets ready"):
        machine.wait_for_unit("paperless-ng-web.service")
        # Wait until server accepts connections
        machine.wait_until_succeeds("curl -fs localhost:28981")

    with subtest("Create web test doc"):
        machine.succeed(
            "convert -size 400x40 xc:white -font 'DejaVu-Sans' -pointsize 20 -fill black "
            "-annotate +5+20 'hello web 16-10-2005' /tmp/webdoc.png"
        )
        machine.wait_until_succeeds("curl -u admin:admin -F document=@/tmp/webdoc.png -fs localhost:28981/api/documents/post_document/")

    with subtest("Documents are consumed"):
        machine.wait_until_succeeds(
            "(($(curl -u admin:admin -fs localhost:28981/api/documents/ | jq .count) == 2))"
        )
        assert "2005-10-16" in machine.succeed(
            "curl -u admin:admin -fs localhost:28981/api/documents/ | jq '.results | .[0] | .created'"
        )
        assert "2005-10-16" in machine.succeed(
            "curl -u admin:admin -fs localhost:28981/api/documents/ | jq '.results | .[1] | .created'"
        )
  '';
})

import ./make-test-python.nix ({ lib, ... }: {
  name = "paperless";
  meta.maintainers = with lib.maintainers; [ erikarvstedt Flakebi ];

  nodes = let self = {
    simple = { pkgs, ... }: {
      environment.systemPackages = with pkgs; [ imagemagick jq ];
      services.paperless = {
        enable = true;
        passwordFile = builtins.toFile "password" "admin";
      };
    };
    postgres = { config, pkgs, ... }: {
      imports = [ self.simple ];
      services.postgresql = {
        enable = true;
        ensureDatabases = [ "paperless" ];
        ensureUsers = [
          { name = config.services.paperless.user;
            ensureDBOwnership = true;
          }
        ];
      };
      services.paperless.extraConfig = {
        PAPERLESS_DBHOST = "/run/postgresql";
      };
    };
  }; in self;

  testScript = ''
    import json

    def test_paperless(node):
      node.wait_for_unit("paperless-consumer.service")

      with subtest("Add a document via the file system"):
        node.succeed(
          "convert -size 400x40 xc:white -font 'DejaVu-Sans' -pointsize 20 -fill black "
          "-annotate +5+20 'hello world 16-10-2005' /var/lib/paperless/consume/doc.png"
        )

      with subtest("Web interface gets ready"):
        node.wait_for_unit("paperless-web.service")
        # Wait until server accepts connections
        node.wait_until_succeeds("curl -fs localhost:28981")

      # Required for consuming documents via the web interface
      with subtest("Task-queue gets ready"):
        node.wait_for_unit("paperless-task-queue.service")

      with subtest("Add a png document via the web interface"):
        node.succeed(
          "convert -size 400x40 xc:white -font 'DejaVu-Sans' -pointsize 20 -fill black "
          "-annotate +5+20 'hello web 16-10-2005' /tmp/webdoc.png"
        )
        node.wait_until_succeeds("curl -u admin:admin -F document=@/tmp/webdoc.png -fs localhost:28981/api/documents/post_document/")

      with subtest("Add a txt document via the web interface"):
        node.succeed(
          "echo 'hello web 16-10-2005' > /tmp/webdoc.txt"
        )
        node.wait_until_succeeds("curl -u admin:admin -F document=@/tmp/webdoc.txt -fs localhost:28981/api/documents/post_document/")

      with subtest("Documents are consumed"):
        node.wait_until_succeeds(
          "(($(curl -u admin:admin -fs localhost:28981/api/documents/ | jq .count) == 3))"
        )
        docs = json.loads(node.succeed("curl -u admin:admin -fs localhost:28981/api/documents/"))['results']
        assert "2005-10-16" in docs[0]['created']
        assert "2005-10-16" in docs[1]['created']
        assert "2005-10-16" in docs[2]['created']

      # Detects gunicorn issues, see PR #190888
      with subtest("Document metadata can be accessed"):
        metadata = json.loads(node.succeed("curl -u admin:admin -fs localhost:28981/api/documents/1/metadata/"))
        assert "original_checksum" in metadata

        metadata = json.loads(node.succeed("curl -u admin:admin -fs localhost:28981/api/documents/2/metadata/"))
        assert "original_checksum" in metadata

        metadata = json.loads(node.succeed("curl -u admin:admin -fs localhost:28981/api/documents/3/metadata/"))
        assert "original_checksum" in metadata

    test_paperless(simple)
    simple.send_monitor_command("quit")
    simple.wait_for_shutdown()
    test_paperless(postgres)
  '';
})

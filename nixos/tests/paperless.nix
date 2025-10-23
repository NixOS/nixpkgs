{ lib, ... }:
{
  name = "paperless";
  meta.maintainers = with lib.maintainers; [
    leona
    SuperSandro2000
    erikarvstedt
  ];

  nodes =
    let
      self = {
        simple =
          { pkgs, ... }:
          {
            environment.systemPackages = with pkgs; [
              imagemagick
              jq
            ];
            services = {
              nginx.virtualHosts."localhost".forceSSL = false;
              paperless = {
                enable = true;
                configureNginx = true;
                domain = "localhost";
                passwordFile = builtins.toFile "password" "admin";

                exporter = {
                  enable = true;

                  settings = {
                    "no-color" = lib.mkForce false; # override a default option
                    "no-thumbnail" = true; # add a new option
                  };
                };
              };
            };
          };
        postgres = {
          imports = [ self.simple ];
          services.paperless.database.createLocally = true;
          services.paperless.settings = {
            PAPERLESS_OCR_LANGUAGE = "deu";
          };
        };
      };
    in
    self;

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
        node.wait_until_succeeds("curl -fs localhost")

      # Required for consuming documents via the web interface
      with subtest("Task-queue gets ready"):
        node.wait_for_unit("paperless-task-queue.service")

      with subtest("Add a png document via the web interface"):
        node.succeed(
          "convert -size 400x40 xc:white -font 'DejaVu-Sans' -pointsize 20 -fill black "
          "-annotate +5+20 'hello web 16-10-2005' /tmp/webdoc.png"
        )
        node.wait_until_succeeds("curl -u admin:admin -F document=@/tmp/webdoc.png -fs localhost/api/documents/post_document/")

      with subtest("Add a txt document via the web interface"):
        node.succeed(
          "echo 'hello web 16-10-2005' > /tmp/webdoc.txt"
        )
        node.wait_until_succeeds("curl -u admin:admin -F document=@/tmp/webdoc.txt -fs localhost/api/documents/post_document/")

      with subtest("Documents are consumed"):
        node.wait_until_succeeds(
          "(($(curl -u admin:admin -fs localhost/api/documents/ | jq .count) == 3))"
        )
        docs = json.loads(node.succeed("curl -u admin:admin -fs localhost/api/documents/"))['results']
        assert "2005-10-16" in docs[0]['created']
        assert "2005-10-16" in docs[1]['created']
        assert "2005-10-16" in docs[2]['created']

      # Detects gunicorn issues, see PR #190888
      with subtest("Document metadata can be accessed"):
        metadata = json.loads(node.succeed("curl -u admin:admin -fs localhost/api/documents/1/metadata/"))
        assert "original_checksum" in metadata

        metadata = json.loads(node.succeed("curl -u admin:admin -fs localhost/api/documents/2/metadata/"))
        assert "original_checksum" in metadata

        metadata = json.loads(node.succeed("curl -u admin:admin -fs localhost/api/documents/3/metadata/"))
        assert "original_checksum" in metadata

      with subtest("Exporter"):
          node.succeed("systemctl start --wait paperless-exporter")
          node.wait_for_unit("paperless-web.service")
          node.wait_for_unit("paperless-consumer.service")
          node.wait_for_unit("paperless-scheduler.service")
          node.wait_for_unit("paperless-task-queue.service")

          node.succeed("ls -lah /var/lib/paperless/export/manifest.json")

          timers = node.succeed("systemctl list-timers paperless-exporter")
          print(timers)
          assert "paperless-exporter.timer paperless-exporter.service" in timers, "missing timer"
          assert "1 timers listed." in timers, "incorrect number of timers"

          # Double check that our attrset option override works as expected
          cmdline = node.succeed("grep 'paperless-manage' $(systemctl cat paperless-exporter | grep ExecStart | cut -f 2 -d=)")
          print(f"Exporter command line {cmdline!r}")
          assert cmdline.strip() == "paperless-manage document_exporter /var/lib/paperless/export --compare-checksums --delete --no-progress-bar --no-thumbnail", "Unexpected exporter command line"

    test_paperless(simple)
    simple.send_monitor_command("quit")
    simple.wait_for_shutdown()
    test_paperless(postgres)
  '';
}

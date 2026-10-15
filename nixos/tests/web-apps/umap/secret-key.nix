{ pkgs, ... }:
let
  suppliedKeyFile = "/run/umap-secret-key";
  suppliedKey = "supplied-secret-key";
  environmentFile = "/run/umap-environment";
  environmentKey = "environment-secret-key";
in
{
  name = "umap-secret-key";

  meta.maintainers = pkgs.umap.meta.maintainers;

  nodes = {
    generated =
      { ... }:
      {
        services.umap = {
          enable = true;
          settings.SITE_URL = "http://localhost";
        };
      };

    supplied =
      { ... }:
      {
        services.umap = {
          enable = true;
          secretKeyFile = suppliedKeyFile;
          settings.SITE_URL = "http://localhost";
        };

        # Readable by root only: the service receives it as a systemd credential.
        systemd.tmpfiles.rules = [ "f ${suppliedKeyFile} 0400 root root - ${suppliedKey}" ];
      };

    environment =
      { ... }:
      {
        services.umap = {
          inherit environmentFile;
          enable = true;
          settings.SITE_URL = "http://localhost";
        };

        systemd.tmpfiles.rules = [
          "f ${environmentFile} 0400 root root - SECRET_KEY=${environmentKey}"
        ];
      };
  };

  testScript =
    { nodes, ... }:
    let
      # Read-only options, so all nodes agree on them.
      inherit (nodes.generated.services.umap) stateDir unixSocket;
      generatedKeyFile = "${stateDir}/secretkey";
    in
    ''
      import re


      def live_key(machine):
          output = machine.succeed(
              "umap-manage shell -c \""
              "from django.conf import settings; "
              "print('KEY', settings.SECRET_KEY)\""
          )
          match = re.search(r"^KEY (.+)$", output, re.MULTILINE)
          assert match, f"could not read the live secret key from: {output}"
          return match.group(1)


      def assert_signature_is_accepted(machine):
          # The service only accepts a signature from umap-manage if both
          # resolved the same key; otherwise the redirect is replaced by a 403.
          output = machine.succeed(
              "umap-manage shell -c \""
              "from umap.models import Map; "
              "from django.contrib.gis.geos import Point; "
              "map_obj = Map.objects.create(name='SecretKeyTest', center=Point(0, 0), zoom=5); "
              "print('URL', map_obj.get_anonymous_edit_url())\""
          )
          match = re.search(r"^URL (\S+)$", output, re.MULTILINE)
          assert match, f"could not read the anonymous edit url from: {output}"
          edit_url = match.group(1)

          def status(url):
              # Not followed: the redirect target is the map itself, which is private.
              return machine.succeed(f"curl -s -o /dev/null -w %{{http_code}} {url}").strip()

          assert status(edit_url) == "302"
          assert status(edit_url + "x") == "403", "a bad signature was accepted"


      start_all()

      for machine in [generated, supplied, environment]:
          machine.wait_for_unit("umap.service")
          machine.wait_for_file("${unixSocket}")

      # Only this node checks a signature over HTTP, and the socket exists
      # before uvicorn serves, so nginx answers 502 for a moment after startup.
      generated.wait_until_succeeds("curl -sSf -o /dev/null http://localhost/")

      with subtest("A key is generated when none is supplied"):
          assert generated.succeed("stat -c %a ${generatedKeyFile}").strip() == "600"
          key = generated.succeed("cat ${generatedKeyFile}").strip()
          assert key, "no key was written"
          assert live_key(generated) == key
          assert_signature_is_accepted(generated)

      with subtest("The generation is not repeated once a key exists"):
          # Rotating the key on every start would invalidate all sessions and
          # anonymous edit links.
          generated.systemctl("restart umap-secretkey.service")
          assert generated.succeed("cat ${generatedKeyFile}").strip() == key

      with subtest("A supplied key is read without the service user reading the file"):
          supplied.fail("runuser -u umap -- cat ${suppliedKeyFile}")
          supplied.fail("test -e ${generatedKeyFile}")
          assert live_key(supplied) == "${suppliedKey}"

      with subtest("A key from the environment file wins over the generated one"):
          # The generated key is still written: systemd resolves the credential
          # before the service runs, whatever the environment file holds.
          assert environment.succeed("cat ${generatedKeyFile}").strip()
          assert live_key(environment) == "${environmentKey}"
    '';
}

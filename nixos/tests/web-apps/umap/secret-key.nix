{ pkgs, ... }:
let
  environmentFile = "/run/umap-secret";
  extraConfigSecret = "/run/umap-extra-secret";
  secretKeyFile = "/var/lib/umap/secretkey";
in
{
  name = "umap-secret-key";

  meta.maintainers = pkgs.umap.meta.maintainers;

  nodes.machine =
    { ... }:
    {
      services.umap = {
        enable = true;
        nginx.resolver = "127.0.0.1";
        environmentFile = environmentFile;
        # Guarded so that the test can add and remove the key at runtime.
        extraConfig = ''
          import os

          if os.path.exists("${extraConfigSecret}"):
              with open("${extraConfigSecret}") as _f:
                  SECRET_KEY = _f.read().strip()
        '';
        settings.SITE_URL = "http://localhost";
      };

      # EnvironmentFile is passed without systemd's "-" prefix, so it has to
      # exist before the service starts.
      systemd.tmpfiles.rules = [ "f ${environmentFile} 0600 root root" ];
    };

  testScript = ''
    import re


    def restart():
        machine.systemctl("restart umap.service")
        machine.wait_for_unit("umap.service")
        machine.wait_for_file("/run/umap/umap.sock")


    def live_key():
        output = machine.succeed(
            "umap-manage shell -c \""
            "from django.conf import settings; "
            "print('KEY', settings.SECRET_KEY)\""
        )
        match = re.search(r"^KEY (.+)$", output, re.MULTILINE)
        assert match, f"could not read the live secret key from: {output}"
        return match.group(1)


    def stored_key():
        return machine.succeed(". ${secretKeyFile}; printf %s \"$SECRET_KEY\"")


    def edit_url_status(url):
        # Not followed: the redirect target is the map itself, which is private.
        return machine.succeed(f"curl -s -o /dev/null -w %{{http_code}} {url}").strip()


    def anonymous_edit_url():
        output = machine.succeed("""
          umap-manage shell -c "\
    from umap.models import Map
    from django.contrib.gis.geos import Point

    map_obj = Map.objects.create(name='SecretKeyTest', center=Point(0, 0), zoom=5)
    print('URL', map_obj.get_anonymous_edit_url())
          "
        """)
        match = re.search(r"^URL (\S+)$", output, re.MULTILINE)
        assert match, f"could not read the anonymous edit url from: {output}"
        return match.group(1)


    machine.wait_for_unit("umap.service")
    machine.wait_for_unit("nginx.service")
    machine.wait_for_open_port(80)
    machine.wait_for_file("/run/umap/umap.sock")

    with subtest("A key is generated when no other source provides one"):
        assert machine.succeed("stat -c %a ${secretKeyFile}").strip() == "600"
        generated = stored_key()
        assert generated, "no key was written"
        assert live_key() == generated

    with subtest("The running service signs with the generated key"):
        # The signature is only accepted if the service resolved the same key as
        # umap-manage did; otherwise the redirect is replaced by a 403.
        edit_url = anonymous_edit_url()
        assert edit_url_status(edit_url) == "302"

    with subtest("The generated key survives a restart"):
        restart()
        assert stored_key() == generated
        assert edit_url_status(edit_url) == "302"

    with subtest("A truncated key file is regenerated"):
        machine.succeed(": > ${secretKeyFile}")
        restart()
        rotated = stored_key()
        assert rotated, "the truncated key file was not replaced"
        assert rotated != generated
        # The anonymous edit URL was signed with the key that is now gone.
        assert edit_url_status(edit_url) == "403"

    with subtest("environmentFile overrides the generated key"):
        # systemd keeps the value literal, a shell sourcing the file would
        # expand $b.
        machine.succeed("echo 'SECRET_KEY=a$b' > ${environmentFile}")
        restart()
        assert live_key() == "a$b"
        assert stored_key() == rotated, "the generated key should be kept, only shadowed"

    with subtest("extraConfig overrides a key from the environment"):
        machine.succeed("echo from-extra-config > ${extraConfigSecret}")
        restart()
        assert live_key() == "from-extra-config"

    with subtest("A key from extraConfig alone suppresses generation"):
        # The environment has to be emptied as well: a key there would already
        # short-circuit the generation, leaving the settings unread.
        machine.succeed(": > ${environmentFile}")
        machine.succeed("rm ${secretKeyFile}")
        restart()
        assert live_key() == "from-extra-config"
        machine.fail("test -e ${secretKeyFile}")
  '';
}

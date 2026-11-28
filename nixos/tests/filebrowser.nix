{ lib, ... }:
let
  node =
    root:
    { pkgs, ... }:
    {
      environment.systemPackages = [ pkgs.filebrowser ];

      services.filebrowser = {
        enable = true;
        settings = {
          address = "localhost";
          port = 8080;
          database = "/var/lib/filebrowser/filebrowser.db";
        }
        // lib.optionalAttrs (root != null) { inherit root; };
      };
    };
in
{
  name = "filebrowser";

  nodes = {
    machine = node null;
    # A root under /home, behind ProtectHome = "tmpfs".
    home = node "/home/shared/files";
  };

  testScript = ''
    def upload_and_read_back(machine, root):
      machine.wait_for_unit("filebrowser.service")
      machine.wait_for_open_port(8080)
      machine.succeed("curl --fail http://localhost:8080/")
      machine.succeed("stat /var/lib/filebrowser/filebrowser.db")

      machine.systemctl("stop filebrowser.service")
      machine.succeed("runuser -u filebrowser -- filebrowser -d /var/lib/filebrowser/filebrowser.db users add tester testpassword1234 --perm.admin")
      machine.systemctl("start filebrowser.service")
      machine.wait_for_open_port(8080)

      token = machine.succeed("""curl --fail --json '{"username": "tester", "password": "testpassword1234"}' http://localhost:8080/api/login""").strip()
      auth = f"--header 'X-Auth: {token}'"
      machine.succeed(f"curl --fail {auth} --data-binary 'hello' -X POST 'http://localhost:8080/api/resources/upload.txt?override=true'")
      assert machine.succeed(f"curl --fail {auth} http://localhost:8080/api/raw/upload.txt") == "hello"
      machine.succeed(f"grep -qx hello {root}/upload.txt")

    start_all()

    with subtest("FileBrowser serves its default root"):
      upload_and_read_back(machine, "/var/lib/filebrowser/data")

    with subtest("FileBrowser serves a root under /home"):
      upload_and_read_back(home, "/home/shared/files")

    with subtest("Other home directories stay hidden"):
      home.succeed("install -d -m 0755 /home/alice && echo secret > /home/alice/secret.txt")
      home.systemctl("restart filebrowser.service")
      home.wait_for_open_port(8080)
      pid = home.succeed("systemctl show --property MainPID --value filebrowser.service").strip()
      assert home.succeed(f"nsenter --target {pid} --mount ls -A /home").split() == ["shared"]
  '';
}

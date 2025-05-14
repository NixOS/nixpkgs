import ./make-test-python.nix (
  { pkgs, ... }:
  {
    name = "uwsgi";
    meta = with pkgs.lib.maintainers; {
      maintainers = [ lnl7 ];
    };

    nodes.machine =
      { pkgs, ... }:
      {
        users.users.hello = {
          isSystemUser = true;
          group = "hello";
        };
        users.groups.hello = { };

        services.uwsgi = {
          enable = true;
          plugins = [
            "python3"
            "php"
          ];
          capabilities = [ "CAP_NET_BIND_SERVICE" ];
          instance.type = "emperor";

          instance.vassals.hello = {
            type = "normal";
            immediate-uid = "hello";
            immediate-gid = "hello";
            module = "wsgi:application";
            http = ":80";
            cap = "net_bind_service";
            pythonPackages = self: [ self.flask ];
            chdir = pkgs.writeTextDir "wsgi.py" ''
              from flask import Flask
              import subprocess
              application = Flask(__name__)

              @application.route("/")
              def hello():
                  return "Hello, World!"

              @application.route("/whoami")
              def whoami():
                  whoami = "${pkgs.coreutils}/bin/whoami"
                  proc = subprocess.run(whoami, capture_output=True)
                  return proc.stdout.decode().strip()
            '';
          };

          instance.vassals.php = {
            type = "normal";
            master = true;
            workers = 2;
            http-socket = ":8000";
            http-socket-modifier1 = 14;
            php-index = "index.php";
            php-docroot = pkgs.writeTextDir "index.php" ''
              <?php echo "Hello World\n"; ?>
            '';
          };
        };
      };

    testScript = ''
      machine.wait_for_unit("multi-user.target")
      machine.wait_for_unit("uwsgi.service")

      with subtest("uWSGI has started"):
          machine.wait_for_unit("uwsgi.service")

      with subtest("Vassal can bind on port <1024"):
          machine.wait_for_open_port(80)
          hello = machine.succeed("curl -f http://machine").strip()
          assert "Hello, World!" in hello, f"Excepted 'Hello, World!', got '{hello}'"

      with subtest("Vassal is running as dedicated user"):
          username = machine.succeed("curl -f http://machine/whoami").strip()
          assert username == "hello", f"Excepted 'hello', got '{username}'"

      with subtest("PHP plugin is working"):
          machine.wait_for_open_port(8000)
          assert "Hello World" in machine.succeed("curl -fv http://machine:8000")
    '';
  }
)

import ./make-test-python.nix ({ pkgs, ... }:
{
  name = "uwsgi";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ lnl7 ];
  };

  machine = { pkgs, ... }: {
    services.uwsgi.enable = true;
    services.uwsgi.plugins = [ "python3" "php" ];
    services.uwsgi.instance = {
      type = "emperor";
      vassals.python = {
        type = "normal";
        master = true;
        workers = 2;
        http = ":8000";
        module = "wsgi:application";
        chdir = pkgs.writeTextDir "wsgi.py" ''
          from flask import Flask
          application = Flask(__name__)

          @application.route("/")
          def hello():
              return "Hello World!"
        '';
        pythonPackages = self: with self; [ flask ];
      };
      vassals.php = {
        type = "normal";
        master = true;
        workers = 2;
        http-socket = ":8001";
        http-socket-modifier1 = 14;
        php-index = "index.php";
        php-docroot = pkgs.writeTextDir "index.php" ''
          <?php echo "Hello World\n"; ?>
        '';
      };
    };
  };

  testScript =
    ''
      machine.wait_for_unit("multi-user.target")
      machine.wait_for_unit("uwsgi.service")
      machine.wait_for_open_port(8000)
      machine.wait_for_open_port(8001)
      assert "Hello World" in machine.succeed("curl -fv 127.0.0.1:8000")
      assert "Hello World" in machine.succeed("curl -fv 127.0.0.1:8001")
    '';
})

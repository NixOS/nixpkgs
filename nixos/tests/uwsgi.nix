import ./make-test-python.nix ({ pkgs, ... }:
{
  name = "uwsgi";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ lnl7 ];
  };
  machine = { pkgs, ... }: {
    services.uwsgi.enable = true;
    services.uwsgi.plugins = [ "python3" ];
    services.uwsgi.instance = {
      type = "emperor";
      vassals.hello = {
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
    };
  };

  testScript =
    ''
      machine.wait_for_unit("multi-user.target")
      machine.wait_for_unit("uwsgi.service")
      machine.wait_for_open_port(8000)
      assert "Hello World" in machine.succeed("curl -v 127.0.0.1:8000")
    '';
})

{ lib, pkgs, ... }:

let
  writeSimplePythonApp =
    pname: text:
    pkgs.python3.pkgs.buildPythonApplication {
      inherit pname;
      version = "0.0";
      pyproject = false;
      src = pkgs.writeText "${pname}.py" text;
      unpackPhase = "true";
      installPhase = ''
        OUTDIR=$out/${pkgs.python3.sitePackages}
        mkdir -p $OUTDIR
        cp $src $OUTDIR/${pname}.py
      '';
    };

  dummyApp = {
    python = pkgs.python3;
    module = "dummy-wsgi:app";
    package =
      writeSimplePythonApp "dummy-wsgi" # python
        ''
          def app(environ, start_response):
              data = b'Up and running!\n'
              status = '200 OK'
              response_headers = [
                  ('Content-type', 'text/plain'),
                  ('Content-Length', str(len(data)))
              ]
              start_response(status, response_headers)
              return iter([data])
        '';
  };

in
{
  name = "gunicorn";

  meta = {
    maintainers = with lib.maintainers; [ euxane ];
  };

  nodes.machine =
    { config, ... }:
    {
      services.gunicorn.instances."standalone" = {
        app = dummyApp;
        socket = {
          type = "tcp";
          address = "127.0.0.1:8080";
        };
      };

      services.gunicorn.instances."unix-socket" = {
        app = dummyApp;
        socket = {
          inherit (config.services.nginx) user group;
        };
      };

      services.nginx = {
        enable = true;
        recommendedProxySettings = true;
        virtualHosts."localhost".locations."/" = {
          proxyPass = "http://unix:${config.services.gunicorn.instances."unix-socket".socket.address}";
        };
      };
    };

  testScript = ''
    machine.start()
    machine.wait_for_unit("multi-user.target")

    machine.wait_for_unit("gunicorn-standalone.service")
    machine.wait_for_open_port(8080)
    machine.succeed("curl -sSf localhost:8080 | grep -q 'Up and running!'")

    machine.wait_for_unit("nginx.service")
    machine.wait_for_open_port(80)
    machine.succeed("curl -sSf localhost | grep -q 'Up and running!'")

    machine.shutdown()
  '';
}

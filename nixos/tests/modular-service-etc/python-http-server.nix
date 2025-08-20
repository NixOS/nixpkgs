# Tests in: ./test.nix
# This module provides a basic web server based on the python built-in http.server package.
{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkOption types;
in
{
  _class = "service";

  options = {
    python-http-server = {
      package = mkOption {
        type = types.package;
        default = pkgs.python3;
        description = "Python package to use for the web server";
      };

      port = mkOption {
        type = types.port;
        default = 8000;
        description = "Port to listen on";
      };

      directory = mkOption {
        type = types.str;
        default = config.configData."webroot".path;
        defaultText = lib.literalExpression ''config.configData."webroot".path'';
        description = "Directory to serve files from";
      };
    };
  };

  config = {
    process.argv = [
      "${lib.getExe config.python-http-server.package}"
      "-m"
      "http.server"
      "${toString config.python-http-server.port}"
      "--directory"
      config.python-http-server.directory
    ];

    configData = {
      # This should probably just be {} if we were to put this module in production.
      "webroot" = lib.mkDefault {
        source = pkgs.runCommand "default-webroot" { } ''
          mkdir -p $out
          cat > $out/index.html << 'EOF'
          <!DOCTYPE html>
          <html>
          <head><title>Python Web Server</title></head>
          <body>
            <h1>Welcome to the Python Web Server</h1>
            <p>Serving from port ${toString config.python-http-server.port}</p>
          </body>
          </html>
          EOF
        '';
      };
    };
  };
}

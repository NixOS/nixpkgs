# Tests in: ./test.nix
# This module provides a basic web server based on the python built-in http.server package.
{
  config,
  lib,
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
      "webroot" = {
        # Enable only if directory is set to use this path
        enable = lib.mkDefault (config.python-http-server.directory == config.configData."webroot".path);
      };
    };
  };
}

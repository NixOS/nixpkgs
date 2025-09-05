{
  config,
  lib,
  ...
}:

{
  options = {
    app.package = lib.mkOption {
      type = lib.types.package;
      description = "Package of the WSGI Python application.";
    };

    app.python = lib.mkOption {
      type = lib.types.package;
      default = config.app.package.python;
      defaultText = lib.literalExpression "config.services.gunicorn.instances.<name>.app.package.python";
      description = ''
        Python interpreter package to use.
        Defaults to the one exposed by the WSGI application package
        through its `passthru.python` attribute, if it is defined.
      '';
    };

    app.module = lib.mkOption {
      type = lib.types.str;
      default = config.app.package.wsgiModule;
      defaultText = lib.literalExpression "config.services.gunicorn.instances.<name>.app.package.wsgiModule";
      description = ''
        Module entry-point of the WSGI app.
        Defaults to the one exposed by the WSGI application package
        through its `passthru.wsgiModule` attribute, if it is defined.
      '';
    };

    process.extraArgs = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = { };
      description = "Extra command line arguments to pass to gunicorn.";
    };

    process.unit = lib.mkOption {
      type = lib.types.str;
      default = "gunicorn-${config._module.args.name}";
      defaultText = lib.literalExpression ''gunicorn-''${config.services.gunicorn.instances.<name>.name}'';
      description = "Name for the systemd unit of this instance.";
    };

    process.user = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = ''
        User as which this instance of gunicorn will be run.

        It will be dynamically allocated if unspecified or if the name does not match a static user.
      '';
    };

    process.group = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = ''
        Group as which this instance of gunicorn will be run.

        It will be dynamically allocated if unspecified or if the name does not match a static group.
      '';
    };

    socket.type = lib.mkOption {
      type = lib.types.enum [
        "unix"
        "tcp"
      ];
      default = "unix";
      description = "Socket type: 'unix' or 'tcp'.";
    };

    socket.address = lib.mkOption {
      type = lib.types.str;
      default = "/run/${config.process.unit}.sock";
      defaultText = lib.literalExpression ''
        /run/''${config.services.gunicorn.instances.<name>.process.unit}.sock
      '';
      example = "1.2.3.4:5678";
      description = ''
        Socket address.
        In case of a UNIX socket, this should be its filesystem path.
      '';
    };

    socket.user = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = ''
        User to be set as owner of the UNIX socket.
      '';
    };

    socket.group = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = ''
        Group to be set as owner of the UNIX socket.
      '';
    };

    socket.mode = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = if config.socket.type == "unix" then "0600" else null;
      defaultText = lib.literalExpression ''
        if config.services.gunicorn.instances.<name>.socket.type == "unix" then "0600" else null
      '';
      description = ''
        Mode to be set on the UNIX socket.
        Defaults to private to the socket's owner.
      '';
    };
  };
}

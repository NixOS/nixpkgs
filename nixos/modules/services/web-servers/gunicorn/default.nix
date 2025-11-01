{
  config,
  lib,
  pkgs,
  ...
}:

let
  instanceOptions = import ./instance-options.nix;
  cfg = config.services.gunicorn;

  mapToUnits = f: lib.mapAttrs' (_: inst: lib.nameValuePair inst.process.unit (f inst));

  gunicornArgs =
    inst:
    lib.cli.toGNUCommandLineShell { } (
      {
        bind = if inst.socket.type == "unix" then "unix:${inst.socket.address}" else inst.socket.address;
      }
      // inst.process.extraArgs
    );

  mkPythonEnv =
    app:
    app.python.buildEnv.override {
      extraLibs = with app.python.pkgs; [
        (toPythonModule app.package)
        gunicorn
      ];
    };

in
{
  options.services.gunicorn.instances = lib.mkOption {
    type = lib.types.attrsOf (lib.types.submodule instanceOptions);
    default = { };
    description = ''
      Configuration for instances of gunicorn.
      Each instance is isolated in its own systemd service.
      Corresponding sockets are exposed and managed by systemd.
    '';
  };

  config = {
    assertions = lib.concatLists (
      lib.mapAttrsToList (name: inst: [
        {
          assertion = inst.socket.type == "unix" -> inst.socket.user != null;
          message = "Socket owner is required for the UNIX socket type.";
        }
        {
          assertion = inst.socket.type == "unix" -> inst.socket.group != null;
          message = "Socket owner is required for the UNIX socket type.";
        }
        {
          assertion = inst.socket.user != null -> inst.socket.type == "unix";
          message = "Socket owner can only be set for the UNIX socket type.";
        }
        {
          assertion = inst.socket.group != null -> inst.socket.type == "unix";
          message = "Socket owner can only be set for the UNIX socket type.";
        }
        {
          assertion = inst.socket.mode != null -> inst.socket.type == "unix";
          message = "Socket mode can only be set for the UNIX socket type.";
        }
      ]) cfg.instances
    );

    systemd.services = mapToUnits (inst: {
      after = [ "network.target" ];
      wantedBy = lib.optional (inst.socket.type != "unix") "multi-user.target";

      # from https://docs.gunicorn.org/en/latest/deploy.html#systemd
      serviceConfig = {
        User = inst.process.user;
        Group = inst.process.group;
        DynamicUser = true;

        Type = "notify";
        NotifyAccess = "main";
        KillMode = "mixed";
        TimeoutStopSec = 5;
        PrivateTmp = true;

        ExecReload = ''
          ${lib.getExe' pkgs.coreutils "kill"} -s HUP $MAINPID
        '';

        ExecStart = ''
          ${lib.getExe' (mkPythonEnv inst.app) "gunicorn"} \
            ${gunicornArgs inst} \
            ${lib.escapeShellArg inst.app.module}
        '';
      };
    }) cfg.instances;

    systemd.sockets = mapToUnits (
      inst:
      lib.mkIf (inst.socket.type == "unix") {
        wantedBy = [ "sockets.target" ];
        socketConfig = {
          ListenStream = inst.socket.address;
          SocketUser = inst.socket.user;
          SocketGroup = inst.socket.group;
          SocketMode = inst.socket.mode;
        };
      }
    ) cfg.instances;
  };

  meta = {
    maintainers = with lib.maintainers; [ euxane ];
  };
}

{config, lib, pkgs, ... }:

let
  cfg = config.services.hastygram;

  pythonEnv = pkgs.python3.withPackages (ps: with ps; [
    # FastAPI-recommended Gunicorn worker.
    uvicorn
    # UWSGI web server.
    gunicorn
    # The wastygram web app itself.
    hastygram
  ]);

  configFlag = lib.optionalString (cfg.extraConfig != null)
    (let file = pkgs.writeText "hastygram.py" cfg.extraConfig; in "--config ${file}");

in {

  options.services.hastygram = {
    enable = lib.mkEnableOption "lightweight Instagram frontend";

    extraConfig = lib.mkOption {
      type = lib.types.nullOr lib.types.lines;
      description = "Optional Gunicorn configuration file to use";
      default = ''
        bind = "unix:/run/hastygram/hastygram.sock"
        workers = 4
      '';
      example = ''
        bind = "127.0.0.1:8000"
        workers = 2
      '';
    };
  };

  config = lib.mkIf cfg.enable {

    systemd.services.hastygram = {
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      description = "Lighweight Instagram frontend";
      serviceConfig = {
        ExecStart = "${pythonEnv}/bin/gunicorn -k uvicorn.workers.UvicornWorker ${configFlag} hastygram.app:app";
        ExecReload = "${pkgs.coreutils}/bin/kill -s HUP $MAINPID";
        Restart = "on-failure";
        RuntimeDirectory = "hastygram";
        RuntimeDirectoryMode = "0755";
        DynamicUser = true;
      };
    };

  };

}

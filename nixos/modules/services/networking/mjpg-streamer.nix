{
  config,
  lib,
  pkgs,
  ...
}:

let

  cfg = config.services.mjpg-streamer;

in
{

  options = {

    services.mjpg-streamer = {

      enable = lib.mkEnableOption "mjpg-streamer webcam streamer";

      inputPlugin = lib.mkOption {
        type = lib.types.str;
        default = "input_uvc.so";
        description = ''
          Input plugin. See plugins documentation for more information.
        '';
      };

      outputPlugin = lib.mkOption {
        type = lib.types.str;
        default = "output_http.so -w @www@ -n -p 5050";
        description = ''
          Output plugin. `@www@` is substituted for default mjpg-streamer www directory.
          See plugins documentation for more information.
        '';
      };

      user = lib.mkOption {
        type = lib.types.str;
        default = "mjpg-streamer";
        description = "mjpg-streamer user name.";
      };

      group = lib.mkOption {
        type = lib.types.str;
        default = "video";
        description = "mjpg-streamer group name.";
      };

    };

  };

  config = lib.mkIf cfg.enable {

    users.users = lib.optionalAttrs (cfg.user == "mjpg-streamer") {
      mjpg-streamer = {
        uid = config.ids.uids.mjpg-streamer;
        group = cfg.group;
      };
    };

    systemd.services.mjpg-streamer = {
      description = "mjpg-streamer webcam streamer";
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        User = cfg.user;
        Group = cfg.group;
        Restart = "on-failure";
        RestartSec = 1;
      };

      script = ''
        IPLUGIN="${cfg.inputPlugin}"
        OPLUGIN="${cfg.outputPlugin}"
        OPLUGIN="''${OPLUGIN//@www@/${pkgs.mjpg-streamer}/share/mjpg-streamer/www}"
        exec ${pkgs.mjpg-streamer}/bin/mjpg_streamer -i "$IPLUGIN" -o "$OPLUGIN"
      '';
    };

  };

}

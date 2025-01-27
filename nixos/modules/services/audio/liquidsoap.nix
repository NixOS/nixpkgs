{
  config,
  lib,
  pkgs,
  ...
}:
let
  streams = builtins.attrNames config.services.liquidsoap.streams;

  streamService =
    name:
    let
      stream = builtins.getAttr name config.services.liquidsoap.streams;
    in
    {
      inherit name;
      value = {
        after = [
          "network-online.target"
          "sound.target"
        ];
        description = "${name} liquidsoap stream";
        wantedBy = [ "multi-user.target" ];
        path = [ pkgs.wget ];
        serviceConfig = {
          ExecStart = "${pkgs.liquidsoap}/bin/liquidsoap ${stream}";
          User = "liquidsoap";
          LogsDirectory = "liquidsoap";
          Restart = "always";
        };
      };
    };
in
{

  ##### interface

  options = {

    services.liquidsoap.streams = lib.mkOption {

      description = ''
        Set of Liquidsoap streams to start,
        one systemd service per stream.
      '';

      default = { };

      example = lib.literalExpression ''
        {
          myStream1 = "/etc/liquidsoap/myStream1.liq";
          myStream2 = ./myStream2.liq;
          myStream3 = "out(playlist(\"/srv/music/\"))";
        }
      '';

      type = lib.types.attrsOf (lib.types.either lib.types.path lib.types.str);
    };

  };
  ##### implementation

  config = lib.mkIf (builtins.length streams != 0) {

    users.users.liquidsoap = {
      uid = config.ids.uids.liquidsoap;
      group = "liquidsoap";
      extraGroups = [ "audio" ];
      description = "Liquidsoap streaming user";
      home = "/var/lib/liquidsoap";
      createHome = true;
    };

    users.groups.liquidsoap.gid = config.ids.gids.liquidsoap;

    systemd.services = builtins.listToAttrs (map streamService streams);
  };

}

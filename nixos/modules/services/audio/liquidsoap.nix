{ config, lib, pkgs, ... }:

with lib;

let
  streams = builtins.attrNames config.services.liquidsoap.streams;

  streamService =
    name:
    let stream = builtins.getAttr name config.services.liquidsoap.streams; in
    { inherit name;
      value = {
        after = [ "network-online.target" "sound.target" ];
        description = "${name} liquidsoap stream";
        wantedBy = [ "multi-user.target" ];
        path = [ pkgs.wget ];
        serviceConfig = {
          ExecStart = "${pkgs.liquidsoap}/bin/liquidsoap ${stream}";
          User = "liquidsoap";
          LogsDirectory = "liquidsoap";
        };
      };
    };
in
{

  ##### interface

  options = {

    services.liquidsoap.streams = mkOption {

      description =
        ''
          Set of Liquidsoap streams to start,
          one systemd service per stream.
        '';

      default = {};

      example = {
        myStream1 = literalExample "\"/etc/liquidsoap/myStream1.liq\"";
        myStream2 = literalExample "./myStream2.liq";
        myStream3 = literalExample "\"out(playlist(\\\"/srv/music/\\\"))\"";
      };

      type = types.attrsOf (types.either types.path types.str);
    };

  };
  ##### implementation

  config = mkIf (builtins.length streams != 0) {

    users.users.liquidsoap = {
      uid = config.ids.uids.liquidsoap;
      group = "liquidsoap";
      extraGroups = [ "audio" ];
      description = "Liquidsoap streaming user";
      home = "/var/lib/liquidsoap";
      createHome = true;
    };

    users.groups.liquidsoap.gid = config.ids.gids.liquidsoap;

    systemd.services = builtins.listToAttrs ( map streamService streams );
  };

}

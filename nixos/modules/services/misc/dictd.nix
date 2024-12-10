{ config, lib, pkgs, ... }:
let
  cfg = config.services.dictd;
in

{

  ###### interface

  options = {

    services.dictd = {

      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Whether to enable the DICT.org dictionary server.
        '';
      };

      DBs = lib.mkOption {
        type = lib.types.listOf lib.types.package;
        default = with pkgs.dictdDBs; [ wiktionary wordnet ];
        defaultText = lib.literalExpression "with pkgs.dictdDBs; [ wiktionary wordnet ]";
        example = lib.literalExpression "[ pkgs.dictdDBs.nld2eng ]";
        description = "List of databases to make available.";
      };

    };

  };


  ###### implementation

  config = let dictdb = pkgs.dictDBCollector { dictlist = map (x: {
               name = x.name;
               filename = x; } ) cfg.DBs; };
  in lib.mkIf cfg.enable {

    # get the command line client on system path to make some use of the service
    environment.systemPackages = [ pkgs.dict ];

    environment.etc."dict.conf".text = ''
      server localhost
    '';

    users.users.dictd =
      { group = "dictd";
        description = "DICT.org dictd server";
        home = "${dictdb}/share/dictd";
        uid = config.ids.uids.dictd;
      };

    users.groups.dictd.gid = config.ids.gids.dictd;

    systemd.services.dictd = {
      description = "DICT.org Dictionary Server";
      wantedBy = [ "multi-user.target" ];
      environment = { LOCALE_ARCHIVE = "/run/current-system/sw/lib/locale/locale-archive"; };
      # Work around the fact that dictd doesn't handle SIGTERM; it terminates
      # with code 143 instead of exiting with code 0.
      serviceConfig.SuccessExitStatus = [ 143 ];
      serviceConfig.Type = "forking";
      script = "${pkgs.dict}/sbin/dictd -s -c ${dictdb}/share/dictd/dictd.conf --locale en_US.UTF-8";
    };
  };
}

{ config, lib, pkgs, ... }:

with lib;
let
  nncpCfgFile = "/run/nncp.hjson";
  programCfg = config.programs.nncp;
  settingsFormat = pkgs.formats.json { };
  jsonCfgFile = settingsFormat.generate "nncp.json" programCfg.settings;
  pkg = programCfg.package;
in {
  options.programs.nncp = {

    enable =
      mkEnableOption "NNCP (Node to Node copy) utilities and configuration";

    group = mkOption {
      type = types.str;
      default = "uucp";
      description = lib.mdDoc ''
        The group under which NNCP files shall be owned.
        Any member of this group may access the secret keys
        of this NNCP node.
      '';
    };

    package = mkOption {
      type = types.package;
      default = pkgs.nncp;
      defaultText = literalExpression "pkgs.nncp";
      description = lib.mdDoc "The NNCP package to use system-wide.";
    };

    secrets = mkOption {
      type = with types; listOf str;
      example = [ "/run/keys/nncp.hjson" ];
      description = lib.mdDoc ''
        A list of paths to NNCP configuration files that should not be
        in the Nix store. These files are layered on top of the values at
        [](#opt-programs.nncp.settings).
      '';
    };

    settings = mkOption {
      type = settingsFormat.type;
      description = lib.mdDoc ''
        NNCP configuration, see
        <http://www.nncpgo.org/Configuration.html>.
        At runtime these settings will be overlayed by the contents of
        [](#opt-programs.nncp.secrets) into the file
        `${nncpCfgFile}`. Node keypairs go in
        `secrets`, do not specify them in
        `settings` as they will be leaked into
        `/nix/store`!
      '';
      default = { };
    };

  };

  config = mkIf programCfg.enable {

    environment = {
      systemPackages = [ pkg ];
      etc."nncp.hjson".source = nncpCfgFile;
    };

    programs.nncp.settings = {
      spool = mkDefault "/var/spool/nncp";
      log = mkDefault "/var/spool/nncp/log";
    };

    systemd.tmpfiles.rules = [
      "d ${programCfg.settings.spool} 0770 root ${programCfg.group}"
      "f ${programCfg.settings.log} 0770 root ${programCfg.group}"
    ];

    systemd.services.nncp-config = {
      path = [ pkg ];
      description = "Generate NNCP configuration";
      wantedBy = [ "basic.target" ];
      serviceConfig.Type = "oneshot";
      script = ''
        umask u=rw
        nncpCfgDir=$(mktemp --directory nncp.XXX)
        for f in ${jsonCfgFile} ${toString config.programs.nncp.secrets}; do
          tmpdir=$(mktemp --directory nncp.XXX)
          nncp-cfgdir -cfg $f -dump $tmpdir
          find $tmpdir -size 1c -delete
          cp -a $tmpdir/* $nncpCfgDir/
          rm -rf $tmpdir
        done
        nncp-cfgdir -load $nncpCfgDir > ${nncpCfgFile}
        rm -rf $nncpCfgDir
        chgrp ${programCfg.group} ${nncpCfgFile}
        chmod g+r ${nncpCfgFile}
      '';
    };
  };

  meta.maintainers = with lib.maintainers; [ ehmry ];
}

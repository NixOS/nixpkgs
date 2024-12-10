{
  config,
  lib,
  pkgs,
  ...
}:

let
  nncpCfgFile = "/run/nncp.hjson";
  programCfg = config.programs.nncp;
  settingsFormat = pkgs.formats.json { };
  jsonCfgFile = settingsFormat.generate "nncp.json" programCfg.settings;
  pkg = programCfg.package;
in
{
  options.programs.nncp = {

    enable = lib.mkEnableOption "NNCP (Node to Node copy) utilities and configuration";

    group = lib.mkOption {
      type = lib.types.str;
      default = "uucp";
      description = ''
        The group under which NNCP files shall be owned.
        Any member of this group may access the secret keys
        of this NNCP node.
      '';
    };

    package = lib.mkPackageOption pkgs "nncp" { };

    secrets = lib.mkOption {
      type = with lib.types; listOf str;
      example = [ "/run/keys/nncp.hjson" ];
      description = ''
        A list of paths to NNCP configuration files that should not be
        in the Nix store. These files are layered on top of the values at
        [](#opt-programs.nncp.settings).
      '';
    };

    settings = lib.mkOption {
      type = settingsFormat.type;
      description = ''
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

  config = lib.mkIf programCfg.enable {

    environment = {
      systemPackages = [ pkg ];
      etc."nncp.hjson".source = nncpCfgFile;
    };

    programs.nncp.settings = {
      spool = lib.mkDefault "/var/spool/nncp";
      log = lib.mkDefault "/var/spool/nncp/log";
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
        umask 127
        rm -f ${nncpCfgFile}
        for f in ${jsonCfgFile} ${builtins.toString config.programs.nncp.secrets}
        do
          ${lib.getExe pkgs.hjson-go} -c <"$f"
        done |${lib.getExe pkgs.jq} --slurp add >${nncpCfgFile}
        chgrp ${programCfg.group} ${nncpCfgFile}
      '';
    };
  };

  meta.maintainers = with lib.maintainers; [ ehmry ];
}

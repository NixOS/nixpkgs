{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.sks;
  sksPkg = cfg.package;
  dbConfig = pkgs.writeText "DB_CONFIG" ''
    ${cfg.extraDbConfig}
  '';

in {
  meta.maintainers = with maintainers; [ primeos calbrecht jcumming ];

  options = {

    services.sks = {

      enable = mkEnableOption ''
        SKS (synchronizing key server for OpenPGP) and start the database
        server. You need to create "''${dataDir}/dump/*.gpg" for the initial
        import'';

      package = mkOption {
        default = pkgs.sks;
        defaultText = literalExpression "pkgs.sks";
        type = types.package;
        description = lib.mdDoc "Which SKS derivation to use.";
      };

      dataDir = mkOption {
        type = types.path;
        default = "/var/db/sks";
        example = "/var/lib/sks";
        # TODO: The default might change to "/var/lib/sks" as this is more
        # common. There's also https://github.com/NixOS/nixpkgs/issues/26256
        # and "/var/db" is not FHS compliant (seems to come from BSD).
        description = lib.mdDoc ''
          Data directory (-basedir) for SKS, where the database and all
          configuration files are located (e.g. KDB, PTree, membership and
          sksconf).
        '';
      };

      extraDbConfig = mkOption {
        type = types.str;
        default = "";
        description = lib.mdDoc ''
          Set contents of the files "KDB/DB_CONFIG" and "PTree/DB_CONFIG" within
          the ''${dataDir} directory. This is used to configure options for the
          database for the sks key server.

          Documentation of available options are available in the file named
          "sampleConfig/DB_CONFIG" in the following repository:
          https://bitbucket.org/skskeyserver/sks-keyserver/src
        '';
      };

      hkpAddress = mkOption {
        default = [ "127.0.0.1" "::1" ];
        type = types.listOf types.str;
        description = lib.mdDoc ''
          Domain names, IPv4 and/or IPv6 addresses to listen on for HKP
          requests.
        '';
      };

      hkpPort = mkOption {
        default = 11371;
        type = types.ints.u16;
        description = lib.mdDoc "HKP port to listen on.";
      };

      webroot = mkOption {
        type = types.nullOr types.path;
        default = "${sksPkg.webSamples}/OpenPKG";
        defaultText = literalExpression ''"''${package.webSamples}/OpenPKG"'';
        description = lib.mdDoc ''
          Source directory (will be symlinked, if not null) for the files the
          built-in webserver should serve. SKS (''${pkgs.sks.webSamples})
          provides the following examples: "HTML5", "OpenPKG", and "XHTML+ES".
          The index file can be named index.html, index.htm, index.xhtm, or
          index.xhtml. Files with the extensions .css, .es, .js, .jpg, .jpeg,
          .png, or .gif are supported. Subdirectories and filenames with
          anything other than alphanumeric characters and the '.' character
          will be ignored.
        '';
      };
    };
  };

  config = mkIf cfg.enable {

    users = {
      users.sks = {
        isSystemUser = true;
        description = "SKS user";
        home = cfg.dataDir;
        createHome = true;
        group = "sks";
        useDefaultShell = true;
        packages = [ sksPkg pkgs.db ];
      };
      groups.sks = { };
    };

    systemd.services = let
      hkpAddress = "'" + (builtins.concatStringsSep " " cfg.hkpAddress) + "'" ;
      hkpPort = builtins.toString cfg.hkpPort;
    in {
      sks-db = {
        description = "SKS database server";
        after = [ "network.target" ];
        wantedBy = [ "multi-user.target" ];
        preStart = ''
          ${lib.optionalString (cfg.webroot != null)
            "ln -sfT \"${cfg.webroot}\" web"}
          mkdir -p dump
          ${sksPkg}/bin/sks build dump/*.gpg -n 10 -cache 100 || true #*/
          ${sksPkg}/bin/sks cleandb || true
          ${sksPkg}/bin/sks pbuild -cache 20 -ptree_cache 70 || true
          # Check that both database configs are symlinks before overwriting them
          # TODO: The initial build will be without DB_CONFIG, but this will
          # hopefully not cause any significant problems. It might be better to
          # create both directories manually but we have to check that this does
          # not affect the initial build of the DB.
          for CONFIG_FILE in KDB/DB_CONFIG PTree/DB_CONFIG; do
            if [ -e $CONFIG_FILE ] && [ ! -L $CONFIG_FILE ]; then
              echo "$CONFIG_FILE exists but is not a symlink." >&2
              echo "Please remove $PWD/$CONFIG_FILE manually to continue." >&2
              exit 1
            fi
            ln -sf ${dbConfig} $CONFIG_FILE
          done
        '';
        serviceConfig = {
          WorkingDirectory = "~";
          User = "sks";
          Group = "sks";
          Restart = "always";
          ExecStart = "${sksPkg}/bin/sks db -hkp_address ${hkpAddress} -hkp_port ${hkpPort}";
        };
      };
    };
  };
}

{ lib, config, pkgs, ... }:

with lib;

let
  cfg = config.services.isso;

  user = "isso";
  desc = "Isso commenting server";
  home = "/var/lib/isso";
  db = "${home}/comments.db";

  sectEsc = escape [ "[" "]" ];
  keyEsc = escape [ "=" ];
  # TODO: assert that the above escapes are not used
  mkSection = sect: attrs: ''
    [${sect}]
    ${concatStringsSep "\n" (mapAttrsToList (key: val: ''
      ${key} = ${val}
    '') attrs)}
  '';

  mergedConfig = cfg.config.otherConfig
    // { general.host = concatStringsSep "\n " cfg.config.general.host; };
  generatedConfig = mapAttrsToList mkSection mergedConfig;
  configFile = pkgs.writeText "isso.cfg" (concatStringsSep "\n" generatedConfig);

in
{
  options = {
    services.isso = with types; {

      enable = mkEnableOption "the ${desc}";

      config = mkOption {
        description = ''
          Isso INI-style configuration.
        '';
        type = submodule ({ options = {

          general = mkOption {
            description = "Isso [general] section.";
            type = submodule ({ options = {
              host = mkOption {
                type = listOf str;
                description = ''
                  Websites isso should respond to. Non-empty.
                '';
                example = [ "localhost" "example.com" ];
                default = [];
              };
            };});
            default = {};
          };

          otherConfig = mkOption {
            type = attrsOf (attrsOf str);
            description = ''
              Attribute set converted to INI; more specific options
              overwrite the contents of this set.
            '';
            example = {
              server.listen = "localhost:8080";
              general.log-file = "${home}/isso.log";
            };
            default = {
              general.dbpath = db;
            };
          };

        };});
      };
    };
  };


  config = mkIf cfg.enable {

    assertions = [
      { assertion = cfg.config.general.host != [];
        message = "host must not be empty"; }
    ];

    systemd.services.isso = {
      description = desc;
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      restartIfChanged = true;

      serviceConfig = {
        # TODO: wsgi support
        ExecStart = ''
          ${pkgs.pythonPackages.isso}/bin/isso -c "${configFile}" run
        '';
        User = user;
        Group = user;
        PrivateTmp = true;
      };
    };

    users.users.isso = {
     description = desc;
     group = user;
     uid = config.ids.uids.isso;
     home = home;
     createHome = true;
    };
    users.groups.isso.gid = config.ids.gids.isso;

  };
}

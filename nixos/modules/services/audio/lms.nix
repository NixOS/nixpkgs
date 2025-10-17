{
  config,
  lib,
  pkgs,
  ...
}:

let
  settingsFormat = pkgs.formats.toml { };
in
{
  options = {
    services.lms = {
      enable = lib.mkEnableOption "Lightweight Music Server";

      package = lib.mkPackageOption pkgs "lms" { };

      settings = lib.mkOption {
        type = lib.types.submodule {
          freeformType = settingsFormat.type;

          options = {
            listen-addr = lib.mkOption {
              default = "127.0.0.1";
              type = lib.types.str;
              description = "Host address to run lms";
            };

            listen-port = lib.mkOption {
              default = 5082;
              type = lib.types.port;
              description = "Port to run lms";
            };

            working-dir = lib.mkOption {
              default = "/var/lms";
              type = lib.types.str;
              description = "Path to the working directory where the database and other cached files will be written to. This directory will be created by the systemd service.";
            };
          };
        };
        default = { };
        example = {
          listen-addr = "127.0.0.1";
          listen-port = "5082";
          working-dir = "/var/lms";
          log-min-severity = "info";
        };
        description = "LMS configurations. For supported keys checkout the default lms.conf file supplied with the package.";
      };

      openFirewall = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Whether to open the TCP port in the firewall";
      };
    };
  };

  config =
    let
      cfg = config.services.lms;
      generateConfig =
        name: value:
        let
          values = lib.mapAttrs (
            k: v:
            lib.pipe v [
              (v: builtins.toString v)
              (v: builtins.replaceStrings [ "/" ] [ "\\/" ] v)
            ]
          ) value;

        in
        pkgs.callPackage (
          { runCommand, jq }:
          runCommand name
            {
              preferLocalBuild = true;
            }
            ''
              cp ${pkgs.lms}/share/lms/lms.conf lms.conf
              ${lib.concatStringsSep "\n" (
                lib.mapAttrsToList (k: v: ''
                  sed --in-place -E 's/(${k} = )(")?[a-zA-Z0-9/.]*(")?;/\1\2${builtins.toString v}\3;/' lms.conf
                '') values
              )}
              cp lms.conf $out
            ''
        ) { };
    in
    lib.mkIf cfg.enable rec {

      users.groups.lms = { };
      users.users.lms = {
        group = config.users.groups.lms.name;
        isSystemUser = true;
        createHome = true;
        home = cfg.settings.working-dir;
      };
      systemd.packages = with pkgs; [ lms ];
      systemd.services.lmsd = {
        enable = true;
        wantedBy = [ "multi-user.target" ];
        script = ''
          ${pkgs.lms}/bin/lms ${generateConfig "lms.conf" cfg.settings}
        '';
        serviceConfig = {
          User = config.users.users.lms.name;
          Group = config.users.groups.lms.name;
        };
      };
      networking.firewall.allowedTCPPorts = lib.mkIf cfg.openFirewall [
        cfg.settings.listen-port
      ];
    };
  meta.maintainers = with lib.maintainers; [ mksafavi ];
}

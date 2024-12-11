{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let

  cfg = config.services.manticore;
  format = pkgs.formats.json { };

  toSphinx =
    {
      mkKeyValue ? generators.mkKeyValueDefault { } "=",
      listsAsDuplicateKeys ? true,
    }:
    attrsOfAttrs:
    let
      # map function to string for each key val
      mapAttrsToStringsSep =
        sep: mapFn: attrs:
        concatStringsSep sep (mapAttrsToList mapFn attrs);
      mkSection =
        sectName: sectValues:
        ''
          ${sectName} {
        ''
        + lib.generators.toKeyValue { inherit mkKeyValue listsAsDuplicateKeys; } sectValues
        + ''}'';
    in
    # map input to ini sections
    mapAttrsToStringsSep "\n" mkSection attrsOfAttrs;

  configFile = pkgs.writeText "manticore.conf" (
    toSphinx {
      mkKeyValue = k: v: "  ${k} = ${v}";
    } cfg.settings
  );

in
{

  options = {
    services.manticore = {

      enable = mkEnableOption "Manticoresearch";

      settings = mkOption {
        default = {
          searchd = {
            listen = [
              "127.0.0.1:9312"
              "127.0.0.1:9306:mysql"
              "127.0.0.1:9308:http"
            ];
            log = "/var/log/manticore/searchd.log";
            query_log = "/var/log/manticore/query.log";
            pid_file = "/run/manticore/searchd.pid";
            data_dir = "/var/lib/manticore";
          };
        };
        description = ''
          Configuration for Manticoresearch. See
          <https://manual.manticoresearch.com/Server%20settings>
          for more information.
        '';
        type = types.submodule {
          freeformType = format.type;
        };
        example = literalExpression ''
          {
            searchd = {
                listen = [
                  "127.0.0.1:9312"
                  "127.0.0.1:9306:mysql"
                  "127.0.0.1:9308:http"
                ];
                log = "/var/log/manticore/searchd.log";
                query_log = "/var/log/manticore/query.log";
                pid_file = "/run/manticore/searchd.pid";
                data_dir = "/var/lib/manticore";
            };
          }
        '';
      };

    };
  };

  config = mkIf cfg.enable {

    systemd = {
      packages = [ pkgs.manticoresearch ];
      services.manticore = {
        wantedBy = [ "multi-user.target" ];
        after = [ "network.target" ];
        serviceConfig =
          {
            ExecStart = [
              ""
              "${pkgs.manticoresearch}/bin/searchd --config ${configFile}"
            ];
            ExecStop = [
              ""
              "${pkgs.manticoresearch}/bin/searchd --config ${configFile} --stopwait"
            ];
            ExecStartPre = [ "" ];
            DynamicUser = true;
            LogsDirectory = "manticore";
            RuntimeDirectory = "manticore";
            StateDirectory = "manticore";
            ReadWritePaths = "";
            CapabilityBoundingSet = "";
            RestrictAddressFamilies = [
              "AF_UNIX"
              "AF_INET"
              "AF_INET6"
            ];
            RestrictNamespaces = true;
            PrivateDevices = true;
            PrivateUsers = true;
            ProtectClock = true;
            ProtectControlGroups = true;
            ProtectHome = true;
            ProtectKernelLogs = true;
            ProtectKernelModules = true;
            ProtectKernelTunables = true;
            SystemCallArchitectures = "native";
            SystemCallFilter = [
              "@system-service"
              "~@privileged"
            ];
            RestrictRealtime = true;
            LockPersonality = true;
            MemoryDenyWriteExecute = true;
            UMask = "0066";
            ProtectHostname = true;
          }
          // lib.optionalAttrs (cfg.settings.searchd.pid_file != null) {
            PIDFile = cfg.settings.searchd.pid_file;
          };
      };
    };

  };

  meta.maintainers = with lib.maintainers; [ onny ];

}

{ config, pkgs, lib, ... }:
let
  cfg = config.services.qbittorrent;
  inherit (lib.types) str unspecified;
  inherit (lib.meta) getExe maintainers;
  inherit (lib.options) mkEnableOption mkOption mkPackageOption mdDoc;
  inherit (lib.modules) mkIf;

  inherit (builtins) concatStringsSep isAttrs;
  inherit (lib.attrsets) mapAttrsToList;
  inherit (lib.strings) escape;
  inherit (lib.generators) toINI mkKeyValueDefault mkValueStringDefault;
  gendeepINI = toINI {
    mkKeyValue = let
      sep = "=";
    in
      k: v:
        if isAttrs v
        then
          concatStringsSep "\n"
          (mapAttrsToList (k2: v2:
            "${escape [sep] "${k}\\${k2}"}${sep}${mkValueStringDefault {} v2}"
            )
          v)
        else mkKeyValueDefault {} sep k v;
  };
in
{
  options.services.qbittorrent = {
    enable = mkEnableOption (mdDoc "qbittorrent, BitTorrent client.");

    user = mkOption {
      type = str;
      default = "qbittorrent";
      description = mdDoc "User account under which qbittorrent runs.";
    };

    group = mkOption {
      type = str;
      default = "qbittorrent";
      description = mdDoc "Group under which qbittorrent runs.";
    };

    package = mkPackageOption pkgs "qbittorrent-nox" { };

    profileDir = mkOption {
      type = str;
      default = "/var/lib/qBittorrent/";
      description = mdDoc "the path passed to qbittorrent via --profile";
    };

    serverConfig = mkOption {
      type = unspecified;
    };
  };
  config = lib.mkIf cfg.enable {
    systemd = {
      tmpfiles.settings = {
        profileDir = {
          "${cfg.profileDir}/qBittorrent/"."d" = {
            mode = "700";
            inherit (cfg) user group;
          };
        };
        configFile = {
          "${cfg.profileDir}/qBittorrent/config/qBittorrent.conf"."L+" = {
            mode = "400";
            inherit (cfg) user group;
            argument = "${pkgs.writeText "qBittorrent.conf" (gendeepINI cfg.serverConfig)}";
          };
        };
      };
      # based on https://github.com/qbittorrent/qBittorrent/blob/master/dist/unix/systemd/qbittorrent-nox%40.service.in
      services.qbittorrent = {
        description = "qbittorrent BitTorrent client";
        wants = [ "network-online.target" ];
        after = [ "local-fs.target" "network-online.target" "nss-lookup.target" ];
        wantedBy = [ "multi-user.target" ];

        serviceConfig = {
          Type = "simple";
          User = cfg.user;
          Group = cfg.group;
          UMask = "0077";
          PrivateTmp = false;
          ExecStart = "${getExe cfg.package} --profile=${cfg.profileDir}";
          TimeoutStopSec = 1800;
        };
      };
    };

    users = {
      users = mkIf (cfg.user == "qbittorrent") {
        qbittorrent = {
          inherit (cfg) group;
          isSystemUser = true;
        };
      };
      groups = mkIf (cfg.group == "qbittorrent") {
        qbittorrent = {};
      };
    };
  };
  meta.maintainers = with maintainers; [ nu-nu-ko ];
}

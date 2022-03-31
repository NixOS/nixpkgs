{ pkgs
, lib
, config
, ...
}:
with lib;
let
  cfg = config.quotas;

  quotaType = types.submodule
    {
      options = {
        enable = mkEnableOption "Disk quota";
        block-softlimit = mkOption {
          type = types.int;
          description = "Soft limit on blocks (1 block is 1 kilobyte)";
          default = 0;
        };
        block-hardlimit = mkOption {
          type = types.int;
          description = "Hard limit on blocks (1 block is 1 kilobyte)";
          default = 0;
        };
        inode-softlimit = mkOption {
          type = types.int;
          description = "Soft limit on inodes";
          default = 0;
        };
        inode-hardlimit = mkOption {
          type = types.int;
          description = "Hard limit on inodes";
          default = 0;
        };
      };
    };
in
{
  options.quotas = {
    enable = mkEnableOption "Disk Quotas";
    fileSystems = mkOption {
      type = types.attrsOf (types.submodule {
        options = {
          enable = mkEnableOption "Disk quota for this filesystem";
          userquotas = mkOption {
            type = types.attrsOf quotaType;
            description = "Quotas per user";
            default = { };
          };
          groupquotas = mkOption {
            type = types.attrsOf quotaType;
            description = "Quotas per group";
            default = { };
          };
        };
      });
      default = { };
      description = "Quotas settings";
    };
  };
  config = mkIf (cfg.enable) {
    environment.systemPackages = [ pkgs.quota ];
    fileSystems = mapAttrs
      (name: fs: {
        options = [
          "defaults"
          "usrquota"
          "grpquota"
          "jqfmt=vfsv0"
        ];
      })
      cfg.fileSystems;
    systemd.services.set-disk-quotas =
      let
        setUserQuotaScript = fs: user: q: with q; optionalString enable ''
          setquota -u ${user} \
            ${builtins.toString block-softlimit} \
            ${builtins.toString block-hardlimit} \
            ${builtins.toString inode-softlimit} \
            ${builtins.toString inode-hardlimit} \
            ${fs}
        '';
        setUserQuotasScript = fsName: userquotas: concatStringsSep "\n" (mapAttrsToList (setUserQuotaScript fsName) userquotas);
        setGroupQuotaScript = fs: group: q: with q; optionalString enable ''
          setquota -g ${group} \
            ${builtins.toString block-softlimit} \
            ${builtins.toString block-hardlimit} \
            ${builtins.toString inode-softlimit} \
            ${builtins.toString inode-hardlimit} \
            ${fs}
        '';
        setGroupQuotasScript = fsName: userquotas: concatStringsSep "\n" (mapAttrsToList (setGroupQuotaScript fsName) userquotas);
        setFsQuotasScript = fsName: fs: ''
          ${setUserQuotasScript fsName fs.userquotas}
          ${setGroupQuotasScript fsName fs.groupquotas}
        '';
        setQuotaScripts = concatStringsSep "\n" (mapAttrsToList setFsQuotasScript cfg.fileSystems);
      in
      {
        description = "Set quotas for all filesystems";
        path = [ pkgs.quota ];
        wantedBy = [ "local-fs.target" ];
        serviceConfig = {
          Type = "oneshot";
          # First turn off the quotas to safely run `quotacheck`.
          # See https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/6/html/storage_administration_guide/disk-quotas-keep-accurate
          ExecStart = "${pkgs.writeShellScript "set-disk-quotas" ''
            quotaoff --all --user --group --verbose
            quotacheck --all --user --no-remount --verbose
            quotaon --all --user --group --verbose
            ${setQuotaScripts}
          ''}";
        };
      };
  };
}

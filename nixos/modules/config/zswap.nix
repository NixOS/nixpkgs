{
  config,
  lib,
  pkgs,
  ...
}:

let

  cfg = config.zswap;

in

{
  ###### interface

  options = {

    zswap = {

      enable = lib.mkOption {
        default = false;
        type = lib.types.bool;
        description = ''
          Enable zswap, a lightweight compressed cache for swap pages.
          See [
          https://www.kernel.org/doc/Documentation/vm/zswap.txt
          ] (https://www.kernel.org/doc/Documentation/vm/zswap.txt)
        '';
      };

      maxPoolPercent = lib.mkOption {
        default = 20;
        type = lib.types.int;
        description = ''
          The maximum percentage of memory that the compressed pool can occupy.
        '';
      };

      compressor = lib.mkOption {
        default = "zstd";
        example = "lzo";
        type =
          with lib.types;
          either (enum [
            "842"
            "lzo"
            "lz4"
            "lz4hc"
            "zstd"
          ]) str;
        description = ''
          Compression algorithm. `lzo` has good compression,
          but is slow. `lz4` has bad compression, but is fast.
          `zstd` is both good compression and fast.
        '';
      };

      zpool = lib.mkOption {
        default = "zsmalloc";
        type =
          with lib.types;
          either (enum [
            "zsmalloc"
            "zbud"
          ]) str;
        description = ''
          Zswap makes use of zpool for managing the compressed memory pool.
          See [
            https://docs.kernel.org/admin-guide/mm/zswap.html#design
          ] (https://docs.kernel.org/admin-guide/mm/zswap.html#design).
        '';
      };

      acceptThresholdPercent = lib.mkOption {
        default = 90;
        type = lib.types.int;
        description = ''
          Sets the threshold at which zswap would start accepting pages again
          after it became full.
        '';
      };
    };

  };

  config = lib.mkMerge [

    (lib.mkIf cfg.enable {
      boot.kernelParams = [ "zswap.enabled=1" ];

      system.activationScripts.zswap-activate = ''
        echo ${toString cfg.maxPoolPercent} > /sys/module/zswap/parameters/max_pool_percent
        echo ${cfg.compressor} > /sys/module/zswap/parameters/compressor
        echo ${cfg.zpool} > /sys/module/zswap/parameters/zpool
        echo ${toString cfg.acceptThresholdPercent} > /sys/module/zswap/parameters/accept_threshold_percent
        echo "Y" > /sys/module/zswap/parameters/enabled
      '';
    })

    (lib.mkIf (!cfg.enable) {
      system.activationScripts.zswap-activate = ''
        echo N > /sys/module/zswap/parameters/enabled
      '';
    })

  ];

  meta.maintainers = with lib.maintainers; [ pigsinablanket ];
}

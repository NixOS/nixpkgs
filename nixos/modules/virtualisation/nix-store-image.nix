{
  config,
  lib,
  ...
}:

let
  compression = config.virtualisation.nixStoreImageCompression;

  levelOption =
    type:
    lib.mkOption {
      type = lib.types.nullOr type;
      default = null;
      description = ''
        Compression level. Set to `null` to use the compressor's default.
      '';
    };

  dictionaryOption =
    type:
    lib.mkOption {
      type = lib.types.nullOr type;
      default = null;
      description = ''
        Dictionary size in bytes. Set to `null` to use the compressor's default.
      '';
    };

  powerOfTwo =
    minimum: maximum:
    (lib.types.addCheck (lib.types.ints.between minimum maximum) (
      size: builtins.bitAnd size (size - 1) == 0
    ))
    // {
      description = "integer between ${toString minimum} and ${toString maximum} that is a power of two";
    };

  bitOption =
    description:
    lib.mkOption {
      type = lib.types.nullOr (lib.types.ints.between 0 4);
      default = null;
      inherit description;
    };

  compressor =
    description: options:
    lib.mkOption {
      type = lib.types.submodule { inherit options; };
      inherit description;
    };

  compressors = {
    lz4 = compressor "Use LZ4 compression." { };

    lz4hc = compressor "Use LZ4 high compression." {
      level = levelOption (lib.types.ints.between 0 12);
    };

    lzma =
      compressor
        ''
          Use MicroLZMA compression. The default NixOS kernel does not enable
          the EROFS LZMA decoder. Use a kernel with
          `CONFIG_EROFS_FS_ZIP_LZMA=y`, or enable `EROFS_FS_ZIP_LZMA` through
          {option}`boot.kernelPatches` and its `structuredExtraConfig` attribute.
        ''
        {
          level =
            (levelOption (
              lib.types.oneOf [
                (lib.types.ints.between 0 9)
                (lib.types.ints.between 100 109)
              ]
            ))
            // {
              description = ''
                Compression preset: 0 to 9 for normal compression, or 100 to 109
                for the corresponding extreme preset. Set to `null` to use the
                compressor's default.
              '';
            };
          dictionarySize = dictionaryOption (lib.types.ints.between 4096 8388608);
          lc = bitOption ''
            Number of literal context bits. Set to `null` to use the preset's
            default (3). The sum of `lc` and `lp` must not exceed 4.
          '';
          lp = bitOption ''
            Number of literal position bits. Set to `null` to use the preset's
            default (0). The sum of `lc` and `lp` must not exceed 4.
          '';
          pb = bitOption ''
            Number of position bits. Set to `null` to use the preset's default (2).
          '';
        };

    deflate = compressor "Use DEFLATE compression." {
      level = levelOption (lib.types.ints.between 1 9);
      dictionarySize = dictionaryOption (powerOfTwo 1 32768);
    };

    libdeflate = compressor "Use DEFLATE compression through libdeflate." {
      level = levelOption (lib.types.ints.between 0 12);
    };

    zstd = compressor "Use Zstandard compression." {
      level = levelOption (lib.types.ints.between 0 22);
      dictionarySize = dictionaryOption (powerOfTwo 1024 1048576);
    };
  };
in
{
  options.virtualisation.nixStoreImageCompression = lib.mkOption {
    type = lib.types.nullOr (
      lib.types.coercedTo (lib.types.enum (lib.attrNames compressors)) (algorithm: {
        ${algorithm} = { };
      }) (lib.types.attrTag compressors)
    );
    default = null;
    example = {
      zstd = {
        level = 6;
        dictionarySize = 65536;
      };
    };
    description = ''
      Compression for the EROFS Nix store image used by the VM.
      Set to `null` to disable compression, or to an algorithm name such as
      `"lz4"` to use that compressor's default settings. An attribute set
      selects one algorithm and configures its settings.

      Compression can reduce the image size, at the cost of image creation
      time and CPU time for decompression in the guest. The size and timing
      differences depend on the store contents and compression settings.

      QEMU creates a new image on each launch when
      {option}`virtualisation.useNixStoreImage` is enabled. The VZ backend
      reuses its image while the store closure and compression settings
      remain unchanged.

      Compression runs on the host when the image is created. The guest
      kernel must support the selected compression algorithm. The launcher
      checks the kernel configuration before creating the image.
    '';
  };

  config.assertions = lib.optional (compression != null && compression ? lzma) {
    assertion =
      let
        lc = if compression.lzma.lc == null then 3 else compression.lzma.lc;
        lp = if compression.lzma.lp == null then 0 else compression.lzma.lp;
      in
      lc + lp <= 4;
    message = "virtualisation.nixStoreImageCompression.lzma: the sum of lc and lp must not exceed 4.";
  };
}

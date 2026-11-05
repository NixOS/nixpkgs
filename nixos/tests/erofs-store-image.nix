{
  lib,
  pkgs,
  ...
}:

let
  algorithms = [
    "lz4"
    "lz4hc"
    "lzma"
    "deflate"
    "libdeflate"
    "zstd"
  ];

  evaluate =
    definitions:
    let
      inherit
        (lib.evalModules {
          modules = [
            ../modules/misc/assertions.nix
            ../modules/virtualisation/nix-store-image.nix
          ]
          ++ map (value: { virtualisation.nixStoreImageCompression = value; }) definitions;
        })
        config
        ;
    in
    lib.asserts.checkAssertWarn config.assertions [ ] config.virtualisation.nixStoreImageCompression;

  defaults = [
    { lz4 = { }; }
    { lz4hc.level = null; }
    {
      lzma = {
        level = null;
        dictionarySize = null;
        lc = null;
        lp = null;
        pb = null;
      };
    }
    {
      deflate = {
        level = null;
        dictionarySize = null;
      };
    }
    { libdeflate.level = null; }
    {
      zstd = {
        level = null;
        dictionarySize = null;
      };
    }
  ];

  valid = {
    lz4hc-minimum-level.lz4hc.level = 0;
    lz4hc-maximum-level.lz4hc.level = 12;
    lzma-minimum-level.lzma.level = 0;
    lzma-maximum-level.lzma.level = 9;
    lzma-minimum-extreme-level.lzma.level = 100;
    lzma-maximum-extreme-level.lzma.level = 109;
    lzma-minimum-dictionary.lzma.dictionarySize = 4096;
    lzma-maximum-dictionary.lzma.dictionarySize = 8388608;
    lzma-default-context-bits.lzma.lp = 1;
    lzma-maximum-bits.lzma = {
      lc = 0;
      lp = 4;
      pb = 4;
    };
    deflate-minimum-level.deflate.level = 1;
    deflate-maximum-level.deflate.level = 9;
    deflate-minimum-dictionary.deflate.dictionarySize = 1;
    deflate-maximum-dictionary.deflate.dictionarySize = 32768;
    libdeflate-minimum-level.libdeflate.level = 0;
    libdeflate-maximum-level.libdeflate.level = 12;
    zstd-minimum-level.zstd.level = 0;
    zstd-maximum-level.zstd.level = 22;
    zstd-minimum-dictionary.zstd.dictionarySize = 1024;
    zstd-maximum-dictionary.zstd.dictionarySize = 1048576;
  };

  invalid = {
    unknown-algorithm = "gzip";
    arguments-in-shorthand = "zstd,level=6";
    empty-union = { };
    multiple-algorithms = {
      lz4 = { };
      zstd = { };
    };
    lz4-level.lz4.level = 1;
    lz4hc-dictionary.lz4hc.dictionarySize = 4096;
    negative-level.lz4hc.level = -1;
    lz4hc-level.lz4hc.level = 13;
    lzma-normal-level.lzma.level = 10;
    lzma-extreme-level-too-small.lzma.level = 99;
    lzma-extreme-level-too-large.lzma.level = 110;
    lzma-dictionary-too-small.lzma.dictionarySize = 4095;
    lzma-dictionary-too-large.lzma.dictionarySize = 8388609;
    lzma-context-bits.lzma.lc = 5;
    lzma-default-context-and-position-bits.lzma.lp = 2;
    lzma-position-bits.lzma.pb = -1;
    lzma-context-and-position-bits.lzma = {
      lc = 3;
      lp = 2;
    };
    deflate-zero-level.deflate.level = 0;
    deflate-level.deflate.level = 10;
    deflate-dictionary-not-power-of-two.deflate.dictionarySize = 8191;
    deflate-dictionary-too-small.deflate.dictionarySize = 0;
    deflate-dictionary-too-large.deflate.dictionarySize = 32769;
    libdeflate-level.libdeflate.level = 13;
    libdeflate-dictionary.libdeflate.dictionarySize = 4096;
    zstd-level.zstd.level = 23;
    string-level.zstd.level = "6";
    zstd-dictionary-too-small.zstd.dictionarySize = 512;
    zstd-dictionary-not-power-of-two.zstd.dictionarySize = 65535;
    zstd-dictionary-too-large.zstd.dictionarySize = 2097152;
    zstd-context-bits.zstd.lc = 2;
  };

  failures = lib.runTests (
    {
      test-default = {
        expr = evaluate [ ];
        expected = null;
      };
      test-shorthand = {
        expr = map (algorithm: evaluate [ algorithm ]) algorithms;
        expected = defaults;
      };
      test-explicit-defaults = {
        expr = map (algorithm: evaluate [ { ${algorithm} = { }; } ]) algorithms;
        expected = defaults;
      };
      test-merge = {
        expr = evaluate [
          "zstd"
          { zstd.level = 6; }
        ];
        expected.zstd = {
          level = 6;
          dictionarySize = null;
        };
      };
      test-conflicting-algorithms = {
        expr =
          (builtins.tryEval (
            builtins.deepSeq (evaluate [
              "lz4"
              "zstd"
            ]) true
          )).success;
        expected = false;
      };
    }
    // lib.mapAttrs' (
      name: value:
      lib.nameValuePair "test-valid-${name}" {
        expr = (builtins.tryEval (builtins.deepSeq (evaluate [ value ]) true)).success;
        expected = true;
      }
    ) valid
    // lib.mapAttrs' (
      name: value:
      lib.nameValuePair "test-invalid-${name}" {
        expr = (builtins.tryEval (builtins.deepSeq (evaluate [ value ]) true)).success;
        expected = false;
      }
    ) invalid
  );

  fixture = pkgs.runCommand "erofs-store-image-fixture" { } ''
    mkdir "$out"
    for ((i = 0; i < 8192; i++)); do
      printf '%s\n' 'EROFS store image compression fixture'
    done > "$out/payload"
  '';
  storePaths = pkgs.writeText "erofs-store-paths" "${fixture}\n";

  supportedKernelConfigs =
    lib.mapAttrs (algorithm: setting: pkgs.writeText "${algorithm}-kernel-config" "${setting}=y\n")
      {
        lz4 = "CONFIG_EROFS_FS_ZIP";
        lz4hc = "CONFIG_EROFS_FS_ZIP";
        lzma = "CONFIG_EROFS_FS_ZIP_LZMA";
        deflate = "CONFIG_EROFS_FS_ZIP_DEFLATE";
        libdeflate = "CONFIG_EROFS_FS_ZIP_DEFLATE";
        zstd = "CONFIG_EROFS_FS_ZIP_ZSTD";
      };
  unsupportedKernelConfigs = {
    missing = pkgs.writeText "erofs-missing-kernel-config" "";
    disabled = pkgs.writeText "erofs-disabled-kernel-config" ''
      # CONFIG_EROFS_FS_ZIP is not set
      # CONFIG_EROFS_FS_ZIP_LZMA is not set
      # CONFIG_EROFS_FS_ZIP_DEFLATE is not set
      # CONFIG_EROFS_FS_ZIP_ZSTD is not set
    '';
  };

  kernelChecks = lib.concatMapStringsSep "\n" (
    algorithm:
    lib.concatStringsSep "\n" (
      lib.mapAttrsToList (name: kernelConfig: ''
        if (
          ${import ../lib/erofs-store-image.nix {
            hostPkgs = pkgs;
            inherit storePaths kernelConfig;
            compression = evaluate [ algorithm ];
            label = "nix-store";
            destination = "unsupported-${algorithm}-${name}.erofs";
          }}
          :
        ) 2> kernel-error; then
          echo '${algorithm}: ${name} kernel decoder was accepted' >&2
          exit 1
        fi
        grep -Fq 'virtualisation.nixStoreImageCompression: ${algorithm} requires CONFIG_EROFS_FS_ZIP' kernel-error
        test ! -e unsupported-${algorithm}-${name}.erofs
      '') unsupportedKernelConfigs
    )
  ) algorithms;

  imageCases = [
    {
      name = "uncompressed";
      value = null;
      argument = null;
      kernelConfig = unsupportedKernelConfigs.missing;
    }
  ]
  ++ map (algorithm: {
    name = algorithm;
    value = algorithm;
    argument = algorithm;
  }) algorithms
  ++ [
    {
      name = "lz4-without-kernel-config";
      value = "lz4";
      argument = "lz4";
      kernelConfig = null;
    }
    {
      name = "lz4hc-options";
      value.lz4hc.level = 12;
      argument = "lz4hc,level=12";
    }
    {
      name = "lzma-options";
      value.lzma = {
        level = 106;
        dictionarySize = 65536;
        lc = 2;
        lp = 1;
        pb = 1;
      };
      argument = "lzma,dictsize=65536,lc=2,level=106,lp=1,pb=1";
    }
    {
      name = "deflate-options";
      value.deflate = {
        level = 6;
        dictionarySize = 8192;
      };
      argument = "deflate,dictsize=8192,level=6";
    }
    {
      name = "libdeflate-options";
      value.libdeflate.level = 12;
      argument = "libdeflate,level=12";
    }
    {
      name = "zstd-options";
      value.zstd = {
        level = 6;
        dictionarySize = 65536;
      };
      argument = "zstd,dictsize=65536,level=6";
    }
  ];

  mkfs = pkgs.writeShellScriptBin "mkfs.erofs" ''
    printf '%s\n' "$@" > arguments
    exec ${lib.getExe' pkgs.erofs-utils "mkfs.erofs"} "$@"
  '';
in
assert
  lib.debug.throwTestFailures {
    inherit failures;
    description = "EROFS store image options";
  } == null;
pkgs.runCommand "erofs-store-image" { nativeBuildInputs = [ pkgs.erofs-utils ]; } (
  lib.concatMapStringsSep "\n" (
    {
      name,
      value,
      argument,
      kernelConfig ? supportedKernelConfigs.${lib.head (lib.attrNames (evaluate [ value ]))},
    }:
    let
      image = "${name}.erofs";
      expectedArguments = pkgs.writeText "${name}-arguments" (
        lib.concatStringsSep "\n" (
          [ "--quiet" ]
          ++ lib.optionals (argument != null) [
            "-z"
            argument
          ]
          ++ [
            "--force-uid=0"
            "--force-gid=0"
            "-L"
            "nix-store"
            "-U"
            "eb176051-bd15-49b7-9e6b-462e0b467019"
            "-T"
            "0"
            "--hard-dereference"
            "--tar=f"
            image
          ]
        )
        + "\n"
      );
    in
    ''
      ${import ../lib/erofs-store-image.nix {
        hostPkgs = pkgs // {
          erofs-utils = mkfs;
        };
        inherit storePaths;
        label = "nix-store";
        destination = image;
        compression = evaluate [ value ];
        inherit kernelConfig;
      }}
      diff -u ${expectedArguments} arguments
      fsck.erofs --extract=extracted-${name} ${image}
      diff -r ${fixture} extracted-${name}/${baseNameOf fixture}
      ${lib.optionalString (value != null) ''
        test "$(wc -c < ${image})" -lt "$(wc -c < uncompressed.erofs)"
      ''}
    ''
  ) imageCases
  + kernelChecks
  + ''
    touch "$out"
  ''
)

{
  lib,
  pkgs,
  ...
}:

let
  hostPkgs = import pkgs.path { system = "aarch64-darwin"; };
  guestPkgs = import pkgs.path { system = "aarch64-linux"; };

  runner =
    compression: closure:
    (guestPkgs.nixos {
      imports = [ ../modules/virtualisation/vz-vm.nix ];
      system.stateVersion = lib.trivial.release;
      virtualisation.nixStoreImageCompression = compression;
      virtualisation.host.pkgs = hostPkgs // {
        closureInfo = _: closure;
        writeShellScript = _: script: script;
        writeText = _: _: "/config";
        runCommand = _: _: script: { inherit script; };
      };
    }).config.system.build.vm.script;

  closure = "/nix/store/00000000000000000000000000000000-closure-info";
  imageName =
    compression: storeClosure:
    lib.head (
      builtins.match ".*storeImage=\"\\$imageDir/([^\"]+)\".*" (runner compression storeClosure)
    );

  cachedImage = compression: imageName compression closure;

  defaults = cachedImage "zstd";
  guestSystem =
    compression:
    (guestPkgs.nixos {
      imports = [ ../modules/virtualisation/vz-vm.nix ];
      system.stateVersion = lib.trivial.release;
      virtualisation.nixStoreImageCompression = compression;
      virtualisation.host.pkgs = hostPkgs;
    }).config.system.build.toplevel.drvPath;

  level = cachedImage { zstd.level = 6; };
  dictionary = cachedImage {
    zstd = {
      level = 6;
      dictionarySize = 65536;
    };
  };

  failures = lib.runTests {
    test-uncompressed-cache-name = {
      expr = map (imageName null) [
        closure
        "/nix/store/11111111111111111111111111111111-closure-info"
      ];
      expected = [
        "store-00000000000000000000000000000000.img"
        "store-11111111111111111111111111111111.img"
      ];
    };
    test-compression-preserves-guest = {
      expr = map guestSystem [
        "lz4"
        "lzma"
        { zstd.level = 6; }
      ];
      expected = lib.replicate 3 (guestSystem null);
    };
    test-compression-cache-key = {
      expr = {
        shorthand = defaults == cachedImage { zstd = { }; };
        disabled = defaults != cachedImage null;
        algorithm = defaults != cachedImage "lz4";
        level = defaults != level;
        dictionary = level != dictionary;
      };
      expected = {
        shorthand = true;
        disabled = true;
        algorithm = true;
        level = true;
        dictionary = true;
      };
    };
    test-closure-cache-key = {
      expr =
        imageName "zstd" closure
        == imageName "zstd" "/nix/store/11111111111111111111111111111111-closure-info";
      expected = false;
    };
    test-compression-arguments = {
      expr = lib.hasInfix "-z 'zstd,dictsize=65536,level=6'" (
        runner {
          zstd = {
            level = 6;
            dictionarySize = 65536;
          };
        } closure
      );
      expected = true;
    };
  };
in
assert
  lib.debug.throwTestFailures {
    inherit failures;
    description = "VZ store image evaluation";
  } == null;
pkgs.emptyFile

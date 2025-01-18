{
  lib,
  stdenv,
  buildRustCrate,
  fetchgit,
}:
let
  kernel = stdenv.buildPlatform.parsed.kernel.name;
  abi = stdenv.buildPlatform.parsed.abi.name;
  include =
    includedFiles: src:
    builtins.filterSource (
      path: type:
      lib.lists.any (
        f:
        let
          p = toString (src + ("/" + f));
        in
        (path == p) || (type == "directory" && lib.strings.hasPrefix path p)
      ) includedFiles
    ) src;
  updateFeatures =
    f: up: functions:
    builtins.deepSeq f (
      lib.lists.foldl' (features: fun: fun features) (lib.attrsets.recursiveUpdate f up) functions
    );
  mapFeatures = features: map (fun: fun { features = features; });
  mkFeatures =
    feat:
    lib.lists.foldl (
      features: featureName:
      if feat.${featureName} or false then [ featureName ] ++ features else features
    ) [ ] (builtins.attrNames feat);
in
rec {
  alloc_no_stdlib_1_3_0_ =
    {
      dependencies ? [ ],
      buildDependencies ? [ ],
      features ? [ ],
    }:
    buildRustCrate {
      crateName = "alloc-no-stdlib";
      version = "1.3.0";
      authors = [ "Daniel Reiter Horn <danielrh@dropbox.com>" ];
      sha256 = "1jcp27pzmqdszgp80y484g4kwbjbg7x8a589drcwbxg0i8xwkir9";
      crateBin = [ { name = "example"; } ];
      inherit dependencies buildDependencies features;
    };
  brotli_2_5_0_ =
    {
      dependencies ? [ ],
      buildDependencies ? [ ],
      features ? [ ],
    }:
    buildRustCrate {
      crateName = "brotli";
      version = "2.5.0";
      authors = [
        "Daniel Reiter Horn <danielrh@dropbox.com>"
        "The Brotli Authors"
      ];
      sha256 = "1ynw4hkdwnp0kj30p86ls44ahv4s99258s019bqrq4mya8hlsb5b";
      crateBin = [ { name = "brotli"; } ];
      inherit dependencies buildDependencies features;
    };
  brotli_decompressor_1_3_1_ =
    {
      dependencies ? [ ],
      buildDependencies ? [ ],
      features ? [ ],
    }:
    buildRustCrate {
      crateName = "brotli-decompressor";
      version = "1.3.1";
      authors = [
        "Daniel Reiter Horn <danielrh@dropbox.com>"
        "The Brotli Authors"
      ];
      sha256 = "022g69q1xzwdj0130qm3fa4qwpn4q1jx3lc8yz0v0v201p7bm8fb";
      crateBin = [ { name = "brotli-decompressor"; } ];
      inherit dependencies buildDependencies features;
    };
  alloc_no_stdlib_1_3_0 =
    {
      features ? (alloc_no_stdlib_1_3_0_features { }),
    }:
    alloc_no_stdlib_1_3_0_ {
      features = mkFeatures (features.alloc_no_stdlib_1_3_0 or { });
    };
  alloc_no_stdlib_1_3_0_features =
    f:
    updateFeatures f ({
      alloc_no_stdlib_1_3_0.default = (f.alloc_no_stdlib_1_3_0.default or true);
    }) [ ];
  brotli_2_5_0 =
    {
      features ? (brotli_2_5_0_features { }),
    }:
    brotli_2_5_0_ {
      dependencies = mapFeatures features ([
        alloc_no_stdlib_1_3_0
        brotli_decompressor_1_3_1
      ]);
      features = mkFeatures (features.brotli_2_5_0 or { });
    };
  brotli_2_5_0_features =
    f:
    updateFeatures f
      (rec {
        alloc_no_stdlib_1_3_0.no-stdlib =
          (f.alloc_no_stdlib_1_3_0.no-stdlib or false)
          || (brotli_2_5_0.no-stdlib or false)
          || (f.brotli_2_5_0.no-stdlib or false);
        alloc_no_stdlib_1_3_0.default = true;
        brotli_2_5_0.default = (f.brotli_2_5_0.default or true);
        brotli_decompressor_1_3_1.disable-timer =
          (f.brotli_decompressor_1_3_1.disable-timer or false)
          || (brotli_2_5_0.disable-timer or false)
          || (f.brotli_2_5_0.disable-timer or false);
        brotli_decompressor_1_3_1.no-stdlib =
          (f.brotli_decompressor_1_3_1.no-stdlib or false)
          || (brotli_2_5_0.no-stdlib or false)
          || (f.brotli_2_5_0.no-stdlib or false);
        brotli_decompressor_1_3_1.benchmark =
          (f.brotli_decompressor_1_3_1.benchmark or false)
          || (brotli_2_5_0.benchmark or false)
          || (f.brotli_2_5_0.benchmark or false);
        brotli_decompressor_1_3_1.default = true;
        brotli_decompressor_1_3_1.seccomp =
          (f.brotli_decompressor_1_3_1.seccomp or false)
          || (brotli_2_5_0.seccomp or false)
          || (f.brotli_2_5_0.seccomp or false);
      })
      [
        alloc_no_stdlib_1_3_0_features
        brotli_decompressor_1_3_1_features
      ];
  brotli_decompressor_1_3_1 =
    {
      features ? (brotli_decompressor_1_3_1_features { }),
    }:
    brotli_decompressor_1_3_1_ {
      dependencies = mapFeatures features ([ alloc_no_stdlib_1_3_0 ]);
      features = mkFeatures (features.brotli_decompressor_1_3_1 or { });
    };
  brotli_decompressor_1_3_1_features =
    f:
    updateFeatures f (rec {
      alloc_no_stdlib_1_3_0.no-stdlib =
        (f.alloc_no_stdlib_1_3_0.no-stdlib or false)
        || (brotli_decompressor_1_3_1.no-stdlib or false)
        || (f.brotli_decompressor_1_3_1.no-stdlib or false);
      alloc_no_stdlib_1_3_0.default = true;
      alloc_no_stdlib_1_3_0.unsafe =
        (f.alloc_no_stdlib_1_3_0.unsafe or false)
        || (brotli_decompressor_1_3_1.unsafe or false)
        || (f.brotli_decompressor_1_3_1.unsafe or false);
      brotli_decompressor_1_3_1.default = (f.brotli_decompressor_1_3_1.default or true);
    }) [ alloc_no_stdlib_1_3_0_features ];
}

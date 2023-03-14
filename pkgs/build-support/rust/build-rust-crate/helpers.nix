{ stdenv, lib }:
{
  kernel = stdenv.hostPlatform.parsed.kernel.name;
  abi = stdenv.hostPlatform.parsed.abi.name;
  cpu = stdenv.hostPlatform.parsed.cpu.name;
   updateFeatures = f: up: functions: lib.deepSeq f (lib.foldl' (features: fun: fun features) (lib.attrsets.recursiveUpdate f up) functions);
   mapFeatures = features: map (fun: fun { features = features; });
   mkFeatures = feat: lib.foldl (features: featureName:
     if feat.${featureName} or false then
       [ featureName ] ++ features
     else
       features
   ) [] (lib.attrNames feat);
  include = includedFiles: src: builtins.filterSource (path: type:
     lib.any (f:
       let p = toString (src + ("/" + f));
       in
       p == path || (lib.strings.hasPrefix (p + "/") path)
     ) includedFiles
  ) src;
  exclude = excludedFiles: src: builtins.filterSource (path: type:
    lib.all (f:
       !lib.strings.hasPrefix (toString (src + ("/" + f))) path
    ) excludedFiles
  ) src;

  kinds = rec {
    kind = {
      lib = "lib";
      test = "test";
      bin = "bin";
      bench = "bench";
      example = "example";
    };

    kindToDir = t:
      if isLib t then "lib" else
      if isBin t then "bin" else
      if isTest t then "tests" else
      if isExample t then "examples" else
      if isBench t then "benches" else
      builtins.throw "Invalid kind: ${t}";

    isLib = t: t == kind.lib;
    isBin = t: t == kind.bin;
    isTest = t: t == kind.test;
    isBench = t: t == kind.bench;
    isExample = t: t == kind.example;
  };

}

{stdenv, lib}:
{
  kernel = stdenv.hostPlatform.parsed.kernel.name;
  abi = stdenv.hostPlatform.parsed.abi.name;
  cpu = stdenv.hostPlatform.parsed.cpu.name;
   updateFeatures = f: up: functions: builtins.deepSeq f (lib.lists.foldl' (features: fun: fun features) (lib.attrsets.recursiveUpdate f up) functions);
   mapFeatures = features: map (fun: fun { features = features; });
   mkFeatures = feat: lib.lists.foldl (features: featureName:
     if feat.${featureName} or false then
       [ featureName ] ++ features
     else
       features
   ) [] (builtins.attrNames feat);
  include = includedFiles: src: builtins.filterSource (path: type:
     lib.lists.any (f:
       let p = toString (src + ("/" + f));
           suff = lib.strings.removePrefix p path;
       in
       suff == "" || (lib.strings.hasPrefix "/" suff)
     ) includedFiles
  ) src;
  exclude = excludedFiles: src: builtins.filterSource (path: type:
    lib.lists.all (f:
       !lib.strings.hasPrefix (toString (src + ("/" + f))) path
    ) excludedFiles
  ) src;
}

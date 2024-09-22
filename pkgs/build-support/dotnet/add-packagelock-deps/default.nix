{
  lib,
  fetchNupkg,
  runCommand,
  callPackage,
}:

{
  nugetLockFile,
  overrideFetchAttrs ? x: { },
}:
fnOrAttrs: finalAttrs:
let
  attrs = if builtins.isFunction fnOrAttrs then fnOrAttrs finalAttrs else fnOrAttrs;
  dependencyTool = callPackage ./tool.nix { };

  deps =
    with builtins;
    let
      projectFiles = attrs.dotnetProjectFiles ++ attrs.dotnetTestProjectFiles;
      dynamicLockFiles = fromJSON (
        readFile (
          runCommand "lockfile-discovery"
            {
              inherit projectFiles;
              sourceDir = "${attrs.src}";
              buildInputs = [
                attrs.dotnet-sdk
                dependencyTool
              ];
            }
            ''
              cd "$sourceDir"
              dependencyTool $projectFiles >$out
            ''
        )
      );
      getDeps =
        lockFile:
        let
          nugetPackageLock = fromJSON (readFile "${attrs.src}/${lockFile}");
          allDeps' = foldl' (a: b: a // b) { } (attrValues nugetPackageLock.dependencies);
          allDeps = map (name: { inherit name; } // (getAttr name allDeps')) (attrNames allDeps');
          filteredDeps = filter (dep: (hasAttr "contentHash" dep) && (hasAttr "resolved" dep)) allDeps;
        in
        map (p: {
          pname = p.name;
          version = p.resolved;
          hash = "sha512-${p.contentHash}";
          removeSignature = true;
        }) filteredDeps;
    in
    if lib.isList nugetLockFile then
      lib.unique (map fetchNupkg (foldl' (a: b: a ++ b) [ ] (map getDeps nugetLockFile)))
    else if lib.isString nugetLockFile then
      map fetchNupkg (getDeps nugetLockFile)
    else if (lib.isBool nugetLockFile) && nugetLockFile then
      lib.unique (map fetchNupkg (foldl' (a: b: a ++ b) [ ] (map getDeps dynamicLockFiles)))
    else
      throw "unhandled nugetLockFile state!";

in
attrs
// {
  buildInputs = attrs.buildInputs or [ ] ++ deps;

  passthru = attrs.passthru or { } // {
    nugetDeps = deps;
  };
}

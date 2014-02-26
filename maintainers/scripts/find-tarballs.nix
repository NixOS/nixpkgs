# This expression returns a list of all fetchurl calls used by all
# packages reachable from release.nix.

with import ../.. { };
with lib;

let

  root = removeAttrs (import ../../pkgs/top-level/release.nix { }) [ "tarball" "unstable" ];

  uniqueUrls = map (x: x.file) (genericClosure {
    startSet = map (file: { key = file.url; inherit file; }) urls;
    operator = const [ ];
  });

  urls = map (drv: { url = head drv.urls; hash = drv.outputHash; type = drv.outputHashAlgo; }) fetchurlDependencies;

  fetchurlDependencies = filter (drv: drv.outputHash or "" != "" && drv ? urls) dependencies;

  dependencies = map (x: x.value) (genericClosure {
    startSet = map keyDrv (derivationsIn' root);
    operator = { key, value }: map keyDrv (immediateDependenciesOf value);
  });

  derivationsIn' = x:
    if !canEval x then []
    else if isDerivation x then optional (canEval x.drvPath) x
    else if isList x then concatLists (map derivationsIn' x)
    else if isAttrs x then concatLists (mapAttrsToList (n: v: derivationsIn' v) x)
    else [ ];

  keyDrv = drv: if canEval drv.drvPath then { key = drv.drvPath; value = drv; } else { };

  immediateDependenciesOf = drv:
    concatLists (mapAttrsToList (n: v: derivationsIn v) (removeAttrs drv ["meta" "passthru"]));

  derivationsIn = x:
    if !canEval x then []
    else if isDerivation x then optional (canEval x.drvPath) x
    else if isList x then concatLists (map derivationsIn x)
    else [ ];

  canEval = val: (builtins.tryEval val).success;

in uniqueUrls

# This expression returns a list of all fetchurl calls used by ‘expr’.

with import ../.. { };
with lib;

{ expr }:

let

  root = expr;

  uniqueUrls = map (x: x.file) (genericClosure {
    startSet = map (file: { key = file.url; inherit file; }) urls;
    operator = const [ ];
  });

  urls = map (drv: { url = head (drv.urls or [ drv.url ]); hash = drv.outputHash; isPatch = (drv?postFetch); type = drv.outputHashAlgo; name = drv.name; }) fetchurlDependencies;

  fetchurlDependencies =
    filter
      (drv: drv.outputHash or "" != "" && drv.outputHashMode or "flat" == "flat"
          && (drv ? url || drv ? urls))
      dependencies;

  dependencies = map (x: x.value) (genericClosure {
    startSet = map keyDrv (derivationsIn' root);
    operator = { key, value }: map keyDrv (immediateDependenciesOf value);
  });

  derivationsIn' = x:
    if !canEval x then []
    else if isDerivation x then optional (canEval x.drvPath) x
    else if isList x then concatLists (map derivationsIn' x)
    else if isAttrs x then concatLists (mapAttrsToList (n: v: addErrorContext "while finding tarballs in '${n}':" (derivationsIn' v)) x)
    else [ ];

  keyDrv = drv: if canEval drv.drvPath then { key = drv.drvPath; value = drv; } else { };

  immediateDependenciesOf = drv:
    concatLists (mapAttrsToList (n: v: derivationsIn v) (removeAttrs drv (["meta" "passthru"] ++ optionals (drv?passthru) (attrNames drv.passthru))));

  derivationsIn = x:
    if !canEval x then []
    else if isDerivation x then optional (canEval x.drvPath) x
    else if isList x then concatLists (map derivationsIn x)
    else [ ];

  canEval = val: (builtins.tryEval val).success;

in uniqueUrls

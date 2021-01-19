with import <nixpkgs> { };
with lib;

{ expr }:
let
  root = expr;

  urls = map
    (drv: drv.urls or [ drv.url ])
    urlDependencies;

  urlDependencies =
    filter
      (drv: isDerivation drv && (drv ? url || drv ? urls))
      dependencies;

  dependencies = map (x: x.value) (genericClosure {
    startSet = map keyDrv (derivationsIn' root);
    operator = { key, value }: map keyDrv (immediateDependenciesOf value);
  });

  derivationsIn' = x:
    if !canEval x then [ ]
    else if isDerivation x then optional (canEval x.drvPath) x
    else if isList x then concatLists (map derivationsIn' x)
    else if isAttrs x then concatLists (mapAttrsToList (n: v: addErrorContext "while finding tarballs in '${n}':" (derivationsIn' v)) x)
    else [ ];

  keyDrv = drv: if canEval drv.drvPath then { key = drv.drvPath; value = drv; } else { };

  immediateDependenciesOf = drv:
    concatLists (mapAttrsToList (n: v: derivationsIn v) (removeAttrs drv [ "meta" "passthru" ]));

  derivationsIn = x:
    if !canEval x then [ ]
    else if isDerivation x then optional (canEval x.drvPath) x
    else if isList x then concatLists (map derivationsIn x)
    else [ ];

  canEval = val: (builtins.tryEval val).success;

in
urls

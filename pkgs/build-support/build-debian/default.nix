{ pkgs
, builder ? pkgs.releaseTools.debBuild
, vm      ? (pkgs.vmTools.diskImageFuns.debian8x86_64 {})
}:

let
  makeArgs = pkg: {
    src         = if pkg ? src then pkg.src else pkg;
    name        = pkg.name;
    diskImage   = vm;
    extraDebs   = let
      bInputs = pkgs.lib.flatten pkg.buildInputs; # force to be list
      debList = builtins.map makeDebList bInputs;
    in
      pkgs.lib.flatten debList;
  };

  makeDebList = pkg:
  let
    root = makeArgs pkg;
    attrList = builtins.filter builtins.isAttrs pkg.buildInputs;
    mapf     =  p: makeDebList p;

    list = if pkg.buildInputs == null
      then [] 
      else builtins.map makeDebList attrList;
  in
    if pkg == null
    then []
    else [root] ++ pkgs.lib.flatten list;

  makeDeb = pkg:
  let
    list = makeDebList pkg;
  in
    assert (builtins.all builtins.isAttrs list);
    builtins.map builder list;

  debPackageFor = pkg: name: pkgs.buildEnv {
    inherit name;
    paths = makeDeb pkg;
  };
in
{
  inherit makeArgs makeDebList makeDeb debPackageFor;
}

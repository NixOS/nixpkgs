{ pkgs
, builder ? pkgs.releaseTools.debBuild
, vm      ? (pkgs.vmTools.diskImageFuns.debian8x86_64 {})
}:

let
  makeArgs = pkg: {
    meta.schedulingPriority = 50;
    memSize        = 2047;
    debRequires    = [];
    debMaintainer  = "No Body <no@bo.dy>";
    doInstallCheck = true;

    src            = if pkg ? src then pkg.src else pkg;
    name           = if pkg ? name then pkg.name else "noname-package";
    diskImage      = vm;
    extraDebs      =
      let
        asDebPackage = extrapkg:
        let
          name = if extrapkg ? name then extrapkg.name else "noname-package";
          filename = "${name}-0.0.0-1.amd64.deb";
        in
          "${(debPackageFor extrapkg "${name}").outPath}/debs/${filename}";
      in
      pkgs.lib.flatten (builtins.map asDebPackage (pkgs.lib.flatten pkg.buildInputs));
  };

  makeDebList = pkg:
  let
    root     = makeArgs pkg;
    attrList = if pkg ? buildInputs then builtins.filter builtins.isAttrs pkg.buildInputs else [];
    mapf     =  p: makeDebList p;

    list = if pkg ? buildInputs && pkg.buildInputs == null
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
    builtins.map builder (pkgs.lib.reverseList list);
  
  debPackageFor = pkg: name: pkgs.buildEnv {
    inherit name;
    paths = makeDeb pkg;
    pathsToLink = [ "/bin" ];
  };
in
{
  inherit makeArgs makeDebList makeDeb debPackageFor;
}

{
  lib ? import ../..,
  modules ? [ ],
}:

{
  inherit
    (lib.evalModules {
      inherit modules;
      specialArgs.modulesPath = ./.;
    })
    config
    options
    ;
}

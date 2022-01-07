
# DO NOT IMPORT. Use nixpkgsFlake.lib.nixos, or import (nixpkgs + "/nixos/lib")
{ lib }: # read -^

let

  /*
    Invoke NixOS. Unlike traditional NixOS, this does not include all modules.
    Any such modules have to be explicitly added via the `modules` parameter,
    or imported using `imports` in a module.

    A minimal module list improves NixOS evaluation performance and allows
    modules to be independently usable, supporting new use cases.

    Parameters:

      modules:        A list of modules that constitute the configuration.

      specialArgs:    An attribute set of module arguments. Unlike
                      `config._module.args`, these are available for use in
                      `imports`.
                      `config._module.args` should be preferred when possible.

    Return:

      An attribute set containing `config.system.build.toplevel` among other
      attributes. See `lib.evalModules` in the Nixpkgs library.

   */
  evalModules = {
    prefix ? [],
    modules ? [],
    specialArgs ? {},
  }: lib.evalModules {
    inherit prefix modules;
    specialArgs = {
      modulesPath = builtins.toString ../modules;
    } // specialArgs;
  };

in
{
  inherit evalModules;
}

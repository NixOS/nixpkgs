{
  lib,
  config,
  hostPkgs,
  options,
  ...
}:
let
  inherit (lib)
    mkOption
    optionalAttrs
    types
    ;

  # TODO (lib): Dedup with run.nix, add to lib/options.nix
  mkOneUp = opt: f: lib.mkOverride (opt.highestPrio - 1) (f opt.value);

  /**
    Return the package to test.

    # Inputs

    - `pkgs`: The package set to use if `config.packageOverride` is incompatible but not overridden.
  */
  getPackage =
    pkgs:
    if
      options.packageOverride.isDefined
      && config.node.pkgs.stdenv.hostPlatform.canExecute config.packageOverride.stdenv.hostPlatform
    then
      config.packageOverride
    else if
      options.defaultPackage.isDefined
      &&
        builtins.addErrorContext
          "while trying to figure out whether the package override for a NixOS test is the un-overridden package for the host package set, so that we can hopefully just pick the un-overridden package from the guest package set instead, to make things like nixosTests.foo work on non-Linux hosts"
          (config.packageOverride == config.defaultPackage config.hostPkgs)
    then
      config.defaultPackage pkgs
    else
      throw ''
        ${
          if options.defaultPackage.isDefined then
            "It seems that you are trying to run a NixOS test which is part of a package that has been overridden."
          else
            ''
              It seems that you are either

              a. trying to run a NixOS test which is part of a package that has been overridden.
              b. trying to run a package test on a non-overridden package, but the test does not have a `defaultPackage` definition.

              If it's the latter, you can fix it by adding a `defaultPackage` definition to the test file, like this:

                  {
                    imports = [ ./set-package.nix ]; # etc

                    name = "foo";
                    # add this line where foo is your default package attribute:
                    defaultPackage = pkgs: pkgs.foo;
                  }

              Otherwise, it seems that you are trying to run a test from an overriden package.''
        }
        This can be done - just not through the package `tests` attribute, because this package only knows about its own overrides, not the ones that should be applied to the Linux variation of it.
        You can construct the correct test, e.g.:

            let
              # Let's assume you have package sets like this:
              pkgsForLinux = nixpkgs { system = ...; }; # e.g. ${config.node.pkgs.stdenv.hostPlatform.system}
              nativePkgs = nixpkgs { system = ...; }; # e.g. ${hostPkgs.stdenv.hostPlatform.system}

              myOverrides = ...;

              # You just invoked something like myFoo.tests where
              #   myFoo = nativePkgs.foo.overrideAttrs myOverrides;
              # or it might have been:
              #   nativePkgs.nixosTests.foo.setPackage myFoo

              # Instead, create
              myFooForLinux = pkgsLinux.foo.overrideAttrs myOverrides;
            in
              # So that you can construct the correct test like this:
              nativePkgs.nixosTests.foo.setPackage myFooForLinux

        Or if you're defining the test file outside of Nixpkgs, it might look like this:

            (nativePkgs.testers.runNixOSTest ./foo-test.nix).setPackage myFooForLinux
      '';

in
{
  _class = "nixosTest";

  options = {
    defaultPackage = mkOption {
      description = ''
        The default package to test, given a `pkgs`.

        This is set by the test.
      '';
      type = types.functionTo types.package;
    };

    packageOverride = mkOption {
      internal = true;
      description = ''
        The package to test, given a `pkgs`.

        This is set by the `setPackage` attribute on the test returned by the test framework.
      '';
      type = types.raw;
    };

    setPackage = mkOption {
      description = ''
        Given a package, return a module that sets the package in NixOS.

        This option is set by the test.

        Its argument is the same as that of the `setPackage` function on the test returned by the test framework.
      '';
      type = types.functionTo types.deferredModule;
      example = lib.literalExpression ''
        pkg: { services.foo.package = pkg; }
      '';
    };

    node.package = mkOption {
      description = ''
        The package to test, taken from ${options.node.pkgs}.

        This is set by the test framework.
      '';
      type = types.package;
    };
  };
  config = {
    node.package = config.defaultPackage config.node.pkgs;

    passthru = {
      setPackage =
        getPkg:
        config.passthru.extend {
          modules = [
            {
              _file = ./set-package.nix;
              packageOverride = mkOneUp options.packageOverride (lib.toFunction getPkg);
            }
          ];
        };
    };
    extraBaseModules = optionalAttrs options.packageOverride.isDefined (
      { pkgs, ... }:
      {
        imports = [ (config.setPackage (getPackage pkgs)) ];
      }
    );
  };
}

{
  lib,
  callPackage,
  makeSetupHook,
  buildPackages,
  lunasvg,
}:

makeSetupHook {
  name = "pkg-config-check-hook";

  propagatedNativeBuildInputs = [ buildPackages.pkg-config ];

  substitutions = {
    pkgconfig = lib.getExe buildPackages.pkg-config;
  };

  passthru = {
    tests =
      lib.packagesFromDirectoryRecursive {
        inherit callPackage;
        directory = ./tests;
      }
      // {
        # few consumers that are good to test
        inherit lunasvg;
      };
  };

  meta = {
    description = "Validate pkg-config files";
    license = lib.licenses.mit;
  };
} ./pkgConfigCheckHook.sh

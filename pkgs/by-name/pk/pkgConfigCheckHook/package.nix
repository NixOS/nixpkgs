{
  lib,
  callPackage,
  makeSetupHook,
  pkg-config,
  lunasvg,
}:

makeSetupHook {
  name = "pkg-config-check-hook";

  # setupHooks go in nativeBuildInputs (or nativeInstallCheckInputs), so their
  # propagatedBuildInputs go into the consumers' nativeBuildInputs
  # see makeSetupHook docs
  propagatedBuildInputs = [ pkg-config ];

  substitutions = {
    pkgconfig = lib.getExe pkg-config;
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

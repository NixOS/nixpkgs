{
  lib,
  stdenv,
  glibcLocales,
  removeReferencesTo,
  graalvmPackages,
}:

lib.extendMkDerivation {
  constructDrv = stdenv.mkDerivation;

  excludeDrvArgNames = [
    "executable"
    "extraNativeImageBuildArgs"
    "graalvmDrv"
    "graalvmXmx"
    "nativeImageBuildArgs"
  ];

  extendDrvArgs =
    finalAttrs:
    {
      dontUnpack ? true,
      strictDeps ? true,
      __structuredAttrs ? true,

      # The GraalVM derivation to use
      graalvmDrv ? graalvmPackages.graalvm-ce,

      executable ? finalAttrs.meta.mainProgram,

      # Default native-image arguments. You probably don't want to set this,
      # except in special cases. In most cases, use extraNativeBuildArgs instead
      nativeImageBuildArgs ? [
        (lib.optionalString stdenv.hostPlatform.isDarwin "-H:-CheckToolchain")
        (lib.optionalString (
          stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isAarch64
        ) "-H:PageSize=64K")
        "-H:Name=${executable}"
        "-march=compatibility"
        "--verbose"
      ],

      # Extra arguments to be passed to the native-image
      extraNativeImageBuildArgs ? [ ],

      # XMX size of GraalVM during build
      graalvmXmx ? "-J-Xmx6g",

      env ? { },
      meta ? { },
      passthru ? { },
      ...
    }@args:
    {
      env = {
        LC_ALL = "en_US.UTF-8";
      }
      // env;

      inherit dontUnpack strictDeps __structuredAttrs;

      nativeBuildInputs = (args.nativeBuildInputs or [ ]) ++ [
        graalvmDrv
        glibcLocales
        removeReferencesTo
      ];

      # `nativeBuildInputs` does not allow `graalvmDrv`'s propagatedBuildInput to reach here this package.
      # As its `propagatedBuildInputs` is required for the build process with `native-image`, we must add it here as well.
      buildInputs = [ graalvmDrv ];

      nativeImageArgs = nativeImageBuildArgs ++ extraNativeImageBuildArgs ++ [ graalvmXmx ];

      buildPhase =
        args.buildPhase or ''
          runHook preBuild

          native-image -jar "$src" ''${nativeImageArgs[@]}

          runHook postBuild
        '';

      installPhase =
        args.installPhase or ''
          runHook preInstall

          install -Dm755 ${executable} -t $out/bin

          runHook postInstall
        '';

      postInstall = ''
        remove-references-to -t ${graalvmDrv} $out/bin/${executable}
        ${args.postInstall or ""}
      '';

      disallowedReferences = [ graalvmDrv ];

      passthru = {
        inherit graalvmDrv;
      }
      // passthru;

      meta = {
        # default to graalvm's platforms
        inherit (graalvmDrv.meta) platforms;
      }
      // meta;
    };
}

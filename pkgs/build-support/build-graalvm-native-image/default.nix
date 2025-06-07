# callPackage
{
  lib,
  stdenv,
  glibcLocales,
  removeReferencesTo,
  graalvmPackages,
}:

# buildGraalvmNativeImage
{
  pname,
  version,
  src,
  jar ? args.src,
  dontUnpack ? (jar == args.src),
  executable ? args.pname,

  # The GraalVM derivation to use
  graalvmDrv ? graalvmPackages.graalvm-ce,

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
  meta ? { },
  LC_ALL ? "en_US.UTF-8",
  ...
}@args:

let
  extraArgs = builtins.removeAttrs args [
    "pname"
    "version"
    "src"
    "jar"
    "dontUnpack"
    "LC_ALL"
    "meta"
    "buildPhase"
    "nativeBuildInputs"
    "installPhase"
    "postInstall"
  ];
in

lib.makeOverridable stdenv.mkDerivation {
  inherit
    pname
    version
    src
    jar
    dontUnpack
    ;

  env = { inherit LC_ALL; };

  nativeBuildInputs = (args.nativeBuildInputs or [ ]) ++ [
    graalvmDrv
    glibcLocales
    removeReferencesTo
  ];

  nativeImageBuildArgs = nativeImageBuildArgs ++ extraNativeImageBuildArgs ++ [ graalvmXmx ];

  buildPhase =
    args.buildPhase or ''
      runHook preBuild

      native-image -jar "$jar" ''${nativeImageBuildArgs[@]}

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

  passthru = { inherit graalvmDrv; };

  meta = {
    # default to graalvm's platforms
    platforms = graalvmDrv.meta.platforms;
    # default to executable name
    mainProgram = executable;
  } // meta;
}
// extraArgs

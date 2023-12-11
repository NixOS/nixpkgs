{ lib
, stdenv
, glibcLocales
  # The GraalVM derivation to use
, graalvmDrv
, removeReferencesTo
, executable ? args.pname
  # JAR used as input for GraalVM derivation, defaults to src
, jar ? args.src
, dontUnpack ? (jar == args.src)
  # Default native-image arguments. You probably don't want to set this,
  # except in special cases. In most cases, use extraNativeBuildArgs instead
, nativeImageBuildArgs ? [
    (lib.optionalString stdenv.isDarwin "-H:-CheckToolchain")
    (lib.optionalString (stdenv.isLinux && stdenv.isAarch64) "-H:PageSize=64K")
    "-H:Name=${executable}"
    "-march=compatibility"
    "--verbose"
    "-J-Dsun.stdout.encoding=UTF-8"
    "-J-Dsun.stderr.encoding=UTF-8"
  ]
  # Extra arguments to be passed to the native-image
, extraNativeImageBuildArgs ? [ ]
  # XMX size of GraalVM during build
, graalvmXmx ? "-J-Xmx6g"
, meta ? { }
, ...
} @ args:

let
  extraArgs = builtins.removeAttrs args [
    "lib"
    "stdenv"
    "glibcLocales"
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
stdenv.mkDerivation ({
  inherit dontUnpack jar;

  nativeBuildInputs = (args.nativeBuildInputs or [ ]) ++ [ graalvmDrv glibcLocales removeReferencesTo ];

  nativeImageBuildArgs = nativeImageBuildArgs ++ extraNativeImageBuildArgs ++ [ graalvmXmx ];

  buildPhase = args.buildPhase or ''
    runHook preBuild

    native-image -jar "$jar" ''${nativeImageBuildArgs[@]}

    runHook postBuild
  '';

  installPhase = args.installPhase or ''
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
} // extraArgs)

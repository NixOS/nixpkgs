{ lib, stdenv, graalvmCEPackages, glibcLocales }:

{ name ? "${args.pname}-${args.version}"
  # Final executable name
, executable ? args.pname
  # JAR used as input for GraalVM derivation, defaults to src
, jar ? args.src
, dontUnpack ? (jar == args.src)
  # Default native-image arguments. You probably don't want to set this,
  # except in special cases. In most cases, use extraNativeBuildArgs instead
, nativeImageBuildArgs ? [
    "-jar" jar
    "-H:CLibraryPath=${lib.getLib graalvm}/lib"
    (lib.optionalString stdenv.isDarwin "-H:-CheckToolchain")
    "-H:Name=${executable}"
    "--verbose"
  ]
  # Extra arguments to be passed to the native-image
, extraNativeImageBuildArgs ? [ ]
  # XMX size of GraalVM during build
, graalvmXmx ? "-J-Xmx6g"
  # The GraalVM to use
, graalvm ? graalvmCEPackages.graalvm11-ce
, meta ? { }
, ...
} @ args:

stdenv.mkDerivation (args // {
  inherit dontUnpack;

  nativeBuildInputs = (args.nativeBuildInputs or [ ]) ++ [ graalvm glibcLocales ];

  nativeImageBuildArgs = nativeImageBuildArgs ++ extraNativeImageBuildArgs ++ [ graalvmXmx ];

  buildPhase = args.buildPhase or ''
    runHook preBuild

    native-image ''${nativeImageBuildArgs[@]}

    runHook postBuild
  '';

  installPhase = args.installPhase or ''
    runHook preInstall

    install -Dm755 ${executable} -t $out/bin

    runHook postInstall
  '';

  meta = {
    # default to graalvm's platforms
    platforms = graalvm.meta.platforms;
    # default to executable name
    mainProgram = executable;
  } // meta;
})

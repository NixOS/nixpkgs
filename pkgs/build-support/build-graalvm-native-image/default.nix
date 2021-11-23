{ lib, stdenv, graalvmCEPackages, glibcLocales }:

{ name ? "${args.pname}-${args.version}"
  # Final executable name
, executable ? args.pname
  # JAR used as input for GraalVM derivation, defaults to src
, jar ? args.src
, dontUnpack ? (jar == args.src)
  # Extra arguments to be passed to the native-image
, extraNativeImageBuildArgs ? [ ]
  # XMX size of GraalVM during build
, graalvmXmx ? "-J-Xmx6g"
  # The GraalVM to use
, graalvm ? graalvmCEPackages.graalvm11-ce
, ...
} @ args:

stdenv.mkDerivation (args // {
  inherit dontUnpack;

  nativeBuildInputs = (args.nativeBuildInputs or [ ]) ++ [ graalvm glibcLocales ];

  nativeImageBuildArgs = lib.flatten ([
    "-jar"
    jar
    "-H:CLibraryPath=${lib.getLib graalvm}/lib"
    "${lib.optionalString stdenv.isDarwin "-H:-CheckToolchain"}"
    "-H:Name=${executable}"
    "--verbose"
    extraNativeImageBuildArgs
    graalvmXmx
  ]);

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

  meta.platforms = lib.attrByPath [ "meta" "platforms" ] graalvm.meta.platforms args;
  meta.mainProgram = lib.attrByPath [ "meta" "mainProgram" ] executable args;
})

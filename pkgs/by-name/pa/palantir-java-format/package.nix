{
  lib,
  stdenv,
  fetchFromGitHub,
  gradle,
  jdk21,
  graalvmPackages,
  nix-update-script,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "palantir-java-format";
  version = "2.97.0";

  src = fetchFromGitHub {
    owner = "palantir";
    repo = "palantir-java-format";
    rev = finalAttrs.version;
    hash = "sha256-d1zlznbWzRyP1djz9Hq7wHfzcEbSlTWz5Y0GTW8Ok1s=";
  };
  patches = [
    ./system-toolchains.patch
    ./remove-subprojects.patch
  ];

  # built-in detection tries to call ldd
  postPatch =
    let
      host = stdenv.hostPlatform;
      # https://github.com/palantir/gradle-utils/blob/develop/platform/src/main/java/com/palantir/platform/OperatingSystem.java
      os =
        if host.isDarwin then
          "MACOS"
        else if host.isWindows then
          "WINDOWS"
        else if host.isMusl then
          "LINUX_MUSL"
        else
          "LINUX_GLIBC";
      # https://github.com/palantir/gradle-utils/blob/develop/platform/src/main/java/com/palantir/platform/Architecture.java
      arch =
        if host.isx86_64 then
          "X86_64"
        else if host.isx86 then
          "X86"
        else if host.isAarch64 then
          "AARCH64"
        else
          throw "unsupported host architecture: ${host.parsed.cpu.arch}";
    in
    ''
      substituteInPlace palantir-java-format-native/build.gradle \
        --replace-fail 'OperatingSystem.get()' 'OperatingSystem.${os}' \
        --replace-fail 'Architecture.get()' 'Architecture.${arch}'
    '';

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [ gradle ];

  mitmCache = gradle.fetchDeps {
    inherit (finalAttrs) pname;
    data = ./deps.json;
  };
  # this is required for using mitm-cache on Darwin
  __darwinAllowLocalNetworking = true;
  # reachability metadata is required for building the native image
  gradleUpdateTask = "nixDownloadDeps collectReachabilityMetadata";

  # read by the build script
  env.CIRCLE_TAG = finalAttrs.version;

  gradleFlags = [
    "-Porg.gradle.java.installations.auto-download=false"
    "-Porg.gradle.java.installations.auto-detect=false"
    # The build wants both of these toolchains.
    # We patch the required language version of the GraalVM toolchain to match this package.
    "-Porg.gradle.java.installations.paths=${jdk21.home},${graalvmPackages.graalvm-ce.home}"
  ];
  gradleBuildTask = "nativeCompile";

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    install -T \
      palantir-java-format-native/build/native/nativeCompile/palantir-java-format-* \
      $out/bin/palantir-java-format

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Modern, lambda-friendly, 120 character Java formatter";
    homepage = "https://github.com/palantir/palantir-java-format";
    changelog = "https://github.com/palantir/palantir-java-format/releases/tag/${finalAttrs.version}";
    mainProgram = "palantir-java-format";
    license = lib.licenses.asl20;
    sourceProvenance = with lib.sourceTypes; [
      fromSource
      binaryBytecode # mitm cache
    ];
    platforms = [
      "aarch64-darwin"
      "aarch64-linux"
      "aarch64-windows"
      "i686-linux"
      "i686-windows"
      "x86_64-linux"
      "x86_64-windows"
    ];
    maintainers = with lib.maintainers; [ lunagl ];
  };
})

{
  stdenv,
  lib,
  fetchFromGitHub,
  gradle,
  openjdk,
  kotlin,
  nix-update-script,
  replaceVars,
  makeWrapper,
  graalvmPackages,
  buildNative ? true,
}:
let
  jdk = openjdk;
  sourceJdkVersion = "21";
  targetJdkVersion = lib.versions.major jdk.version;
  graalvmDir = graalvmPackages.graalvm-oracle_23;
  gradleOverlay = gradle.override { java = jdk; };
  kotlinOverlay = kotlin.override { jre = jdk; };
  binaries = {
    aarch64-darwin = "pkl-macos-aarch64";
    aarch64-linux = "pkl-linux-aarch64";
    x86_64-darwin = "pkl-macos-amd64";
    x86_64-linux = "pkl-linux-amd64";
    java = "jpkl";
  };
  inherit (stdenv.hostPlatform) system;
  nativeBuild = (builtins.hasAttr system binaries) && buildNative;
  binary = if nativeBuild then binaries.${system} else binaries.java;
  binaryPath = "./pkl-cli/build/executable/" + binary;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "pkl";
  version = "0.28.2";

  src = fetchFromGitHub {
    owner = "apple";
    repo = "pkl";
    tag = finalAttrs.version;
    hash = "sha256-ay3V3EWqZHncLH6UR4JOCChkweNcilDeskXzaeAFTR8=";
    leaveDotGit = true;
    postFetch = ''
      pushd $out
      git rev-parse HEAD | tr -d '\n' > .commit-hash
      rm -rf .git
      popd
    '';
  };

  patches =
    [
      (replaceVars ./fix_kotlin_classpath.patch { gradle = gradle.unwrapped; })
      ./disable_gradle_codegen_tests.patch
      ./disable_bad_tests.patch
    ]
    ++ (
      if nativeBuild then
        [
          (replaceVars ./use_nix_graalvm_instead_of_download.patch { inherit graalvmDir; })
        ]
      else
        [ ]
    );

  postPatch = ''
    substituteInPlace buildSrc/build.gradle.kts \
      --replace-fail "vendor = JvmVendorSpec.ADOPTIUM" "" \
      --replace-fail "toolchainVersion = ${sourceJdkVersion}" \
      "toolchainVersion = ${targetJdkVersion}"

    substituteInPlace buildSrc/src/main/kotlin/pklJavaLibrary.gradle.kts \
      --replace-fail "vendor = info.jdkVendor" ""

    substituteInPlace buildSrc/src/main/kotlin/BuildInfo.kt \
      --replace-fail "vendor.set(jdkVendor)" ""
  '';

  nativeBuildInputs = [
    gradleOverlay
    jdk
    kotlinOverlay
    makeWrapper
  ];

  mitmCache = gradle.fetchDeps {
    inherit (finalAttrs) pname;
    data = ./deps.json;
  };

  doCheck = !(stdenv.hostPlatform.isDarwin);

  gradleCheckTask = if nativeBuild then "testNative" else "test";

  gradleBuildTask = if nativeBuild then "assembleNative" else "assemble";

  gradleFlags = [
    "-s"
    "-x"
    "spotlessCheck"
    "-DreleaseBuild=true"
    "-Dorg.gradle.java.home=${jdk}"
    "-Porg.gradle.java.installations.auto-download=false"
    "-Porg.gradle.java.installations.auto-detect=false"
  ];

  preBuild = ''
    gradleFlagsArray+=(-DcommitId=$(cat .commit-hash))
  '';

  JAVA_TOOL_OPTIONS = "-Dfile.encoding=utf-8";
  __darwinAllowLocalNetworking = true;

  preCheck = ''
    export LANG=C.UTF-8
    export LC_ALL=C.UTF-8
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/bin" "$out/opt/pkl"
    if [ ${builtins.toString nativeBuild} ]; then
      install -Dm755 ${binaryPath} "$out/bin/pkl"
    else
      cp ${binaryPath} "$out/opt/pkl/jpkl.jar"
      makeWrapper ${lib.getExe jdk} $out/bin/pkl --add-flags "-jar $out/opt/pkl/jpkl.jar"
    fi

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Configuration-as-code language with rich validation and tooling";
    homepage = "https://pkl-lang.org";
    license = lib.licenses.asl20;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ hugolgst ];
    mainProgram = "pkl";
    sourceProvenance = with lib.sourceTypes; [
      fromSource
      binaryBytecode # mitm cache
    ];
  };
})

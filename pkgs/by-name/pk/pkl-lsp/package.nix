{
  lib,
  stdenv,
  fetchFromGitHub,
  gradle_9,
  jdk25_headless,
  makeBinaryWrapper,
  nix-update-script,
  versionCheckHook,
  zig,
}:

let
  jdk = jdk25_headless;
  gradle = gradle_9;
  gradleOverlay = gradle.override { java = jdk; };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "pkl-lsp";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "apple";
    repo = "pkl-lsp";
    tag = finalAttrs.version;
    hash = "sha256-V6MrDpdh4jnSiXWD0UbF/XXpLa95smCbdj9/jT0Xb3w=";
    leaveDotGit = true;
    postFetch = ''
      pushd $out
      git rev-parse HEAD | tr -d '\n' > .commit-hash
      rm -rf .git
      popd
    '';
  };

  # Dependencies for tree-sitter compilation specific versions from gradle/libs.versions.toml
  treeSitterSrc = fetchFromGitHub {
    owner = "tree-sitter";
    repo = "tree-sitter";
    rev = "v0.25.3";
    hash = "sha256-xafeni6Z6QgPiKzvhCT2SyfPn0agLHo47y+6ExQXkzE=";
  };
  treeSitterPklSrc = fetchFromGitHub {
    owner = "apple";
    repo = "tree-sitter-pkl";
    rev = "v0.20.0";
    hash = "sha256-HfZ2NwO466Le2XFP1LZ2fLJgCq4Zq6hVpjChzsIoQgA=";
  };

  postPatch = ''
    substituteInPlace buildSrc/src/main/kotlin/BuildInfo.kt \
      --replace-fail 'val jdkVersion: Int = 22' \
                     'val jdkVersion: Int = ${lib.versions.major jdk.version}' \
      --replace-fail 'val executable: Path get() = installDir.resolve(if (os.isWindows) "zig.exe" else "zig")' \
                     'val executable: Path get() = java.nio.file.Path.of("${lib.getExe zig}")' \

    substituteInPlace build.gradle.kts \
      --replace-fail 'dependsOn(setupTreeSitterRepo)' "" \
      --replace-fail 'dependsOn(setupTreeSitterPklRepo)' "" \
      --replace-fail 'dependsOn(tasks.named("installZig"))' ""

    # Ensure all pkl-cli platform variants are cached
    # Otherwise, deps.json only includes the current system's pkl-cli, and the tests fail
    cat >> build.gradle.kts << 'GRADLE_PATCH'
    val pklCliAllPlatforms by configurations.creating
    dependencies {
      for (platform in listOf("linux-amd64", "linux-aarch64", "macos-amd64", "macos-aarch64")) {
        pklCliAllPlatforms("org.pkl-lang:pkl-cli-$platform:''${libs.versions.pkl.get()}")
      }
    }
    GRADLE_PATCH

    mkdir -p build/repos/{tree-sitter,tree-sitter-pkl}
    cp -r $treeSitterSrc/* build/repos/tree-sitter/
    cp -r $treeSitterPklSrc/* build/repos/tree-sitter-pkl/
    chmod +w -R build/repos/{tree-sitter,tree-sitter-pkl}
  '';

  nativeBuildInputs = [
    gradleOverlay
    makeBinaryWrapper
    zig
  ];

  mitmCache = gradle.fetchDeps {
    inherit (finalAttrs) pname;
    data = ./deps.json;
  };

  __darwinAllowLocalNetworking = true;

  gradleFlags = [
    "-DreleaseBuild=true"
    "-Dfile.encoding=utf-8"
    "-Porg.gradle.java.installations.auto-download=false"
    "-Porg.gradle.java.installations.auto-detect=false"
  ];

  preBuild = ''
    gradleFlagsArray+=(-DcommitId=$(cat .commit-hash))
  '';

  # running the checkPhase replaces the .jar produced by the buildPhase, and leads to this error:
  # Exception in thread "main" java.lang.NoClassDefFoundError: kotlin/jvm/internal/Intrinsics
  # 	at org.pkl.lsp.cli.Main.main(Main.kt)
  # Caused by: java.lang.ClassNotFoundException: kotlin.jvm.internal.Intrinsics
  doCheck = false;

  postInstallCheck = ''
    gradle test
  '';

  installPhase = ''
    runHook preInstall

    install -D build/libs/pkl-lsp-${finalAttrs.version}.jar $out/lib/pkl-lsp/pkl-lsp.jar

    makeWrapper ${lib.getExe' jdk "java"} $out/bin/pkl-lsp \
      --add-flags "-jar $out/lib/pkl-lsp/pkl-lsp.jar"

    runHook postInstall
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "The Pkl Language Server";
    homepage = "https://pkl-lang.org/lsp/current/index.html";
    downloadPage = "https://github.com/apple/pkl-lsp";
    changelog = "https://pkl-lang.org/lsp/current/CHANGELOG.html#release-${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ ryota2357 ];
    mainProgram = "pkl-lsp";
    platforms = lib.lists.intersectLists (
      lib.platforms.x86_64 ++ lib.platforms.aarch64
    ) jdk.meta.platforms;
    sourceProvenance = with lib.sourceTypes; [
      fromSource
      binaryBytecode # mitm cache
      binaryNativeCode # mitm cache
    ];
  };
})

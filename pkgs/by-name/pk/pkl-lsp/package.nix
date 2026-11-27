{
  lib,
  stdenv,
  fetchFromGitHub,
  gradle_9,
  jdk25_headless,
  makeBinaryWrapper,
  versionCheckHook,
  zig_0_16,
  writeShellApplication,
  common-updater-scripts,
  nix,
  nix-update,
}:

let
  jdk = jdk25_headless;
  gradle = gradle_9;
  gradleOverlay = gradle.override { java = jdk; };
  zig = zig_0_16;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "pkl-lsp";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "apple";
    repo = "pkl-lsp";
    tag = finalAttrs.version;
    hash = "sha256-BMxftlafCAu1JHwPd4Wf706wRHwr2p+0eXHTXQctxRk=";
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
    rev = "v0.26.8";
    hash = "sha256-fcFEfoALrbpBD6rWogxJ7FNVlvDQgswoX9ylRgko+8Q=";
  };
  treeSitterPklSrc = fetchFromGitHub {
    owner = "apple";
    repo = "tree-sitter-pkl";
    rev = "v0.22.0";
    hash = "sha256-2quZj51vgNbqxWxEdwkqasPXUvz1+AXJOQI+byUU9q0=";
  };

  # - Remove pklSourceBundle, which is only used for upstream's native-image releases. Under the gradle setup hook,
  #   its tasks resolve the GraalVM/OpenJDK source tarballs while build.gradle.kts is still being evaluated, which fails the build.
  # - Exclude tests that need network access (download packages from pkg.pkl-lang.org) or run the pkl CLI
  #   (the prebuilt binary from Maven expects /lib64/ld-linux-*.so, so it can't run in the Linux sandbox).
  postPatch = ''
    substituteInPlace buildSrc/src/main/kotlin/BuildInfo.kt \
      --replace-fail 'val executable: Path get() = installDir.resolve(if (os.isWindows) "zig.exe" else "zig")' \
                     'val executable: Path get() = java.nio.file.Path.of("${lib.getExe zig}")' \

    substituteInPlace build.gradle.kts \
      --replace-fail 'pklSourceBundle' "" \
      --replace-fail 'dependsOn(setupTreeSitterRepo)' "" \
      --replace-fail 'dependsOn(setupTreeSitterPklRepo)' "" \
      --replace-fail 'dependsOn(tasks.installZig)' ""

    cat >> build.gradle.kts << 'EOF'
    tasks.test {
      filter {
        excludeTestsMatching("org.pkl.lsp.GoToDefinitionPackagesTest")
        excludeTestsMatching("org.pkl.lsp.SyncProjectsTest")
        excludeTestsMatching("org.pkl.lsp.completion.ModuleNameCompletionTest")
      }
    }
    EOF

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

  # Ensure all pkl-cli platform variants are cached. Otherwise, deps.json only includes the current system's pkl-cli, and the tests fail.
  preGradleUpdate = ''
    cat >> build.gradle.kts << 'GRADLE_PATCH'
    val pklCliAllPlatforms by configurations.creating
    dependencies {
      for (platform in listOf("linux-amd64", "linux-aarch64", "macos-aarch64")) {
        pklCliAllPlatforms("org.pkl-lang:pkl-cli-$platform:''${libs.versions.pkl.get()}")
      }
    }
    GRADLE_PATCH
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

  passthru.updateScript = lib.getExe (writeShellApplication {
    name = "pkl-lsp-update";
    runtimeInputs = [
      common-updater-scripts
      nix
      nix-update
    ];
    text = ''
      nix-update pkl-lsp

      src=$(nix-build --no-out-link -A pkl-lsp.src)
      for name in treeSitter treeSitterPkl; do
        newRev=$(nix eval --raw --impure --expr "(builtins.fromTOML (builtins.readFile $src/gradle/libs.versions.toml)).versions.''${name}Repo")
        oldRev=$(nix eval --raw --file . "pkl-lsp.''${name}Src.rev")
        if [[ $newRev != "$oldRev" ]]; then
          update-source-version pkl-lsp --source-key="''${name}Src" --rev="$newRev" --ignore-same-version
        fi
      done
    '';
  });

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

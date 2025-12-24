{
  lib,
  stdenv,
  fetchFromGitHub,
  gradle_9,
  jdk25_headless,
  makeBinaryWrapper,
  versionCheckHook,
  zig,
}:

let
  jdk = jdk25_headless;
  gradle = gradle_9.override { java = jdk; };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "pkl-lsp";
  version = "0.5.3";

  src = fetchFromGitHub {
    owner = "apple";
    repo = "pkl-lsp";
    tag = finalAttrs.version;
    hash = "sha256-mkOE1AqBADn9FBnBw1fWAPafNPKAIMMhzr2BCzZZf0E=";
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
      --replace-fail 'val jdkVersion: Int = 22' 'val jdkVersion: Int = 25' \
      --replace-fail 'val executable: Path get() = installDir.resolve(if (os.isWindows) "zig.exe" else "zig")' \
                     'val executable: Path get() = java.nio.file.Path.of("${lib.getExe zig}")' \
      --replace-fail 'val commitId: String by lazy {' 'val commitId: String = "0000000"; val _ignored: Any by lazy {'

    substituteInPlace build.gradle.kts \
      --replace-fail 'dependsOn(setupTreeSitterRepo)' "" \
      --replace-fail 'dependsOn(setupTreeSitterPklRepo)' ""

    mkdir -p build/repos/{tree-sitter,tree-sitter-pkl}
    cp -r $treeSitterSrc/* build/repos/tree-sitter/
    cp -r $treeSitterPklSrc/* build/repos/tree-sitter-pkl/
  '';

  nativeBuildInputs = [
    gradle
    makeBinaryWrapper
    zig.hook
  ];

  mitmCache = gradle.fetchDeps {
    inherit (finalAttrs) pname;
    data = ./deps.json;
  };

  __darwinAllowLocalNetworking = true;

  gradleFlags = [
    "-DreleaseBuild=true"
    "-Porg.gradle.java.installations.auto-download=false"
    "-Porg.gradle.java.installations.auto-detect=false"
  ];

  JAVA_TOOL_OPTIONS = "-Dfile.encoding=utf-8";

  # prevent zig hook from overriding buildPhase
  dontUseZigBuild = true;
  dontUseZigCheck = true;
  dontUseZigInstall = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,lib/pkl-lsp}
    cp build/libs/pkl-lsp-*.jar $out/lib/pkl-lsp/pkl-lsp.jar

    makeWrapper ${lib.getExe jdk} $out/bin/pkl-lsp \
      --add-flags "-jar $out/lib/pkl-lsp/pkl-lsp.jar"

    runHook postInstall
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  meta = {
    description = "The Pkl Language Server";
    homepage = "https://github.com/apple/pkl-lsp";
    changelog = "https://pkl-lang.org/lsp/current/CHANGELOG.html#release-${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ ryota2357 ];
    mainProgram = "pkl-lsp";
    platforms = lib.platforms.all;
    sourceProvenance = with lib.sourceTypes; [
      fromSource
      binaryBytecode # mitm cache
    ];
  };
})

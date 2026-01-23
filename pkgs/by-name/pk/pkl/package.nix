{
  stdenv,
  lib,
  fetchFromGitHub,
  gradle,
  temurin-bin-21,
  kotlin,
  nix-update-script,
  replaceVars,
  makeWrapper,
  installShellFiles,
}:
let
  jdk = temurin-bin-21;
  gradleOverlay = gradle.override { java = jdk; };
  kotlinOverlay = kotlin.override { jre = jdk; };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "pkl";
  version = "0.29.1";

  src = fetchFromGitHub {
    owner = "apple";
    repo = "pkl";
    tag = finalAttrs.version;
    hash = "sha256-vel4Il/muHd4wqV5tfMPwBHoxgei8vPcnk2kS2/XG3I=";
    leaveDotGit = true;
    postFetch = ''
      pushd $out
      git rev-parse HEAD | tr -d '\n' > .commit-hash
      rm -rf .git
      popd
    '';
  };

  patches = [
    (replaceVars ./fix_kotlin_classpath.patch { gradle = gradle.unwrapped; })
    ./disable_gradle_codegen_tests.patch
    ./disable_bad_tests.patch
  ];

  nativeBuildInputs = [
    gradleOverlay
    jdk
    kotlinOverlay
    makeWrapper
    installShellFiles
  ];

  mitmCache = gradle.fetchDeps {
    inherit (finalAttrs) pname;
    data = ./deps.json;
  };

  doCheck = !(stdenv.hostPlatform.isDarwin);

  gradleFlags = [
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
    cp ./pkl-cli/build/executable/jpkl "$out/opt/pkl/jpkl.jar"

    makeWrapper ${lib.getExe jdk} $out/bin/pkl --add-flags "-jar $out/opt/pkl/jpkl.jar"

    ${lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
      installShellCompletion --cmd pkl \
        --bash <($out/bin/pkl shell-completion bash) \
        --zsh <($out/bin/pkl shell-completion zsh) \
        --fish <($out/bin/pkl shell-completion fish)
    ''}

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

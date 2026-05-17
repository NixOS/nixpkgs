{
  lib,
  stdenv,
  fetchFromGitHub,
  writeShellScript,
  nix-update,
  ## backend
  gradle_9,
  makeWrapper,
  temurin-jre-bin-25,
  jdk25_headless,
  libarchive,
  libepubgen,
  ffmpeg-headless,
  kepubify,
  ## frontend
  nodejs_24,
  pnpm,
  fetchPnpmDeps,
  pnpmConfigHook,
}:
let
  version = "3.2.4";
  gradle = gradle_9;
  src = fetchFromGitHub {
    owner = "grimmory-tools";
    repo = "grimmory";
    tag = "v${version}";
    hash = "sha256-RiERszsb/oGsXja6EWoGSVGQ0T2KIfWBXqnDOFcoiQU=";
  };
  meta = {
    description = "Grimmory is a self-hosted digital library for people who take their reading seriously.";
    homepage = "https://grimmory.org";
    maintainers = [ lib.maintainers.kraftnix ];
    license = lib.licenses.agpl3Only;
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
  };

  grimmory-frontend = stdenv.mkDerivation (finalAttrs: {
    pname = "grimmory-frontend";
    inherit version src;

    strictDeps = true;
    __structuredAttrs = true;

    pnpmDeps = fetchPnpmDeps {
      inherit (finalAttrs) pname version src;
      inherit pnpm;
      fetcherVersion = 4;
      hash = "sha256-S/Q4+kSOIrL7JSebH0XWGCCMaegre9Fx63RbuIs5P9s=";
    };

    nativeBuildInputs = [
      nodejs_24
      pnpm
      pnpmConfigHook
    ];

    env.NG_CLI_ANALYTICS = "false";
    env.CI = "1";

    buildPhase = ''
      runHook preBuild

      pnpm -C frontend run build:prod

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      mkdir $out
      cp -rv frontend/dist/grimmory/browser/* $out/

      runHook postInstall
    '';

    inherit meta;
  });

in
stdenv.mkDerivation (finalAttrs: {
  pname = "grimmory";
  inherit version;

  src = "${src}/backend";

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [
    gradle
    makeWrapper
    jdk25_headless
    grimmory-frontend
  ];

  buildInputs = [
    ffmpeg-headless
    kepubify
    libarchive
    libepubgen
  ];

  mitmCache = gradle.fetchDeps {
    inherit (finalAttrs) pname;
    data = ./deps.json;
  };

  env.APP_VERSION = finalAttrs.version;
  env.APP_REVISION = "nix";

  gradleBuildTask = "bootJar";

  gradleFlags = [
    "-Dorg.gradle.java.home=${jdk25_headless.home}"
    "-Dfile.encoding=utf-8"
    # NOTE: this doesn't correctly embed the frontend
    "-DfrontendDistDir=${grimmory-frontend}"
  ];

  installPhase = ''
    mkdir -p $out/{bin,share/grimmory}
    cp build/libs/backend-${finalAttrs.version}.jar $out/share/grimmory/grimmory.jar

    makeWrapper ${lib.getExe temurin-jre-bin-25} $out/bin/grimmory \
      --set APP_VERSION ${finalAttrs.env.APP_VERSION} \
      --set APP_REVISION ${finalAttrs.env.APP_REVISION} \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath finalAttrs.buildInputs}" \
      --add-flags "-Djava.library.path=${lib.makeLibraryPath finalAttrs.buildInputs}" \
      --add-flags "--enable-native-access=ALL-UNNAMED --enable-preview -jar $out/share/grimmory/grimmory.jar"
  '';

  passthru.grimmory-frontend = grimmory-frontend;

  passthru.updateScript = writeShellScript "update-grimmory" ''
    ${lib.getExe nix-update} grimmory --src-only
    ${lib.getExe nix-update} --subpackage grimmory-frontend grimmory --no-src
    $(nix-build -A grimmory.mitmCache.updateScript)
  '';

  passthru.src = src;

  meta = meta // {
    mainProgram = "grimmory";
    sourceProvenance = with lib.sourceTypes; [
      fromSource
      binaryBytecode # mitm cache
    ];
  };
})

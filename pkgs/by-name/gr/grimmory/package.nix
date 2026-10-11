{
  lib,
  stdenv,
  fetchFromGitHub,
  writeShellScript,
  nix-update,
  nixosTests,
  callPackage,
  gradle_9,
  makeWrapper,
  temurin-jre-bin-25,
  jdk25_headless,
  libarchive,
  libepubgen,
  ffmpeg-headless,
  kepubify,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "grimmory";
  version = "3.5.0";
  src = fetchFromGitHub {
    owner = "grimmory-tools";
    repo = "grimmory";
    tag = "v${finalAttrs.version}";
    hash = "sha256-j9VXtqWLc13qVn89T1OmLQcAlhTP4w8AmOZINqhtNa4=";
  };

  patches = [
    # gradle.fetchDeps fetches jacoco 0.8.15 instead of 0.8.14
    ./patch-jacoco-version.patch
  ];

  sourceRoot = "${finalAttrs.src.name}/backend";

  frontend = callPackage ./frontend.nix {
    inherit (finalAttrs) src version;
  };

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [
    gradle_9
    makeWrapper
    jdk25_headless
  ];

  buildInputs = [
    ffmpeg-headless
    kepubify
    libarchive
    libepubgen
  ];

  mitmCache = gradle_9.fetchDeps {
    # inherit (finalAttrs) pname;
    pkg = finalAttrs.finalPackage;
    data = ./deps.json;
  };

  __darwinAllowLocalNetworking = true;

  env.APP_VERSION = finalAttrs.version;
  env.APP_REVISION = "nix";

  gradleBuildTask = "bootJar";

  gradleFlags = [
    "-Dorg.gradle.java.home=${jdk25_headless.home}"
    "-Dfile.encoding=utf-8"
  ];

  preConfigure = ''
    cp -r ${finalAttrs.frontend} frontend-dist
    chmod -R u+w frontend-dist
    gradleFlagsArray+=("-PfrontendDistDir=$PWD/frontend-dist")
  '';

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

  passthru.updateScript = writeShellScript "update-grimmory" ''
    ${lib.getExe nix-update} grimmory --subpackage frontend
    $(nix-build -A grimmory.mitmCache.updateScript --no-out-link)
  '';

  passthru.tests = {
    inherit (nixosTests) grimmory;
  };

  meta = {
    description = "Grimmory is a self-hosted library for your ebooks, comics and audiobooks.";
    homepage = "https://grimmory.org";
    mainProgram = "grimmory";
    maintainers = [ lib.maintainers.kraftnix ];
    license = lib.licenses.agpl3Only;
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
    sourceProvenance = with lib.sourceTypes; [
      fromSource
      binaryBytecode # mitm cache
    ];
  };
})

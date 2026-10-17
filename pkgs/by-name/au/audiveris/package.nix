{
  stdenv,
  lib,
  fetchFromGitHub,
  makeWrapper,
  copyDesktopItems,
  makeDesktopItem,
  gradle_8,
  graphicsmagick,
  jre,
  tesseract,
  freetype,
  testers,
  audiveris,
}:
let
  # Deprecated Gradle features were used in this build, making it incompatible with Gradle 9.0.
  gradle = gradle_8;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "audiveris";
  version = "5.5.3";

  src = fetchFromGitHub {
    owner = "Audiveris";
    repo = "audiveris";
    tag = finalAttrs.version;
    hash = "sha256-GRKyQ+DqappqkbKuq5U+4ls96vdpPGPUGRHELjzfyo8=";
  };

  nativeBuildInputs = [
    gradle
    graphicsmagick
    makeWrapper
    copyDesktopItems
  ];

  mitmCache = gradle.fetchDeps {
    inherit (finalAttrs) pname;
    data = ./deps.json;
  };

  __darwinAllowLocalNetworking = true; # required for mitm-cache on Darwin

  gradleFlags = [
    "-Dfile.encoding=utf-8"

    # The Audiveris build assumes a git checkout.
    # The flags below will make it work with the tarball, too.
    "-PprogramBuild=nixpkgs"
    "-x=getCommit"
    "-x=getCommitShort"
  ];

  doCheck = true;

  dontStrip = true;

  desktopItems = [
    (makeDesktopItem {
      name = "audiveris";
      desktopName = "Audiveris Music Scanner";
      genericName = "Optical Music Recognition";
      type = "Application";
      exec = "audiveris";
      icon = "audiveris";
      terminal = false;
      keywords = [ "OMR" ];
      categories = [ "Audio" ];
    })
  ];

  installPhase = ''
    runHook preInstall

    echo 'gradle.projectsLoaded {
      rootProject.allprojects {
        afterEvaluate {
          if (it.path == ":app") {
            tasks.register("writeClasspathFile") {
              file("classpath.txt").text =
                configurations.runtimeClasspath.files.collect { it.name }.join("\n")
            }
          }
        }
      }
    }' >writeClasspathFile.gradle
    gradle -q --init-script writeClasspathFile.gradle writeClasspathFile

    mkdir -p -- "$out"
    tar xC "$out" \
      -f 'app/build/distributions/app-${finalAttrs.version}.tar' \
      --transform 's|^app-${finalAttrs.version}/lib|share/java|' \
      'app-${finalAttrs.version}/lib/'

    mapfile -t jars <classpath.txt
    cp="$out/share/java/audiveris.jar"
    for jar in "''\${jars[@]}"; do
      cp+=":$out/share/java/$jar"
    done

    makeWrapper ${lib.getExe jre} $out/bin/audiveris \
      --set-default TESSDATA_PREFIX '${tesseract}/share/tessdata' \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [ freetype ]}" \
      --add-flags "-cp '$cp' Audiveris"

    install -D -m0644 app/res/icon-64.png "$out/share/icons/hicolor/64x64/apps/audiveris.png"
    for size in 16 24 32 48; do
      # set modify/create for reproducible builds
      gm convert app/res/icon-64.png -scale $size +set date:create +set date:modify icon.png
      install -D -m0644 icon.png "$out/share/icons/hicolor/''${size}x$size/apps/audiveris.png"
    done
    unset size

    runHook postInstall
  '';

  passthru.tests.version = testers.testVersion {
    package = audiveris;
    command = "audiveris -help";
    # The suffix after the colon originates from -PprogramBuild
    version = "${finalAttrs.version}:nixpkgs";
  };

  meta = {
    homepage = "https://audiveris.github.io/audiveris/";
    description = "Open-source Optical Music Recognition";
    sourceProvenance = with lib.sourceTypes; [
      fromSource
      binaryBytecode # mitm cache
    ];
    mainProgram = "audiveris";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [ twz123 ];
  };
})

{
  stdenvNoCC,
  lib,
  fetchFromGitHub,
  makeBinaryWrapper,
  makeDesktopItem,
  jdk17,
  gradle_9,
  which,
  copyDesktopItems,
  fetchpatch,
}:

let
  pname = "freeplane";
  version = "1.13.2";

  jdk = jdk17;
  gradle = gradle_9;

  src = fetchFromGitHub {
    owner = "freeplane";
    repo = "freeplane";
    rev = "release-${version}";
    hash = "sha256-NDji6psNXESAY5NWI/Ms63MTgbxZHiIxYAgOSkWHuK0=";
  };

in
stdenvNoCC.mkDerivation (finalAttrs: {
  inherit pname version src;

  patches = [
    # Gradle 9.5 compatibility. Remove on next version bump.
    (fetchpatch {
      url = "https://github.com/freeplane/freeplane/commit/34189b58bbdf0027185a212e2d6bd9e289782ef2.patch";
      hash = "sha256-gVCKXme+pB7PV0yBoDMPg6ltCaTGYh1lspEKgwVkDgc=";
    })
  ];

  nativeBuildInputs = [
    makeBinaryWrapper
    jdk
    gradle
    copyDesktopItems
  ];

  mitmCache = gradle.fetchDeps {
    inherit pname;
    data = ./deps.json;
  };

  gradleFlags = [
    "-Dorg.gradle.java.home=${jdk}"
    "-x"
    "test"
  ];

  # share/freeplane/core/org.freeplane.core/META-INF doesn't
  # always get generated with parallel building enabled
  enableParallelBuilding = false;

  preBuild = "mkdir -p freeplane/build";

  gradleBuildTask = "build";

  desktopItems = [
    (makeDesktopItem {
      name = "freeplane";
      desktopName = "freeplane";
      genericName = "Mind-mapper";
      exec = "freeplane";
      icon = "freeplane";
      comment = finalAttrs.meta.description;
      mimeTypes = [
        "application/x-freemind"
        "application/x-freeplane"
        "text/x-troff-mm"
      ];
      categories = [
        "2DGraphics"
        "Chart"
        "Graphics"
        "Office"
      ];
    })
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share
    cp -a ./BIN/. $out/share/freeplane

    makeWrapper $out/share/freeplane/freeplane.sh $out/bin/freeplane \
      --set FREEPLANE_BASE_DIR $out/share/freeplane \
      --set JAVA_HOME ${jdk} \
      --prefix PATH : ${
        lib.makeBinPath [
          jdk
          which
        ]
      } \
      --prefix _JAVA_AWT_WM_NONREPARENTING : 1 \
      --prefix _JAVA_OPTIONS " " "-Dawt.useSystemAAFontSettings=gasp"

    runHook postInstall
  '';

  meta = {
    description = "Mind-mapping software";
    homepage = "https://freeplane.org/";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    maintainers = [ ];
    mainProgram = "freeplane";
  };
})

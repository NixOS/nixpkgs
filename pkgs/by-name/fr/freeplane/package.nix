{
  stdenvNoCC,
  lib,
  fetchFromGitHub,
  fetchpatch,
  makeBinaryWrapper,
  makeDesktopItem,
  jdk17,
  gradle_8,
  which,
  copyDesktopItems,
}:

let
  pname = "freeplane";
  version = "1.12.10";

  jdk = jdk17;
  gradle = gradle_8;

  src = fetchFromGitHub {
    owner = "freeplane";
    repo = "freeplane";
    rev = "release-${version}";
    hash = "sha256-08Rl3vhXtlylNDc1gh5aZJ9/RoxeyxpDbklmhMVJuq4=";
  };

in
stdenvNoCC.mkDerivation (finalAttrs: {
  inherit pname version src;

  nativeBuildInputs = [
    makeBinaryWrapper
    jdk
    gradle
    copyDesktopItems
  ];

  patches = [
    # freeplane is using the wrong repository for a plugin
    # remove when https://github.com/freeplane/freeplane/pull/2453 is merged and released
    (fetchpatch {
      url = "https://github.com/amadejkastelic/freeplane/commit/973c49b7a73622e434bb86c8caea15383201b58a.patch";
      hash = "sha256-iztFmISXZu8xKWqpwDYgBSl8ZSpZEtNriwM+EW1+s+Y=";
    })
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
      --prefix _JAVA_OPTIONS : "-Dawt.useSystemAAFontSettings=on"

    runHook postInstall
  '';

  meta = {
    description = "Mind-mapping software";
    homepage = "https://freeplane.org/";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ chaduffy ];
    mainProgram = "freeplane";
  };
})

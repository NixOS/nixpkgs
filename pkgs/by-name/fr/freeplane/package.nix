{
  stdenvNoCC,
  lib,
  fetchFromGitHub,
  makeBinaryWrapper,
  makeDesktopItem,
  jdk17,
  gradle_7,
  which,
}:

let
  pname = "freeplane";
  version = "1.11.14";

  jdk = jdk17;
  gradle = gradle_7;

  src = fetchFromGitHub {
    owner = "freeplane";
    repo = "freeplane";
    rev = "release-${version}";
    hash = "sha256-zEQjB57iiKVQnH8VtynpEGKNAa2e+WpqnGt6fnv5Rjs=";
  };

in
stdenvNoCC.mkDerivation (finalAttrs: {
  inherit pname version src;

  nativeBuildInputs = [
    makeBinaryWrapper
    jdk
    gradle
  ];

  mitmCache = gradle.fetchDeps {
    inherit pname;
    data = ./deps.json;
  };

  gradleFlags = [ "-Dorg.gradle.java.home=${jdk}" "-x" "test" ];

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

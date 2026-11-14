{
  lib,
  stdenv,
  fetchFromGitea,

  ant,
  jdk8,
  stripJavaArchivesHook,
  makeBinaryWrapper,

  jna,
  xorg,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "spamton-shimeji";
  version = "1.05-unstable-2022-10-21";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "thatonecalculator";
    repo = "spamton-linux-shimeji";
    rev = "d967d78e13e12e2bf59f20c1a66c7f64d8d9310e";
    hash = "sha256-PNQZE4/RJ6C6qhAabMrbqEsYri0+GzbcwepCC6hMf1c=";
  };

  nativeBuildInputs = [
    ant
    jdk8
    stripJavaArchivesHook
    makeBinaryWrapper
  ];

  buildInputs = [
    jna
  ];

  postPatch = ''
    # No spaces in command line arguments
    substituteInPlace build.xml \
      --replace-fail "lines, vars, source" "lines,vars,source"

    # Long deprecated since JNA 3.2, removed since 4.x
    substituteInPlace src_x11/com/group_finity/mascot/x11/X11TranslucentWindow.java \
      --replace-fail "getSize()" "size()"
  '';

  buildPhase = ''
    runHook preBuild
    ant
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -D Shimeji.jar -t $out/share/java
    cp -r conf img $out/share/java
    install -D desktop/Spamton.desktop -t $out/share/applications
    install -D desktop/spamton.png -t $out/share/icons/hicolor/128x128/apps

    makeWrapper ${lib.getExe jdk8} $out/bin/spamton \
      --add-flags "-cp $out/share/java/Shimeji.jar:$CLASSPATH com.group_finity.mascot.Main" \
      --prefix LD_LIBRARY_PATH : ${
        lib.makeLibraryPath [
          xorg.libX11
          xorg.libXrender
        ]
      }

    runHook postInstall
  '';

  meta = {
    description = "Desktop mascot program";
    homepage = "https://codeberg.org/thatonecalculator/spamton-linux-shimeji";
    # Custom free license; see https://codeberg.org/thatonecalculator/spamton-linux-shimeji/src/branch/master/LICENSE
    license = with lib.licenses; [ free ];
    platforms = lib.intersectLists lib.platforms.linux jdk8.meta.platforms;
    maintainers = with lib.maintainers; [ pluiedev ];
    mainProgram = "spamton";
  };
})

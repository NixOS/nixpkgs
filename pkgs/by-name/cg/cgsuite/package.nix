{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchurl,
  makeBinaryWrapper,
  autoPatchelfHook,
  unzip,
  ant,
  jdk17,
  jdk17_headless,
  maven,
  withGui ? true,
}:

let
  version = "2.1.1";
  jfxVersion = "17.0.6";

  src = fetchFromGitHub {
    owner = "aaron-siegel";
    repo = "cgsuite";
    tag = "v${version}";
    hash = "sha256-Qm/0awaosDWLBQAmKAegx1CNaWj7ngRDaGaOdMAS/cM=";
  };

  coreLib = maven.buildMavenPackage {
    pname = "cgsuite-core";
    inherit version src;

    mvnParameters = "-f lib/core/pom.xml";
    mvnHash = "sha256-FlvrQS8e/jktLJQcLLLpfMly4BAy4h3JDbdDoNA1bk0=";
    mvnJdk = jdk17;

    # The post-build step reads a banner file containing non-ASCII characters
    env.LANG = "C.UTF-8";
    mvnFetchExtraArgs.env.LANG = "C.UTF-8";

    nativeBuildInputs = [
      maven
      jdk17
    ];

    installPhase = ''
      runHook preInstall
      install -Dm644 lib/core/target/cgsuite-core-${version}-jar-with-dependencies.jar \
        $out/share/java/cgsuite-core.jar
      runHook postInstall
    '';
  };

  jfxBundle = maven.buildMavenPackage {
    pname = "cgsuite-jfx-bundle";
    inherit version src;

    mvnParameters = "-f lib/jfx-bundle/pom.xml -Djfx.classifier=linux";
    mvnHash = "sha256-Hw2vWaGvsfkuh2kNk0sujtA8vnE4oZ2YloKg0pUFpkY=";
    mvnJdk = jdk17;

    nativeBuildInputs = [
      maven
      jdk17
    ];

    installPhase = ''
      runHook preInstall
      install -Dm644 lib/jfx-bundle/target/cgsuite-jfx-bundle-${jfxVersion}-jar-with-dependencies.jar \
        $out/cgsuite-jfx-bundle.jar
      runHook postInstall
    '';

    doCheck = false;
  };

  netbeansPlatform = fetchurl {
    url = "https://archive.apache.org/dist/netbeans/netbeans/17/netbeans-17-bin.zip";
    hash = "sha256-UYhWAC2O2aZmF6OAyHfaxnrF6SsXchBhKGGeT55FZJM=";
  };

  replJdk = if withGui then jdk17 else jdk17_headless;
in
stdenv.mkDerivation {
  pname = "cgsuite";
  inherit version src;

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [
    makeBinaryWrapper
  ]
  ++ lib.optionals withGui [
    ant
    jdk17
    unzip
    autoPatchelfHook
  ];

  buildInputs = lib.optionals withGui [
    stdenv.cc.cc.lib
    jdk17
  ];

  # Copy missing boilerplate
  postPatch = lib.optionalString withGui ''
    cp desktop-app/CGSuiteCoreLib/nbproject/build-impl.xml desktop-app/JavaFX/nbproject/build-impl.xml

    substituteInPlace desktop-app/build.xml \
      --replace-fail 'cgsuite-jfx-bundle-mac-''${cgsuite.jfx.version}' 'cgsuite-jfx-bundle-${jfxVersion}'
  '';

  dontConfigure = true;

  dontBuild = !withGui;

  buildPhase = lib.optionalString withGui ''
    runHook preBuild

    mkdir -p netbeans-platform
    unzip -q ${netbeansPlatform} -d netbeans-platform

    mkdir -p lib/core/target lib/jfx-bundle/target
    install -m644 ${coreLib}/share/java/cgsuite-core.jar \
      lib/core/target/cgsuite-core-${version}-jar-with-dependencies.jar
    install -m644 ${jfxBundle}/cgsuite-jfx-bundle.jar \
      lib/jfx-bundle/target/cgsuite-jfx-bundle-${jfxVersion}-jar-with-dependencies.jar

    cd desktop-app
    ant \
      -Dnbplatform.default.netbeans.dest.dir="$(pwd)/../netbeans-platform/netbeans" \
      -Dnbplatform.default.harness.dir="$(pwd)/../netbeans-platform/netbeans/harness" \
      suite.build-zip
    cd ..

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -Dm644 ${coreLib}/share/java/cgsuite-core.jar $out/share/java/cgsuite-core.jar

    makeWrapper ${replJdk}/bin/java $out/bin/cgsuite \
      --add-flags "-cp $out/share/java/cgsuite-core.jar org.cgsuite.lang.Repl"
  ''
  + lib.optionalString withGui ''
    mkdir -p $out/share/cgsuite-gui
    unzip -q desktop-app/dist/CGSuite.zip -d $out/share/cgsuite-gui
    rm -f $out/share/cgsuite-gui/CGSuite/bin/CGSuite.exe $out/share/cgsuite-gui/CGSuite/bin/CGSuite64.exe

    substituteInPlace $out/share/cgsuite-gui/CGSuite/etc/CGSuite.conf \
      --replace-fail 'jdkhome=jre' 'jdkhome=${jdk17}'

    # Fix for blank window at tiling window managers
    makeWrapper $out/share/cgsuite-gui/CGSuite/bin/CGSuite $out/bin/cgsuite-gui \
      --set _JAVA_AWT_WM_NONREPARENTING 1
  ''
  + ''
    runHook postInstall
  '';

  # libjawt.so lives two levels deep in the JDK output, past where autoPatchelfHook looks by default
  preFixup = lib.optionalString withGui ''
    addAutoPatchelfSearchPath ${jdk17}/lib/openjdk/lib
  '';

  meta = {
    description = "Computer algebra system for research in combinatorial game theory";
    homepage = "https://www.cgsuite.org/";
    changelog = "https://github.com/aaron-siegel/cgsuite/releases/tag/v${version}";
    license = lib.licenses.gpl3Only;
    sourceProvenance =
      with lib.sourceTypes;
      [
        fromSource
      ]
      ++ lib.optionals withGui [
        # From NetBeans Rich Client Platform
        binaryNativeCode
      ];
    mainProgram = if withGui then "cgsuite-gui" else "cgsuite";
    maintainers = with lib.maintainers; [ t4ccer ];
    platforms = if withGui then lib.platforms.linux else jdk17_headless.meta.platforms;
  };
}

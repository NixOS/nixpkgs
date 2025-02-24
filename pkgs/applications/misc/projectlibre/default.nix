{
  lib,
  stdenv,
  fetchgit,
  ant,
  jdk,
  stripJavaArchivesHook,
  makeWrapper,
  jre,
  coreutils,
  which,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "projectlibre";
  version = "1.9.3";

  src = fetchgit {
    url = "https://git.code.sf.net/p/projectlibre/code";
    rev = "20814e88dc83694f9fc6780c2550ca5c8a87aa16"; # version 1.9.3 was not tagged
    hash = "sha256-yXgYyy3jWxYMXKsNCRWdO78gYRmjKpO9U5WWU6PtwMU=";
  };

  nativeBuildInputs = [
    ant
    jdk
    stripJavaArchivesHook
    makeWrapper
  ];

  runtimeDeps = [
    jre
    coreutils
    which
  ];

  env.JAVA_TOOL_OPTIONS = "-Dfile.encoding=UTF8";

  buildPhase = ''
    runHook preBuild
    ant -f projectlibre_build/build.xml
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/{projectlibre/samples,doc/projectlibre}

    pushd projectlibre_build
    cp -R dist/* $out/share/projectlibre
    cp -R license $out/share/doc/projectlibre
    cp -R resources/samples/* $out/share/projectlibre/samples
    install -Dm644 resources/projectlibre.desktop -t $out/share/applications
    install -Dm644 resources/projectlibre.png -t $out/share/pixmaps
    install -Dm755 resources/projectlibre -t $out/bin
    popd

    substituteInPlace $out/bin/projectlibre \
        --replace-fail "/usr/share/projectlibre" "$out/share/projectlibre"

    wrapProgram $out/bin/projectlibre \
        --prefix PATH : ${lib.makeBinPath finalAttrs.runtimeDeps}

    runHook postInstall
  '';

  meta = {
    description = "Project-Management Software similar to MS-Project";
    homepage = "https://www.projectlibre.com/";
    license = lib.licenses.cpal10;
    mainProgram = "projectlibre";
    maintainers = with lib.maintainers; [
      Mogria
      tomasajt
    ];
    platforms = jre.meta.platforms;
  };
})

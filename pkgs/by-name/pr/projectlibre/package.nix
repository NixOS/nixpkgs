{
  lib,
  stdenv,
  fetchgit,

  ant,
  jdk,
  makeWrapper,
  stripJavaArchivesHook,

  coreutils,
  jre,
  which,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "projectlibre";
  version = "1.9.8";

  src = fetchgit {
    url = "https://git.code.sf.net/p/projectlibre/code";
    rev = "0530be227f4a10c5545cce8d3db20ac5a4d76a66"; # version 1.9.8 was not tagged
    hash = "sha256-eGoPtHy1XfPLnJXNDOMcek4spNKkNyZdby0IsZFZfME=";
  };

  nativeBuildInputs = [
    ant
    jdk
    makeWrapper
    stripJavaArchivesHook
  ];

  runtimeDeps = [
    jre
    coreutils
    which
  ];

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

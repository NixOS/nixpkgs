{ lib
, stdenv
, fetchgit
, ant
, jdk
, stripJavaArchivesHook
, makeWrapper
, jre
, coreutils
, which
}:

stdenv.mkDerivation {
  pname = "projectlibre";
  version = "1.7.0";

  src = fetchgit {
    url = "https://git.code.sf.net/p/projectlibre/code";
    rev = "0c939507cc63e9eaeb855437189cdec79e9386c2"; # version 1.7.0 was not tagged
    hash = "sha256-eLUbsQkYuVQxt4px62hzfdUNg2zCL/VOSVEVctfbxW8=";
  };

  nativeBuildInputs = [
    ant
    jdk
    stripJavaArchivesHook
    makeWrapper
  ];

  buildPhase = ''
    runHook preBuild
    ant -f openproj_build/build.xml
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/{projectlibre/samples,doc/projectlibre}

    pushd openproj_build
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
        --prefix PATH : ${lib.makeBinPath [ jre coreutils which ]}

    runHook postInstall
  '';

  meta = {
    description = "Project-Management Software similar to MS-Project";
    homepage = "https://www.projectlibre.com/";
    license = lib.licenses.cpal10;
    mainProgram = "projectlibre";
    maintainers = with lib.maintainers; [ Mogria tomasajt ];
    platforms = jre.meta.platforms;
  };
}


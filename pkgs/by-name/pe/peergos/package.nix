{
  lib,
  stdenv,
  fetchFromGitHub,
  ant,
  jdk25,
  openjdk8-bootstrap,
  jre,
  stripJavaArchivesHook,
  makeWrapper,
  nix-update-script,
}:

let
  tweetnacl = stdenv.mkDerivation {
    pname = "tweetnacl";
    version = "0-unstable-2025-11-06";

    src = fetchFromGitHub {
      owner = "ianopolous";
      repo = "tweetnacl-java";
      rev = "0cf99e1921b79eb91bc4c27cc15a27e325dbdb75";
      hash = "sha256-RyyC3/XhOhL7UxtPd2WODJgG6mPqkF/KDtvoa8PKWEM=";
    };

    postPatch = ''
      substituteInPlace Makefile \
        --replace-fail gcc cc
    '';

    makeFlags = [ "jni" ];

    nativeBuildInputs = [
      openjdk8-bootstrap # javah
    ];

    installPhase = ''
      install -Dvm644 libtweetnacl.so $out/lib/libtweetnacl.so
    '';
  };
in
stdenv.mkDerivation rec {
  pname = "peergos";
  version = "1.25.0";

  src = fetchFromGitHub {
    owner = "Peergos";
    repo = "web-ui";
    rev = "v${version}";
    hash = "sha256-OA9Wt8nkXaYRu2gE9jyL6CYGv3OQd5uFUZQ1jCxD0KE=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    ant
    jdk25
    stripJavaArchivesHook
    makeWrapper
  ];

  postPatch = ''
    substituteInPlace build.xml \
      --replace-fail '${"\${repository.version}"}' '${version}'
  '';

  buildPhase = ''
    runHook preBuild
    ant dist
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -dm755 $out/share/peergos

    install -Dvm644 server/Peergos.jar \
      $out/share/peergos/peergos.jar

    install -Dvm644 ${tweetnacl}/lib/libtweetnacl.so \
      $out/native-lib/libtweetnacl.so

    cp -R server/webroot $out/share/peergos/webroot

    makeWrapper ${lib.getExe jre} $out/bin/peergos \
      --add-flags "-Djava.library.path=$out/native-lib" \
      --add-flags "-jar $out/share/peergos/peergos.jar"

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/Peergos/web-ui/releases/tag/v${version}";
    description = "P2P, secure file storage, social network and application protocol";
    downloadPage = "https://github.com/Peergos/web-ui";
    homepage = "https://peergos.org/";
    license = [
      lib.licenses.agpl3Only # server
      lib.licenses.gpl3Only # web-ui
    ];
    mainProgram = "peergos";
    maintainers = with lib.maintainers; [
      raspher
      christoph-heiss
    ];
    platforms = lib.platforms.all;
  };
}

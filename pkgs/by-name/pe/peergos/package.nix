{
  lib,
  stdenv,
  fetchFromGitHub,
  ant,
  jdk,
  openjdk8-bootstrap,
  jre,
  stripJavaArchivesHook,
  makeWrapper,
  nix-update-script,
}:

let
  tweetnacl = stdenv.mkDerivation {
    pname = "tweetnacl";
    version = "0-unstable-12-02-2020";

    src = fetchFromGitHub {
      owner = "ianopolous";
      repo = "tweetnacl-java";
      rev = "6d1bde81ea63051750cda40422b62e478b85d2b0";
      hash = "sha256-BDWzDpUBi4UuvxFwA9ton+RtHOzDcWql1ti+cdvhzks=";
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
  version = "1.7.1";
  src = fetchFromGitHub {
    owner = "Peergos";
    repo = "web-ui";
    rev = "v${version}";
    hash = "sha256-gafFkHgTDBBon5fxjZwDGhEPyk6bp2XL4DxAWKtpWzo=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    ant
    jdk
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

    install -Dvm644 server/Peergos.jar $out/share/java/peergos.jar
    install -Dvm644 ${tweetnacl}/lib/libtweetnacl.so $out/native-lib/libtweetnacl.so

    # --chdir as peergos expects to find `libtweetnacl.so` in `native-lib/`
    makeWrapper ${lib.getExe jre} $out/bin/peergos \
      --chdir $out \
      --add-flags "-Djava.library.path=native-lib -jar $out/share/java/peergos.jar"

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

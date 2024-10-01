{
  lib,
  stdenv,
  fetchurl,
  jre,
  makeWrapper,
  nix-update-script,
}:

stdenv.mkDerivation rec {
  pname = "peergos";
  version = "0.20.0";
  src = fetchurl {
    url = "https://github.com/Peergos/web-ui/releases/download/v${version}/Peergos.jar";
    hash = "sha256-Kk0ahAsvfTYkmVZTDE+QhyDFHQFY6lpWhmIOYBeJ1xk=";
  };

  dontUnpack = true;
  dontBuild = true;

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    install -D ${src} $out/share/java/peergos.jar
    makeWrapper ${lib.getExe jre} $out/bin/peergos \
      --add-flags "-jar -Djava.library.path=native-lib $out/share/java/peergos.jar"

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "^(v[0-9.]+)$"
    ];
  };

  meta = {
    changelog = "https://github.com/Peergos/web-ui/releases/tag/v${version}";
    description = "P2p, secure file storage, social network and application protocol";
    downloadPage = "https://github.com/Peergos/web-ui";
    homepage = "https://peergos.org/";
    # peergos have agpt3 license, peergos-web-ui have gpl3, both are used
    license = [
      lib.licenses.agpl3Only
      lib.licenses.gpl3Only
    ];
    mainProgram = "peergos";
    maintainers = with lib.maintainers; [ raspher ];
    platforms = lib.platforms.all;
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
  };
}

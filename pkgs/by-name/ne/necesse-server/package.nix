{
  fetchzip,
  jre,
  lib,
  stdenvNoCC,
}:

stdenvNoCC.mkDerivation rec {
  pname = "necesse-server";
  version = "0.31.1-17664948";
  urlVersion = lib.replaceStrings [ "." ] [ "-" ] version;

  src = fetchzip {
    url = "https://necessegame.com/content/server/${urlVersion}/necesse-server-linux64-${urlVersion}.zip";
    hash = "sha256-H7/fc3zkuEMuv9Uq00TLSLF4rT8+UWsofnuCFrmUtjU=";
  };

  inherit jre;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp -r ./* $out/
    params='-nogui "$@"'
    cat >$out/bin/necesse-server <<EOF
    #! $SHELL -e
    exec $jre/bin/java -jar $out/Server.jar $params
    EOF
    chmod +x $out/bin/necesse-server

    runHook postInstall
  '';

  meta = {
    homepage = "https://necessegame.com/server/";
    description = "Dedicated server for Necesse";
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
    platforms = lib.platforms.linux;
    license = lib.licenses.unfreeRedistributable;
    mainProgram = "necesse-server";
    maintainers = with lib.maintainers; [ cr0n ];
  };
}

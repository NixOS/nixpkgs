{
  fetchzip,
  jre,
  lib,
  stdenvNoCC,
}:

let
  version = "1.2.0-23522718";
  urlVersion = lib.replaceStrings [ "." ] [ "-" ] version;

in
stdenvNoCC.mkDerivation {
  pname = "necesse-server";
  inherit version;

  src = fetchzip {
    url = "https://necesse.pwn.sh/server/necesse-server-linux64-${urlVersion}.zip";
    hash = "sha256-PIguTYULddLKj6PpoSvX3gNSvqrS7oRTOPuwoA0/XOc=";
  };

  # removing packaged jre since we use our own
  postUnpack = ''
    rm -rf "$sourceRoot/jre"
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp -r . $out
    params='-nogui "$@"'
    cat >$out/bin/necesse-server <<EOF
    #! $SHELL -e
    exec ${lib.getExe jre} -jar $out/Server.jar $params
    EOF
    chmod +x $out/bin/necesse-server

    runHook postInstall
  '';

  passthru.updateScript = ./update.sh;

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

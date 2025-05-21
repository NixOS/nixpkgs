{
  stdenvNoCC,
  lib,
  fetchzip,
}:

stdenvNoCC.mkDerivation rec {
  pname = "ripcord";
  version = "0.4.29";

  src = fetchzip {
    url = "https://cancel.fm/dl/Ripcord_Mac_${version}.zip";
    sha256 = "sha256-v8iydjLBjFN5LuctpcBpEkhSICxPhLKzLjSASWtsQok=";
    stripRoot = false;
  };

  dontBuild = true;
  dontFixup = true; # modification is not allowed by the license https://cancel.fm/ripcord/shareware-redistribution/

  installPhase = ''
    runHook preInstall

    mkdir -p $out/Applications
    cp -r $src/Ripcord.app $out/Applications/

    runHook postInstall
  '';

  meta = with lib; {
    description = "Desktop chat client for Slack and Discord";
    homepage = "https://cancel.fm/ripcord/";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    # See: https://cancel.fm/ripcord/shareware-redistribution/
    license = licenses.unfreeRedistributable;
    maintainers = with maintainers; [ mikroskeem ];
    platforms = [ "x86_64-darwin" ];
  };
}

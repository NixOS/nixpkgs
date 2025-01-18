{
  lib,
  fetchzip,
  stdenvNoCC,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "mimikatz";
  version = "2.2.0-20220919";

  src = fetchzip {
    url = "https://github.com/gentilkiwi/mimikatz/releases/download/${finalAttrs.version}/mimikatz_trunk.zip";
    hash = "sha256-wmatI/rEMziBdNiA3HE3MJ0ckdpvsD+LdbB7SKOYdI0=";
    stripRoot = false;
  };

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/windows/mimikatz
    cp -a * $out/share/windows/mimikatz/
    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/gentilkiwi/mimikatz";
    description = "Little tool to play with Windows security";
    license = with licenses; [ cc-by-40 ];
    maintainers = with maintainers; [ d3vil0p3r ];
    platforms = platforms.all;
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
  };
})

{
  lib,
  stdenvNoCC,
  fetchzip,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "fastmail-desktop";
  version = "1.0.0";

  src = fetchzip {
    url = "https://dl.fastmailcdn.com/desktop/production/mac/arm64/Fastmail-${finalAttrs.version}-arm64-mac.zip";
    hash = "sha256-wIWU0F08wEQeLjbZz2LqahfyeOfowC+dDQkeMZI6gbk=";
    stripRoot = false;
  };

  installPhase = ''
    mkdir -p $out/Applications
    cp -R Fastmail.app $out/Applications/
  '';

  dontBuild = true;

  # Fastmail is notarized
  dontFixup = true;

  meta = {
    description = "Dedicated desktop app for Fastmail";
    homepage = "https://www.fastmail.com/blog/desktop-app/";
    license = lib.licenses.unfree;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = [ lib.maintainers.Enzime ];
    platforms = [ "aarch64-darwin" ];
  };
})

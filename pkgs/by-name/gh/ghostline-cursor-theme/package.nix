{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "ghostline-cursor-theme";
  version = "1.1";

  src = fetchFromGitHub {
    owner = "patinhooh";
    repo = "ghostline-cursor-theme";
    rev = "v${finalAttrs.version}";
    hash = "sha256-emllRxawCKiTSseCuoAARs2bG7niyvJU762Y4bDijOQ=";
  };

  installPhase = ''
    mkdir -p $out/share/icons/Ghostline\ Dark
    mv linux/dark/{cursors,index.theme} $out/share/icons/Ghostline\ Dark
  '';

  meta = {
    description = "Ghostline Cursor theme";
    homepage = "https://github.com/patinhooh/ghostline-cursor-theme";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ passeriform ];
  };
})

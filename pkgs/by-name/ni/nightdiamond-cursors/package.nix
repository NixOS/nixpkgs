{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:

stdenvNoCC.mkDerivation {
  pname = "nightdiamond-cursors";
  version = "0-unstable-2026-05-11";

  src = fetchFromGitHub {
    owner = "vimlinuz";
    repo = "NightDiamond-cursors";
    rev = "49650765c3396ccee9ffb796608845d4660d5692";
    hash = "sha256-Ue6dDvNMq1pGfzudt1O8h0pawfKj4FskTGLnpyEp0CM=";
  };

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/icons
    cp -r NightDiamond-* $out/share/icons/
    runHook postInstall
  '';

  meta = {
    homepage = "https://github.com/vimlinuz/NightDiamond-cursors";
    description = "NightDiamond cursor themes";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ vimlinuz ];
  };
}

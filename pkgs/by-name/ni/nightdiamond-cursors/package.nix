{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:

stdenvNoCC.mkDerivation {
  pname = "nightdiamond-cursors";
  version = "0-unstable-2025-09-23";

  src = fetchFromGitHub {
    owner = "santoshxshrestha";
    repo = "NightDiamond-cursors";
    rev = "3ff3c0486430a4901b4d5cbbee87a370aa2b8ce9";
    hash = "sha256-huruHo5w7Qrte1+nIiz+P1xPNDGrv5/eByHwaSlZYwQ=";
  };

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/icons
    cp -r NightDiamond-* $out/share/icons/
    runHook postInstall
  '';

  meta = {
    homepage = "https://github.com/santoshxshrestha/NightDiamond-cursors";
    description = "NightDiamond cursor themes";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ santosh ];
  };
}

{
  lib,
  stdenv,
  etlegacy-assets,
}:

stdenv.mkDerivation {
  pname = "ete-assets";
  version = "0-unstable-2025-08-17";

  dontUnpack = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/lib/ete/etmain
    cp -r ${etlegacy-assets}/lib/etlegacy/etmain/* $out/lib/ete/etmain/
    runHook postInstall
  '';

  meta = {
    description = "Improved Wolfenstein: Enemy Territory Engine";
    homepage = "https://github.com/etfdevs/ETe";
    license = with lib.licenses; [ cc-by-nc-sa-30 ];
    maintainers = with lib.maintainers; [
      ashleyghooper
      drupol
    ];
    platforms = lib.platforms.linux;
  };
}

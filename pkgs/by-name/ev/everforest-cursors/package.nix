{
  lib,
  stdenvNoCC,
  fetchurl,
  nix-update-script,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "everforest-cursors";
  version = "3212590527";

  src = fetchurl {
    url = "https://github.com/talwat/everforest-cursors/releases/download/${finalAttrs.version}/everforest-cursors-variants.tar.bz2";
    hash = "sha256-xXgtN9wbjbrGLUGYymMEGug9xEs9y44mq18yZVdbiuU=";
  };

  sourceRoot = ".";

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/icons
    cp -r ./everforest-cursors* $out/share/icons
    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Everforest cursor theme, based on phinger-cursors";
    homepage = "https://github.com/talwat/everforest-cursors";
    license = lib.licenses.cc-by-sa-40;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.stelcodes ];
  };
})

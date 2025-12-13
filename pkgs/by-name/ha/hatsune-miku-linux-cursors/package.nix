{
  lib,
  stdenvNoCC,
  fetchurl,
  nix-update-script,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "hatsune-miku-cursors";
  version = "1.2.6";

  src = fetchurl {
    url = "https://github.com/supermariofps/hatsune-miku-windows-linux-cursors/releases/download/${finalAttrs.version}/miku-cursor-linux.tar.xz";
    hash = "sha256-ahPuw5KJN1dbw1Q1QQ8nZBDImSRdDKmMf54cwj8fJok=";
  };

  sourceRoot = ".";

  unpackPhase = ''
    tar -xvf $src
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/icons
    cp -r ./miku-cursor-linux $out/share/icons
    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Hatsune Miku cursor theme.";
    homepage = "https://github.com/supermariofps/hatsune-miku-windows-linux-cursors";
    license = lib.licenses.unlicense;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.civilterrorist ];
  };
})
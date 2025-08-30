{
  stdenv,
  lib,
  glibcLocales,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "calamares-nixos-extensions";
  version = "0.3.23";

  src = ./src;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/{etc,lib,share}/calamares
    cp -r modules $out/lib/calamares/
    cp -r config/* $out/etc/calamares/
    cp -r branding $out/share/calamares/

    substituteInPlace $out/etc/calamares/settings.conf --replace-fail @out@ $out
    substituteInPlace $out/etc/calamares/modules/locale.conf --replace-fail @glibcLocales@ ${glibcLocales}

    runHook postInstall
  '';

  meta = with lib; {
    description = "Calamares modules for NixOS";
    homepage = "https://github.com/NixOS/calamares-nixos-extensions";
    license = with licenses; [
      mit
      # assets
      cc-by-40
      cc-by-sa-40
    ];
    maintainers = with maintainers; [ vlinkz ];
    platforms = platforms.linux;
  };
})

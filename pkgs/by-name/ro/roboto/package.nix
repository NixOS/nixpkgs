{
  lib,
  stdenvNoCC,
  fetchzip,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "roboto";
  version = "3.012";

  src = fetchzip {
    url = "https://github.com/googlefonts/roboto-3-classic/releases/download/v${finalAttrs.version}/Roboto_v${finalAttrs.version}.zip";
    stripRoot = false;
    hash = "sha256-J1X5+/pW5HgX6LIqQDaZeRmwdIwEVowzsf5Bg0OQy2M=";
  };

  installPhase = ''
    runHook preInstall

    install -Dm644 unhinted/static/*.ttf -t $out/share/fonts/truetype

    runHook postInstall
  '';

  meta = {
    homepage = "https://github.com/googlefonts/roboto-3-classic";
    description = "This is a variable version of Roboto intended to be a 1:1 match with the official non-variable release from Google";
    longDescription = ''
      This is not an official Google project, but was enabled with generous
      funding by Google Fonts, who contracted Type Network. The Roboto family of
      instances contained 6 weights and two widths of normal, along with italic
      of the regular width.
    '';
    license = lib.licenses.ofl;
    platforms = lib.platforms.all;
    maintainers = [ lib.maintainers.romildo ];
  };
})

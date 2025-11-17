{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "roboto-mono";
  version = "3.001";

  src = fetchFromGitHub {
    owner = "googlefonts";
    repo = "robotomono";
    tag = "v${finalAttrs.version}";
    hash = "sha256-i0r8x4VgaOYW/pYXK+AXw7jMwhA8Hs9VQ1lq5f/xTe0=";
  };

  installPhase = ''
    runHook preInstall
    install -Dm644 fonts/ttf/*.ttf -t $out/share/fonts/truetype/RobotoMono
    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://www.google.com/fonts/specimen/Roboto+Mono";
    description = "Google Roboto Mono fonts";
    longDescription = ''
      Roboto Mono is a monospaced addition to the Roboto type family. Like
      the other members of the Roboto family, the fonts are optimized for
      readability on screens across a wide variety of devices and reading
      environments. While the monospaced version is related to its variable
      width cousin, it doesn't hesitate to change forms to better fit the
      constraints of a monospaced environment. For example, narrow glyphs
      like 'I', 'l' and 'i' have added serifs for more even texture while
      wider glyphs are adjusted for weight. Curved caps like 'C' and 'O'
      take on the straighter sides from Roboto Condensed.
    '';
    license = lib.licenses.ofl;
    platforms = lib.platforms.all;
    maintainers = [ lib.maintainers.romildo ];
  };
})

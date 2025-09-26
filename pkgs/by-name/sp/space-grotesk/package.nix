{
  lib,
  stdenvNoCC,
  fetchzip,
}:

stdenvNoCC.mkDerivation rec {
  pname = "space-grotesk";
  version = "2.0.0";

  src = fetchzip {
    url = "https://github.com/floriankarsten/space-grotesk/releases/download/${version}/SpaceGrotesk-${version}.zip";
    stripRoot = false;
    hash = "sha256-niwd5E3rJdGmoyIFdNcK5M9A9P2rCbpsyZCl7CDv7I8=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/fonts/truetype
    install -Dm644 SpaceGrotesk-${version}/ttf/static/*.ttf $out/share/fonts/truetype/

    runHook postInstall
  '';

  meta = {
    homepage = "https://floriankarsten.github.io/space-grotesk";
    description = "A proportional sans-serif typeface retaining monospace's idiosyncratic details while optimizing for improved readability";
    longDescription = ''
      Space Grotesk is a proportional sans-serif typeface variant based on Colophon
      Foundry's fixed-width Space Mono family (2016). Originally designed by Florian
      Karsten in 2018, Space Grotesk retains the monospace's idiosyncratic details
      while optimizing for improved readability at non-display sizes.
    '';
    changelog = "https://github.com/floriankarsten/space-grotesk/releases/tag/${version}/CHANGELOG.md";
    license = lib.licenses.ofl;
    platforms = lib.platforms.all;
    maintainers = [ lib.maintainers.lavafroth ];
  };
}

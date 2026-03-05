{
  lib,
  stdenv,
  fetchzip,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "space-grotesk";
  version = "2.0.0";

  src = fetchzip {
    url = "https://github.com/floriankarsten/space-grotesk/releases/download/${finalAttrs.version}/SpaceGrotesk-${finalAttrs.version}.zip";
    hash = "sha256-niwd5E3rJdGmoyIFdNcK5M9A9P2rCbpsyZCl7CDv7I8=";
    stripRoot = false;
  };

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/fonts/opentype
    find . -type f \( -name "*.otf" -o -name "*.ttf" \) -exec cp -v {} $out/share/fonts/opentype/ \;
    runHook postInstall
  '';

  meta = with lib; {
    description = "A proportional sans-serif typeface variant based on Space Mono";
    homepage = "https://github.com/floriankarsten/space-grotesk";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = with maintainers; [ qaaxaap ];
  };
})

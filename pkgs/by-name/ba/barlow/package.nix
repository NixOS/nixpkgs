{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:

stdenvNoCC.mkDerivation rec {
  pname = "barlow";
  version = "1.422";

  src = fetchFromGitHub {
    owner = "jpt";
    repo = "barlow";
    tag = version;
    hash = "sha256-FG68o6qN/296RhSNDHFXYXbkhlXSZJgGhVjzlJqsksY=";
  };

  installPhase = ''
    runHook preInstall

    install -Dm644 fonts/otf/*.otf -t $out/share/fonts/opentype
    install -Dm644 fonts/ttf/*.ttf fonts/gx/*.ttf -t $out/share/fonts/truetype
    install -Dm644 fonts/eot/*.eot -t $out/share/fonts/eot
    install -Dm644 fonts/woff/*.woff -t $out/share/fonts/woff
    install -Dm644 fonts/woff2/*.woff2 -t $out/share/fonts/woff2

    runHook postInstall
  '';

  meta = {
    description = "Grotesk variable font superfamily";
    homepage = "https://tribby.com/fonts/barlow/";
    license = lib.licenses.ofl;
    maintainers = [ ];
    platforms = lib.platforms.all;
  };
}
